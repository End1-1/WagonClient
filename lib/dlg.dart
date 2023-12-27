import 'package:flutter/material.dart';

import 'consts.dart';
import 'model/tr.dart';

class Dlg extends StatefulWidget {

  final String msg;
  bool yesno = true;
  bool result = false;

  Dlg({required this.msg});

  @override
  State<StatefulWidget> createState() {
    return DlgState();
  }

  static void show(String msg) async {
    Dlg dlg = Dlg(msg: msg);
    dlg.yesno = false;
    showDialog(context: Consts.navigatorKey.currentContext!, builder: (BuildContext context) {
      return dlg;
    });
  }

  static Future<bool> question (BuildContext context, String msg) async {
    Dlg dlg = Dlg(msg: msg);
    dlg.yesno = true;
    await showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
      return dlg;
    });
    return dlg.result;
  }

}

class DlgState extends State<Dlg> {
  @override
  Widget build(BuildContext context) {
    return Dialog (
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Consts.colorOrange,
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, top: 40, bottom: 40),
                  child: Image.asset("images/logo_nyt.png")
                )
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 40),
                  child: Text(widget.msg, textAlign: TextAlign.center,)
                )
              ),
              Container(
                width: 130,
                  child: Center (
                    child: widget.yesno ? _yesno() : _ok()
                )
              )
            ],
          )
        ],
      )
    );
  }

  Widget _ok() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text("OK"),
    );
  }

  Widget _yesno() {
    return  Row(
      children: [
        TextButton(
            onPressed: () {
              widget.result = true;
              Navigator.of(context).pop();
            },
            child: Text(tr(trYes).toUpperCase())),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(tr(trNo)))
      ],
    );
  }

}