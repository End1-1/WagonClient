import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wagon_client/consts.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Stack(children: [
          Column(children: [
            Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                alignment: Alignment.center,
                child: Image.asset(
                  "images/wagonlogooriginal.png",
                  height: 60,
                ))
          ]),
          GestureDetector(
              onTap: _showMenu,
              child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 25),
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Center(
                          child: Wrap(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 5, left: 5, right: 5),
                              child: Divider(
                                height: 2,
                                color: Consts.colorButtonGray,
                                thickness: 3,
                              )),
                          Padding(
                              padding:
                                  EdgeInsets.only(bottom: 5, left: 5, right: 5),
                              child: Divider(
                                height: 2,
                                color: Consts.colorButtonGray,
                                thickness: 3,
                              )),
                          Padding(
                              padding:
                                  EdgeInsets.only(bottom: 5, left: 5, right: 5),
                              child: Divider(
                                height: 2,
                                color: Consts.colorButtonGray,
                                thickness: 3,
                              ))
                        ],
                      ))))),
        ]));
  }

  Widget _stepMenuWidget() {
    return Draggable(
        onDragUpdate: (dt) {
          if (_menuLeft + dt.delta.dx > 0) {
            _menuLeft = 0;
          } else if (_menuLeft + dt.delta.dx < -180) {
            _hideMenu();
            return;
          } else {
            _menuLeft += dt.delta.dx;
          }
          setState(() {});
        },
        onDragEnd: (dt) {
          setState(() {
            if (_menuLeft < 0) {
              _menuLeft = 0;
            }
          });
        },
        feedback: Container(),
        child: Container(
            width: 300,
            color: Colors.white,
            child: Column(children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 19, bottom: 18),
                      child: Text(_getPhoneFormatted(),
                          style: Consts.textStylePhoneHeader))),
              Divider(
                color: Consts.colorRed,
                thickness: 4,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: GestureDetector(
                          onTap: _callHistory,
                          child: Text(tr(trORDERSHISTORY),
                              style: Consts.textStyleMenu)))),
              Divider(
                color: Colors.black38,
                thickness: 1,
              ),

              //PAYMENT
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: GestureDetector(
                          onTap: () {
                            _hideMenu();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) =>
                                        PaymentFullWindow(model)));
                          },
                          child: Text(tr(trPaymentMethods).toUpperCase(),
                              style: Consts.textStyleMenu)))),
              Divider(
                color: Colors.black38,
                thickness: 1,
              ),

              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: GestureDetector(
                          onTap: () {
                            model.currentPage = _pageBeforeChat;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyAddresses()));
                          },
                          child: Text("МОИ АДРЕСА",
                              style: Consts.textStyleMenu)))),
              Divider(
                color: Colors.black38,
                thickness: 1,
              ),

              //CHANGE LANGUAGE
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: GestureDetector(
                          onTap: () {
                            model.currentPage = _pageBeforeChat;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChangeLanguageScreen(
                                        tr(trChangeLanguage).toUpperCase())));
                          },
                          child: Text(tr(trChangeLanguage).toUpperCase(),
                              style: Consts.textStyleMenu)))),
              Divider(
                color: Colors.black38,
                thickness: 1,
              ),

              //SETTINGS
              Visibility(
                  visible: false,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: GestureDetector(
                              onTap: () {
                                model.currentPage = _pageBeforeChat;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SettingsWindow())).then((value) {
                                  if (value != null) {
                                    if (value) {
                                      _socketState = 2;
                                      _socket!.close();
                                      _socket = null;
                                      Consts.setInt("client_id", 0);
                                      Consts.setString("phone", "");
                                      Consts.setString("bearer", "");
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()),
                                              (route) => false);
                                    }
                                  }
                                });
                              },
                              child: Text(tr(trSETTINGS),
                                  style: Consts.textStyleMenu))))),

              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: GestureDetector(
                          onTap: () {
                            model.currentPage = _pageBeforeChat;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Information()));
                          },
                          child:
                          Text(tr(trINFO), style: Consts.textStyleMenu)))),
              Divider(
                color: Colors.black38,
                thickness: 1,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SupportScreen()));
                          },
                          child: Text(tr(trSUPPORT),
                              style: Consts.textStyleMenu)))),
              Divider(
                color: Colors.black38,
                thickness: 1,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: GestureDetector(
                          onTap: () {
                            Consts.setInt("client_id", 0);
                            Consts.setString("phone", "");
                            Consts.setString("bearer", "");
                            if (_socket != null) {
                              _socket!.close();
                              _socket = null;
                            }
                            // if (model.mapController != null) {
                            //   model.mapController!.dispose();
                            //   model.mapController = null;
                            // }
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child:
                          Text(tr(trEXIT), style: Consts.textStyleMenu)))),
              Divider(
                color: Colors.black38,
                thickness: 1,
              ),
              Divider(color: Colors.transparent, height: 10),
              Expanded(child: Container()),
              Image.asset(
                "images/logo_nyt.png",
                width: 100,
              ),
              Divider(height: 30, color: Colors.transparent)
            ])));
  }
}
