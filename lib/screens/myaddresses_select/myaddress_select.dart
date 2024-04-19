import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprintf/sprintf.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:wagon_client/addressonmap.dart';
import 'package:wagon_client/screens/myaddresses_select/myaddress_select_state.dart';
import 'package:wagon_client/suggest_address_widget.dart';

import 'myaddress_select_bloc.dart';
import 'myaddress_select_event.dart';
import 'myaddress_select_model.dart';

class MyAddressSelect extends StatelessWidget {
  final MyAddressSelectModel _model = MyAddressSelectModel();

  MyAddressSelect(String name) {
    _model.name = name;
  }

  @override
  Widget build(BuildContext context) {
    var bloc = MyAddressSelectBloc(MyAddressSelectStateIdle());
    return BlocProvider<MyAddressSelectBloc>(
        create: (_) => bloc,
        child: Scaffold(
            body: SafeArea(
                    child: Column(children: [
                                Column(children: [
                                  Row(children: [
                                    IconButton(
                                        icon: Image.asset(
                                          "images/back.png",
                                          height: 20,
                                          width: 20,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                    Text("Назад"),
                                    Expanded(child: Container()),
                                    BlocBuilder<MyAddressSelectBloc,
                                            MyAddressSelectState>(
                                        builder: (context, state) {
                                      return state is MyAddressSelectStateReady
                                          ? InkWell(
                                              onTap: () {
                                                Navigator.pop(
                                                    context, _model.result);
                                              },
                                              child: Text("Готово"))
                                          : Container();
                                    }),
                                    SizedBox(width: 10)
                                  ]),
                                  Container(
                                      height: 5,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                            Color(0xffcccccc),
                                            Colors.white
                                          ]))),
                                ]),
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(children: [
                                      Image.asset(
                                        "images/placeholderlight.png",
                                        height: 15,
                                        width: 15,
                                        isAntiAlias: true,
                                      ),
                                      VerticalDivider(
                                        width: 5,
                                      ),
                                      Expanded(
                                          child: TextFormField(
                                        autofocus: true,
                                        onChanged: (text) async {
                                          await _addressSuggest(context, text);
                                          bloc.add(
                                              MyAddressSelectEventFilter());
                                        },
                                        decoration: InputDecoration(
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none),
                                        controller: _model.addressController,
                                      )),
                                      IconButton(
                                        iconSize: 20,
                                        icon: Image.asset(
                                          "images/close.png",
                                          height: 15,
                                          width: 15,
                                          isAntiAlias: true,
                                        ),
                                        onPressed: () {
                                          _model.addressController.clear();
                                          _model.suggestList.clear();
                                          BlocProvider.of<MyAddressSelectBloc>(
                                                  context)
                                              .add(
                                                  MyAddressSelectEventFilter());
                                        },
                                      ),
                                      IconButton(
                                          iconSize: 20,
                                          icon: Image.asset(
                                            "images/placeholder.png",
                                            height: 20,
                                            width: 20,
                                            isAntiAlias: true,
                                          ),
                                          onPressed: () {
                                            _getFromMap(context);
                                          }),
                                    ])),
                                Divider(
                                  thickness: 1,
                                ),
                                Expanded(child: Container(
                                    color: Colors.white,
                                    child: SingleChildScrollView(
                                        child: BlocBuilder<MyAddressSelectBloc,
                                                MyAddressSelectState>(
                                            buildWhen: (previous, current) =>
                                                current
                                                    is MyAddressSelectStateFilter,
                                            builder: (context, state) {
                                              return Column(children: [
                                                for (int i = 0; i < _model.suggestList.length; i++)
                                                  SuggestAddressWidget(
                                                    shortAddress: _model
                                                        .suggestList[i].title,
                                                    fullAddress: _model
                                                        .suggestList[i]
                                                        .subtitle,
                                                    tapCallback: () {
                                                      _addressTap(context, i);
                                                    },
                                                  )
                                              ]);
                                            })))),
                              ]))
                        ));
  }

  Future<void> _addressSuggest(BuildContext context, String s) async {
    _model.result = null;
    if (s.length < 2) {
      _model.suggestList.clear();
    } else {
      var suggestResultWithSession = await YandexSuggest.getSuggestions(
          text: s.trim(),
          boundingBox: BoundingBox(
              northEast: Point(
                  latitude: _model.lat + 0.06,
                  longitude: _model.lon + 0.06),
              southWest: Point(
                  latitude: _model.lat - 0.06,
                  longitude: _model.lon - 0.06)),
          suggestOptions: SuggestOptions(
              suggestType: SuggestType.unspecified,
              suggestWords: true,
              userPosition: Point(
                  latitude: _model.lat + 0.06,
                  longitude: _model.lon + 0.06)));
      _model.suggestList.clear();
      final v = await suggestResultWithSession.$2;
      _model.suggestList = v.items ?? [];
    }
  }

  void _addressTap(BuildContext context, int index) async {
    SuggestItem item = _model.suggestList[index];
    _model.addressController.text = item.displayText;
    _model.addressController.selection = TextSelection.fromPosition(
        TextPosition(offset: item.displayText.length));
    await _model.geocode.geocodeAddress(item.searchText,
        (double latitude, double longitude) {
      Map<String, dynamic> result = Map();
      result["name"] = _model.name;
      result["short_address"] = item.subtitle;
      result["address"] = item.title;
      result["cords"] = Map<String, double>();
      result["cords"]["lat"] = latitude;
      result["cords"]["lut"] = longitude;
      _model.suggestList.clear();
      _model.result = result;
      BlocProvider.of<MyAddressSelectBloc>(context)
          .add(MyAddressSelectEventReady(result: result));
    });

    // BlocProvider.of<MyAddressSelectBloc>(context)
    //     .add(MyAddressSelectEventFilter());
  }

  void _getFromMap(BuildContext context) async {
    var result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddressOnMap();
    }));
    if (result != null) {
      result["short_address"] =
          sprintf("%s, %s", [result["country"], result["locality"]]);
      result["address"] =
          sprintf("%s, %s", [result["street"], result["house"]]);
      result["cords"] = Map<String, double>();
      result["cords"]["lat"] = result["latitude"];
      result["cords"]["lut"] = result["longitude"];
      result["name"] = _model.name;
      result["needsave"] = 1;
      BlocProvider.of<MyAddressSelectBloc>(context)
          .add(MyAddressSelectEventReady(result: result));
    }
  }
}
