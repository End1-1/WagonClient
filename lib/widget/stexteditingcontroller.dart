import 'package:flutter/cupertino.dart';

class STextEditingController extends TextEditingController {

  String oldValue = '';
  var backPressed = false;
  Function? l;

  STextEditingController({this.l}) {
    // addListener(() {
    //   backPressed = oldValue.length <= text.length;
    //   if (oldValue != text) {
    //     if (l != null) {
    //       l!();
    //     }
    //   }
    //   oldValue = text;
    // });
  }
}