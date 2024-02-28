import 'dart:io';

import 'package:flutter/material.dart';
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
            //FROM
            Row(
              children: [
                Container(
                  child: Image.asset(
                    'images/frompoint.png',
                    height: 20,
                  ),
                ),
                Expanded(
                    child: TextFormField(
                  controller: widget.model.appState.addressFrom,
                  onTap: () {
                    widget.model.appState.showFullAddressWidget = true;
                    widget.parentState();
                  },
                  readOnly: true,
                )),
                InkWell(
                  onTap: () {
                    exit(0);
                  },
                  child: Container(
                    child: Image.asset(
                      'images/mappin.png',
                      height: 20,
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  child: Image.asset(
                    'images/frompoint.png',
                    height: 20,
                  ),
                ),
                Expanded(
                    child: TextFormField(
                  controller: widget.model.appState.addressTo,
                  readOnly: true,
                )),
                InkWell(
                  onTap: () {
                    exit(0);
                  },
                  child: Container(
                    child: Image.asset(
                      'images/mappin.png',
                      height: 20,
                    ),
                  ),
                )
              ],
            ),
            //TO
          ],
        ));
  }
}
