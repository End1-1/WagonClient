import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wagon_client/web/yandex_geocode.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:wagon_client/screens/app/model.dart';
import 'package:wagon_client/model/address_model.dart';
import 'package:wagon_client/suggest_address_widget.dart';

class SingleAddressSelect extends StatefulWidget {
  final MainWindowModel model;
  final Function callBack;
  double top = 0;

  SingleAddressSelect(this.model, this.callBack);

  @override
  State<StatefulWidget> createState() => _SingleAddressSelect();
}

class _SingleAddressSelect extends State<SingleAddressSelect> {
  var address = AddressStruct(address: '', title: '', point: Point(latitude: 0, longitude: 0));
  final addressTo = TextEditingController();
  final StreamController<List<SuggestItem>?> suggestStream = StreamController.broadcast();
  var ready = false;
  var done = false;

  @override
  Widget build(BuildContext context) {
    if (done) {
      return Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Center(child:  SizedBox(height:30, width: 30, child: CircularProgressIndicator())));
    }
    return Stack(children: [
      Positioned(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          top: widget.top,
          child: Column(
            children: [
              Row(children: [
                IconButton(
                    icon: Image.asset(
                      "images/back.png",
                      height: 20,
                      width: 20,
                    ),
                    onPressed: () {
                      widget.model.showSingleAddress = false;
                      widget.callBack();
                    }),
                Text("Назад"),
                Expanded(child: Container()),
                TextButton(
                    onPressed: () async {
                      setState(() {
                        done = true;
                      });
                      RouteHandler.routeHandler.directionStruct.to
                          .add(address);
                      await widget.model.paintRoute();
                      addressTo.clear();
                      suggestStream.add([]);
                      widget.callBack();
                      done = false;
                    },
                    child: Visibility(
                        visible: ready,
                        child: Text("Готово", style: const TextStyle(color: Colors.black))))
              ]),
              Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.fromBorderSide(
                          BorderSide(color: Colors.black38))),
                  margin: const EdgeInsets.all(5),
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
                      autofocus: widget.model.showSingleAddress,
                      onChanged: (text) {
                        _addressSuggest(context, text);
                      },
                      onTap: () {},
                      decoration: InputDecoration(
                          hintText: "Куда",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                      controller: addressTo..addListener(() {
                        setState((){ready = false;});
                      }),
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
                        addressTo.clear();
                        suggestStream.add([]);
                      },
                    ),
                    /*
                    IconButton(
                        iconSize: 20,
                        icon: Image.asset(
                          "images/placeholder.png",
                          height: 20,
                          width: 20,
                          isAntiAlias: true,
                        ),
                        onPressed: () {}),

                     */
                  ])),
              Expanded(
                  child: StreamBuilder<List<SuggestItem>?>(
                      stream: suggestStream.stream,
                      builder: (context, data) {
                        if (data.data == null || data.data!.isEmpty) {
                          return SizedBox.expand(
                              child: GestureDetector(
                                  onPanEnd: (details) {
                                    if (widget.top < 50) {
                                      setState(() {
                                        widget.top = 0;
                                      });
                                    } else {
                                      widget.model.showSingleAddress = false;
                                      widget.callBack();
                                    }
                                  },
                                  onPanUpdate: (details) {
                                    if (widget.top > 50) {
                                      widget.model.showSingleAddress = false;
                                      widget.callBack();
                                      return;
                                    }
                                    setState(() {
                                      widget.top += details.delta.dy;
                                    });
                                  },
                                  child: Container(
                                    color: Colors.white,
                                  )));
                        }
                        return SingleChildScrollView(
                            child: Column(
                          children: [
                            for (final e in data.data!) ...[
                              SuggestAddressWidget(
                                tapCallback: () async {
                                  addressTo.text = e.title;
                                  addressTo.selection = TextSelection(
                                      baseOffset: e.title.length,
                                      extentOffset: e.title.length);
                                  widget.model.showSingleAddress = false;
                                  late String searchText;
                                  switch (e.type) {
                                    case SuggestItemType.business:
                                      searchText = e.subtitle ?? e.displayText;
                                      break;
                                    default:
                                      searchText = e.searchText;
                                      break;
                                  }
                                  YandexGeocodeHandler yh =
                                      YandexGeocodeHandler();
                                  await yh.geocodeAddress(searchText,
                                      (a) async {
                                        address = AddressStruct(
                                            address: a.address,
                                            title: e.title,
                                            point: a.point);
                                        addressTo.text = e.title;
                                        addressTo.selection = TextSelection(baseOffset: e.title.length, extentOffset:  e.title.length);
                                    setState((){ready = true;});
                                  });
                                },
                                fullAddress: e.subtitle,
                                shortAddress: e.title,
                              )
                            ]
                          ],
                        ));
                      }))
            ],
          ))
    ]);
  }

  Future<void> _addressSuggest(BuildContext context, String text) async {
    text = text.trim();
    if (text.length < 1) {
      return;
    }
    suggestStream.add(null);
    var suggestResultWithSession = await YandexSuggest.getSuggestions(
        text: text,
        boundingBox: BoundingBox(
            northEast: Point(latitude: 56.208970, longitude: 36.750857),
            southWest: Point(latitude: 55.156743, longitude: 38.520913)),
        suggestOptions: SuggestOptions(
            suggestType: SuggestType.geo,
            suggestWords: true,
            userPosition: RouteHandler.routeHandler.lastPoint));
    final v = await suggestResultWithSession.$2;
    suggestStream.add(v.items ?? []);
  }
}
