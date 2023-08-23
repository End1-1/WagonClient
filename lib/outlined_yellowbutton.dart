import 'package:flutter/material.dart';
import 'package:wagon_client/consts.dart';

class OutlinedYellowButton {
  static OutlinedButton createButtonText(Function f, String text) {
    return createButtonChild(f, Text(text, style: Consts.textStyleButton));
  }

  static OutlinedButton createButtonChild(Function f, Widget c) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom (
            backgroundColor: Consts.colorOrange,
            shape: new RoundedRectangleBorder(
                side: BorderSide(color: Consts.colorWhite, width: 0),
                borderRadius: new BorderRadius.circular(5.0)),
            minimumSize: Size(200, 0)
        ),
        onPressed: (){f();},
        child: Padding(padding: EdgeInsets.all(20.0), child: c));
  }
}