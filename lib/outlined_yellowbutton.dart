import 'package:flutter/material.dart';
import 'package:wagon_client/consts.dart';

class OutlinedYellowButton {
  static OutlinedButton createButtonText(Function f, String text, {Color? bgColor, TextStyle? ts}) {
    if (ts ==  null) {
      ts = Consts.textStyleButton;
    }
    return createButtonChild(f, Text(text, style: ts), bgColor: bgColor);
  }

  static OutlinedButton createButtonChild(Function f, Widget c, {Color? bgColor}) {
    if (bgColor == null) {
      bgColor = Consts.colorOrange;
    }
    return OutlinedButton(
        style: OutlinedButton.styleFrom (
            backgroundColor: bgColor,
            shape: new RoundedRectangleBorder(
                side: BorderSide(color: Consts.colorWhite, width: 0),
                borderRadius: new BorderRadius.circular(5.0)),
            minimumSize: Size(200, 0)
        ),
        onPressed: (){f();},
        child: Padding(padding: EdgeInsets.all(20.0), child: c));
  }
}