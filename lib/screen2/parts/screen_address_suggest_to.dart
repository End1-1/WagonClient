import 'package:flutter/material.dart';
import 'package:wagon_client/model/address_model.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screen2/model/app_state.dart';
import 'package:wagon_client/screen2/model/model.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class ScreenAddressSuggestTo extends StatefulWidget {
  final Screen2Model model;
  final Function parentState;

  ScreenAddressSuggestTo(this.model, this.parentState);

  @override
  State<StatefulWidget> createState() => _ScreenAddressSuggestTo();
}

class _ScreenAddressSuggestTo extends State<ScreenAddressSuggestTo> {
  var x = 0.0;
  final _focus = FocusNode();
  var tempAddress = AddressStruct(address: '', title: '' , point: Point(longitude: 0, latitude: 0));

  @override
  Widget build(BuildContext context) {
    if (widget.model.appState.showFullAddressWidgetTo) {
      _focus.requestFocus();
    }
    return AnimatedPositioned(
        bottom: 0,
        left: 0,
        right: 0,
        top: widget.model.appState.showFullAddressWidgetTo
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
                widget.model.appState.showFullAddressWidgetTo = false;
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
                          widget.model.appState.showFullAddressWidgetTo = false;
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
                        focusNode: _focus,
                        decoration: InputDecoration(
                            hintText: tr(trTo),
                            hintStyle: const TextStyle(color: Colors.black12)),
                        controller: widget.model.appState.addressTemp,
                        onTap: () {},
                        onChanged: (s) {
                          widget.model.suggest.suggest(s);
                        },
                      )),
                      InkWell(
                        onTap: () {
                          widget.model.appState.addressTemp.clear();
                          tempAddress = AddressStruct(address: '', title: '', point: Point(longitude: 0, latitude: 0));
                        },
                        child: Image.asset(
                          'images/close.png',
                          height: 20,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          widget.model.appState.appState =
                              AppState.asSearchOnMapToMulti;
                          widget.parentState();
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

                  suggestRows(),
                ],
              ),
            )),
        duration: Duration(milliseconds: 300));
  }

  Widget suggestRows() {
    return StreamBuilder(
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
                                  suggestOnTap(i);
                                },
                                child: Text(
                                    i.type == SuggestItemType.toponym
                                        ? i.displayText
                                        : '${i.title} ${i.subtitle}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis))),
                      ],
                    ))
              ]
            ],
          )));
        });
  }

  void suggestOnTap(SuggestItem i) {
    widget.model.appState.addressTemp.text = i.type == SuggestItemType.toponym
        ? i.displayText
        : '${i.title} ${i.subtitle}';

    widget.model.suggestStream.add(null);
    print(i.tags);
    if (i.tags.contains('house') || i.type == SuggestItemType.business) {
      _focus.unfocus();
      widget.model.appState.showFullAddressWidgetTo = false;
      widget.model.appState.structAddressTod.add(AddressStruct(address: i.searchText, title: i.title, point: i.center));
      widget.model.setAddressToText();
      widget.model.requests.initCoin(() {
        widget.parentState();
      }, (c, s) {});
    } else {
      widget.model.appState.addressTemp.text += ', ';
      widget.model.suggest
          .suggest(widget.model.appState.addressTemp.text + '1');
    }
  }
}
