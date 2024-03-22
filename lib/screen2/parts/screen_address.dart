import 'dart:io';

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
                child:  Row(
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
                      decoration: InputDecoration(
                          hintText: tr(trFrom)
                      ),
                )),
                InkWell(
                  onTap: () {
                    widget.model.appState.appState = AppState.asSearchOnMapFrom;
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
                child:  Row(
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
                      onTap: (){
                        widget.model.appState.showFullAddressWidget = true;
                        widget.model.appState.focusFrom = false;
                        widget.parentState();
                      },
                  controller: widget.model.appState.addressTo,
                  readOnly: true,
                      decoration: InputDecoration(
                        hintText: tr(trTo)
                      ),
                )),
                InkWell(
                  onTap: () {
                    widget.model.appState.appState = AppState.asSearchOnMapTo;
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
