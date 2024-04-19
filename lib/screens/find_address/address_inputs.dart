import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sprintf/sprintf.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:wagon_client/model/address_model.dart';

import '../../addressonmap.dart';
import 'find_address_model.dart';
import 'full_address_action.dart';
import 'full_address_bloc.dart';
import 'full_address_state.dart';

class AddressInputs extends StatelessWidget {
  final FindAddressModel model;
  AddressInputs({required this.model});
  
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(children: [
          Padding(
              padding: EdgeInsets.all(5),
              child: Column(children: [
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
                  TextButton(
                      onPressed: () {
                        _done(context);
                      },
                      child: Visibility(
                          visible: model.ready,
                          child: Text("Готово", style: const TextStyle(color: Colors.black))))
                ])
              ])),
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
          Padding(
              padding: EdgeInsets.all(5),
              child: Row(children: [
                Image.asset(
                  "images/red_circle.png",
                  height: 15,
                  width: 15,
                  isAntiAlias: true,
                ),
                VerticalDivider(
                  width: 5,
                ),
                Expanded(
                    child: TextFormField(
                      autofocus: model.selectFrom,
                      onChanged: (text) {
                        _addressSuggest(context, text);
                      },
                      onTap: () {
                        model.selectFrom = true;
                      },
                      decoration: InputDecoration(
                          hintText: "Откуда",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                      controller: model.addressFrom,
                    )),
                IconButton(
                  iconSize: 20,
                  icon: Image.asset(
                    "images/close.png",
                    height: 20,
                    width: 20,
                    isAntiAlias: true,
                  ),
                  onPressed: () {
                    model.selectFrom = true;
                    model.addressFrom.clear();
                    _addressSuggest(context, "");
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
                      model.selectFrom = true;
                      _getFromMap(context);
                    }),
              ])),
          Container(
              padding: EdgeInsets.only(left: 20),
              child: Divider(
                thickness: 1,
              )),
          Padding(
              padding: EdgeInsets.all(5),
              child: Row(children: <Widget>[
                Image.asset(
                  "images/black_circle.png",
                  height: 15,
                  width: 15,
                  isAntiAlias: true,
                ),
                VerticalDivider(
                  width: 5,
                ),
                Expanded(
                    child: TextFormField(
                      onTap: () {
                        model.selectFrom = false;
                      },
                      autofocus: !model.selectFrom,
                      onChanged: (text) {
                        _addressSuggest(context, text);
                      },
                      decoration: InputDecoration(
                          hintText: "Куда",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                      controller: model.addressTo,
                    )),
                IconButton(
                  iconSize: 20,
                  icon: Image.asset(
                    "images/close.png",
                    height: 20,
                    width: 20,
                    isAntiAlias: true,
                  ),
                  onPressed: () {
                    model.selectFrom = false;
                    model.addressTo.clear();
                    _addressSuggest(context, "");
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
                      model.selectFrom = false;
                      _getFromMap(context);
                    }),

              ]))
        ]));
  }

  void _addressSuggest(BuildContext context, String s) async {
    String fr = model.selectFrom ? "from" : "to";
    if (s.isEmpty) {
     model.ready = true;
    }
    if (s.length < 1) {
      BlocProvider.of<FullAddressBloc>(context)
          .actionToState(BlocActionSetList(list: null, mode: AddressListMode.suggestItem));
      BlocProvider.of<FullAddressBloc>(context)
          .actionToState(BlocActionReady(ready: true));
    } else {
      BlocProvider.of<FullAddressBloc>(context)
          .actionToState(BlocActionReady(ready: false));
      var suggestResultWithSession = await YandexSuggest.getSuggestions(
          text: s.trim(),
          boundingBox: BoundingBox(
              northEast: Point(
                  latitude:56.208970,
                  longitude:36.750857),
              southWest: Point(
                  latitude:55.156743,
                  longitude: 38.520913)),
          suggestOptions: SuggestOptions(
              suggestType: SuggestType.geo,
              suggestWords: true,
              userPosition: RouteHandler.routeHandler.lastPoint));
      suggestResultWithSession.$2.then((value) {
        BlocProvider.of<FullAddressBloc>(context)
            .actionToState(BlocActionSetList(list: value.items, mode: AddressListMode.suggestItem));
      });
    }
  }

  void _getFromMap(BuildContext context) async {
    var result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddressOnMap();
    }));
    if (result != null) {
      if (model.selectFrom) {
        RouteHandler.routeHandler.directionStruct.from = AddressStruct(address: result.address, title: result.title, point: result.point);
      } else {
        RouteHandler.routeHandler.directionStruct.to.last = AddressStruct(address: result.address, title: result.title, point: result.point);
      }
     model.addressFrom.text = RouteHandler.routeHandler.addressFrom();
     model.addressTo.text = RouteHandler.routeHandler.addressTo().join(", ");
    }
  }

  void _done(BuildContext context) {
    if (model.addressTo.text.isEmpty) {
      if (RouteHandler.routeHandler.directionStruct.to.isNotEmpty) {
        RouteHandler.routeHandler.directionStruct.to.removeAt(0);
      }
    }
    Navigator.pop(context, true);
  }
}