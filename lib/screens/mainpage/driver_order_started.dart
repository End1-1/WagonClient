import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/model/tr.dart';

class DriverOrderStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Container(
            decoration: Consts.boxDecoration,
            child: Wrap(children: [
              Divider(height: 1, color: Colors.transparent),
              Center(
                  child: Text(tr(trOrderStarted),
                      textAlign: TextAlign.center, style: Consts.textStyle4))
            ])));
  }

}