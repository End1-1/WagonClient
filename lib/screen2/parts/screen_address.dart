import 'package:flutter/material.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screen2/model/app_state.dart';
import 'package:wagon_client/screen2/model/model.dart';

class ScreenAddress extends StatefulWidget {
  final Screen2Model model;
  final Function parentState;

  ScreenAddress(this.model, this.parentState);

  @override
  State<StatefulWidget> createState() => _ScreenAddress();
}

class _ScreenAddress extends State<ScreenAddress> {
  @override
  Widget build(BuildContext context) {
    if (widget.model.appState.acType == 0) {
      return Container();
    }
    return Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            //ADDRESS FROM
            Visibility(
                visible: widget.model.appState.acType > 0,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Image.asset(
                        'images/frompoint.png',
                        height: 15,
                      ),
                    ),
                    Expanded(
                        child: TextFormField(
                      controller: widget.model.appState.addressFrom,
                      onTap: () {
                        widget.model.appState.showFullAddressWidget = true;
                        widget.model.appState.focusFrom = true;
                        widget.parentState();
                      },
                      readOnly: true,
                      decoration: InputDecoration(hintText: tr(trFrom)),
                    )),
                    InkWell(
                      onTap: () {
                        widget.model.appState.appState =
                            AppState.asSearchOnMapFrom;
                        widget.parentState();
                      },
                      child: Container(
                        child: Image.asset(
                          'images/mappin.png',
                          height: 20,
                        ),
                      ),
                    )
                  ],
                )),

            //ADDRESS TO
            Visibility(
                visible: widget.model.appState.acType > 0,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Image.asset(
                        'images/frompoint.png',
                        height: 15,
                      ),
                    ),
                    Expanded(
                        child: TextFormField(
                      onTap: () {
                        if (widget.model.appState.structAddressTod.length < 2) {
                          widget.model.appState.showFullAddressWidget = true;
                          widget.model.appState.focusFrom = false;
                          widget.parentState();
                        } else {
                          widget.model.appState.showMultiAddress = true;
                          widget.parentState();
                        }
                      },
                      controller: widget.model.appState.addressTo,
                      readOnly: true,
                          minLines: 1,
                          maxLines: 4,
                      decoration: InputDecoration(hintText: tr(trTo)),
                          style: widget.model.appState.structAddressTod.length > 1 ?
                          const TextStyle(fontSize: 14 ) :
                              const TextStyle(fontSize: 16),
                    )),
                    if (widget.model.appState.structAddressTod.isNotEmpty &&
                        widget.model.appState.structAddressTod.length < 4) ...[
                      InkWell(
                        onTap: () {
                          widget.model.appState.showFullAddressWidgetTo = true;
                          widget.model.appState.addressTemp.clear();
                          widget.parentState();
                        },
                        child: Container(
                          child: Image.asset(
                            'images/plus.png',
                            height: 20,
                          ),
                        ),
                      )
                    ],
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        widget.model.appState.appState =
                            AppState.asSearchOnMapTo;
                        widget.parentState();
                      },
                      child: Container(
                        child: Image.asset(
                          'images/mappin.png',
                          height: 20,
                        ),
                      ),
                    )
                  ],
                )),
            //TO
          ],
        ));
  }
}
