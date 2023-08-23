import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wagon_client/enter_phone.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/web/web_parent.dart';
import 'package:wagon_client/web/web_settings.dart';

import 'consts.dart';

class SettingsWindow extends StatefulWidget {
  static GlobalKey scaffoldKey = GlobalKey();

  SettingsWindow() : super(key: scaffoldKey);

  @override
  State createState() {
    return SettingsWindowState();
  }
}

class SettingsWindowState extends State<SettingsWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Divider(
                      color: Colors.transparent,
                      height: 5,
                    ),
                    Row(children: [
                      IconButton(
                          icon: Image.asset(
                            "images/back.png",
                            height: 20,
                            width: 20,
                          ),
                          onPressed: _goBack),
                      Text(tr(trSETTINGS).toUpperCase()),
                    ]),
                    Container(
                        height: 5,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xffcccccc), Colors.white]))),
                    Center(
                        child: Image.asset(
                      "images/settings.png",
                      width: 160,
                      height: 160,
                    )),
                    Divider(height: 30, color: Colors.transparent),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Image.asset(
                              "images/phonecall.png",
                              width: 30,
                              height: 30,
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  tr(trDoNotCall),
                                  style: Consts.textStyle7,
                                )),
                            Expanded(child: Container()),
                            Switch(
                                value: Consts.getBoolean("do_not_call"),
                                onChanged: (value) {
                                  setState(() {
                                    Consts.setBoolean("do_not_call", value);
                                  });
                                })
                          ],
                        )),
                    Divider(height: 30),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Image.asset(
                            "images/gps.png",
                            width: 30,
                            height: 30,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                tr(trShowMyPosition),
                                style: Consts.textStyle7,
                              )),
                          Expanded(child: Container()),
                          Switch(
                              value: Consts.getBoolean("show_me_for_driver"),
                              onChanged: (value) {
                                setState(() {
                                  Consts.setBoolean(
                                      "show_me_for_driver", value);
                                });
                              }),
                        ],
                      ),
                    ),
                    Divider(
                      height: 30,
                    ),
                    Expanded(child: Container()),
                    InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                    contentPadding: const EdgeInsets.all(30),
                                    children: [
                                      Text(
                                          tr(trConfirmToRemoveAccount)),
                                      const SizedBox(height: 30),
                                      Row(
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                              child: Text(tr(trYes))),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(tr(trNo)))
                                        ],
                                      )
                                    ]);
                              }).then((value) {
                            if (value != null) {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      children: [
                                        FutureBuilder(
                                            future: _deleteAccount(context),
                                            builder: (context, snapshot) {
                                              return Container(
                                                  padding:
                                                      const EdgeInsets.all(50),
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            tr(trRemovingAccount)),
                                                        const SizedBox(
                                                            height: 20),
                                                        SizedBox(
                                                            height: 36,
                                                            width: 36,
                                                            child:
                                                                CircularProgressIndicator())
                                                      ]));
                                            })
                                      ],
                                    );
                                  }).then((value) {
                                    if (value !=  null && value) {
                                      Navigator.pop(context, value);
                                    }
                              });
                            }
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.black12))),
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.all(20),
                            alignment: Alignment.centerRight,
                            child: Row(
                              children: [
                                Image.asset(
                                  "images/remove_acc.png",
                                  width: 30,
                                  height: 30,
                                ),
                                Expanded(child: Container(
                                  alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      tr(trRemoveAccount),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 16),
                                    ))),
                              ],
                            )))
                  ],
                ))));
  }

  Future<void> _deleteAccount(BuildContext context) async {
    WebParent('/app/mobile/delete-client', HttpMethod.DELE).request((d) {
      Navigator.pop(SettingsWindow.scaffoldKey.currentContext!, true);
    }, (c, m) {
      Map<String, dynamic> mm = jsonDecode(m);
      Navigator.pop(context);
      showDialog(context: context, builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            children: [
          Text('$c: ${mm['message'] ?? 'Unknow'}')
        ]);
      });
    });
  }

  @override
  void initState() {
    WebSettings.get((mp) {
      setState(() {
        Consts.setBoolean("do_not_call", mp["call"] == 1);
        Consts.setBoolean("show_me_for_driver", mp["show_cord"] == 1);
      });
    }, () {
      Navigator.pop(context);
    });
  }

  void _goBack() {
    WebSettings.save((mp) {
      Navigator.pop(context);
    }, () {
      //Dlg.show("Не удалось сохранить настройки, проверте интернет");
      Navigator.pop(context);
    });
  }
}
