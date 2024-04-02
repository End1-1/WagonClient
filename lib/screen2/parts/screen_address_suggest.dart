import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wagon_client/model/address_model.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screen2/model/model.dart';

class ScreenAddressSuggest extends StatefulWidget {
  final Screen2Model model;
  final Function parentState;

  ScreenAddressSuggest(this.model, this.parentState);

  @override
  State<StatefulWidget> createState() => _ScreenAddressSuggest();
}

class _ScreenAddressSuggest extends State<ScreenAddressSuggest> {
  final focusFrom = FocusNode();
  final focusTo = FocusNode();
  var x = 0.0;

  @override
  Widget build(BuildContext context) {
    if (widget.model.appState.showFullAddressWidget) {
      if (widget.model.appState.focusFrom) {
        focusFrom.requestFocus();
      } else {
        focusTo.requestFocus();
      }
    } else {
      focusFrom.unfocus();
      focusTo.unfocus();
    }

    return AnimatedPositioned(
        bottom: 0,
        left: 0,
        right: 0,
        top: widget.model.appState.showFullAddressWidget
            ? 50 + x > 50
                ? 50 + x
                : 50
            : MediaQuery.sizeOf(context).height,
        child: GestureDetector(
            onPanUpdate: (d) {
              print(d);
              x += d.delta.dy;
              if (x + 50 < 50) {
                x = 0;
              }
              setState(() {});
            },
            onPanEnd: (d) async {
              if (x > 150) {
                widget.model.appState.showFullAddressWidget = false;
                await widget.model.requests.initCoin(() async {
                  await widget.model.mapController.paintRoute();
                  setState(() {});
                }, (c, s) async {
                  await widget.model.mapController
                      .removePolyline(centerMe: false);
                  setState(() {});
                });
              }
              x = 0;
              setState(() {});
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //short line for hide this menu
                  Row(
                    children: [
                      Expanded(child: Container()),
                      InkWell(
                        onTap: () {
                          widget.model.appState.showFullAddressWidget = false;
                          if (widget.model.appState.focusFrom) {
                            if (widget
                                .model.appState.addressFrom.text.isEmpty) {
                              widget.model.appState.structAddressFrom = null;
                            }
                          } else {
                            if (widget
                                .model.appState.structAddressTod.isEmpty) {
                              widget.model.appState.structAddressTod.clear();
                            }
                          }

                          widget.parentState();
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                          color: Colors.black26,
                          height: 5,
                          width: 50,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),

                  //ADDRESS FROM
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                        child: Image.asset(
                          'images/frompoint.png',
                          height: 15,
                        ),
                      ),
                      Expanded(
                          child: TextFormField(
                        focusNode: focusFrom,
                        decoration: InputDecoration(
                            hintText: tr(trFrom),
                            hintStyle: const TextStyle(color: Colors.black12)),
                        controller: widget.model.appState.addressFrom,
                        onTap: () {},
                        onChanged: (s) {
                          widget.model.suggest.suggest(s);
                        },
                      )),
                      InkWell(
                        onTap: () {
                          widget.model.appState.addressFrom.clear();
                          if (widget.model.appState.structAddressFrom != null) {
                            widget.model.appState.structAddressFrom = null;
                          }
                          focusFrom.requestFocus();
                        },
                        child: Image.asset(
                          'images/close.png',
                          height: 20,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                          child: Image.asset(
                            'images/mappin.png',
                            height: 20,
                          ),
                        ),
                      )
                    ],
                  ),

                  //ADDRESS TO
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                        child: Image.asset(
                          'images/frompoint.png',
                          height: 15,
                        ),
                      ),
                      Expanded(
                          child: TextFormField(
                        focusNode: focusTo,
                        decoration: InputDecoration(
                            hintText: tr(trTo),
                            hintStyle: const TextStyle(color: Colors.black12)),
                        controller: widget.model.appState.addressTo,
                        onTap: () {},
                        onChanged: (s) {
                          widget.model.suggest.suggest(s);
                        },
                      )),
                      InkWell(
                        onTap: () {
                          widget.model.appState.addressTo.clear();
                          if (widget
                              .model.appState.structAddressTod.isNotEmpty) {
                            widget.model.appState.structAddressTod.removeLast();
                          }
                          focusTo.requestFocus();
                        },
                        child: Image.asset(
                          'images/close.png',
                          height: 20,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                          child: Image.asset(
                            'images/mappin.png',
                            height: 20,
                          ),
                        ),
                      )
                    ],
                  ),

                  StreamBuilder(
                      stream: widget.model.suggestStream.stream,
                      builder: (builder, snapshot) {
                        if (snapshot.data == null) {
                          return Container();
                        }
                        if (snapshot.data is bool) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Expanded(
                            child: SingleChildScrollView(
                                child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final i in snapshot.data) ...[
                              Container(
                                  height: 40,
                                  decoration: const BoxDecoration(),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: InkWell(
                                              onTap: () {
                                                if (focusFrom.hasFocus) {
                                                  widget
                                                      .model
                                                      .appState
                                                      .addressFrom
                                                      .text = i.displayText;
                                                  widget.model.appState
                                                          .structAddressFrom =
                                                      AddressStruct(
                                                          address:
                                                              i.displayText,
                                                          title: i.title,
                                                          point: i.center);
                                                } else {
                                                  widget
                                                      .model
                                                      .appState
                                                      .addressTo
                                                      .text = i.displayText;
                                                  if (widget
                                                      .model
                                                      .appState
                                                      .structAddressTod
                                                      .isEmpty) {
                                                    widget.model.appState
                                                        .structAddressTod
                                                        .add(AddressStruct(
                                                            address:
                                                                i.searchText,
                                                            title: i.title,
                                                            point: i.center));
                                                  } else {
                                                    widget.model.appState
                                                            .structAddressTod[0] =
                                                        AddressStruct(
                                                            address:
                                                                i.searchText,
                                                            title: i.title,
                                                            point: i.center);
                                                  }
                                                }
                                                widget.model.suggestStream
                                                    .add(null);
                                                print(i.tags);
                                                if (i.tags.contains('house')) {
                                                  widget.model.appState
                                                          .showFullAddressWidget =
                                                      false;
                                                  if (widget.model.appState
                                                      .isFromToDefined()) {
                                                    widget.model.requests
                                                        .initCoin(() {
                                                      widget.parentState();
                                                    }, (c, s) {});
                                                  } else {
                                                    widget.parentState();
                                                  }
                                                } else {
                                                  if (focusFrom.hasFocus) {
                                                    widget
                                                        .model
                                                        .appState
                                                        .addressFrom
                                                        .text += ', ';
                                                    widget.model.suggest
                                                        .suggest(widget
                                                                .model
                                                                .appState
                                                                .addressFrom
                                                                .text +
                                                            '1');
                                                  } else {
                                                    widget.model.appState
                                                        .addressTo.text += ', ';
                                                    widget.model.suggest
                                                        .suggest(widget
                                                                .model
                                                                .appState
                                                                .addressTo
                                                                .text +
                                                            '1');
                                                  }
                                                }
                                              },
                                              child: Text(i.displayText,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis))),
                                    ],
                                  ))
                            ]
                          ],
                        )));
                      }),
                ],
              ),
            )),
        duration: Duration(milliseconds: 300));
  }
}
