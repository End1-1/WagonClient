import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/dlg.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screen2/screen/screen.dart';
import 'package:wagon_client/web/web_entersms.dart';

class SmsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SmsScreen();
}

class _SmsScreen extends State<SmsScreen> with SingleTickerProviderStateMixin {
  var _visible = false;
  late AnimationController _backgrounController;
  TextEditingController _pinController = TextEditingController();
  late Animation<Color?> background;
  Animation<double?>? langPos;
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _backgrounController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    background = TweenSequence<Color?>(
      [
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: Colors.transparent,
            end: Colors.black54,
          ),
        ),
      ],
    ).animate(_backgrounController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body:  SafeArea(
                    child: Stack(children:[ Column(
                      children: [
                        const SizedBox(height: 20),
                        //LANGUAGE
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            InkWell(onTap:(){Navigator.pop(context);}, child: Image.asset('images/login/back.png', height: 30,)),
                            Expanded(child: Container()),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    _visible = true;
                                    _backgrounController.reset();
                                    _backgrounController.forward();
                                  });
                                },
                                child: Row(children: [
                                  Image.asset('images/login/translate.png',
                                      height: 30),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(currentLanguage(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xffBF2A61))),
                                  const SizedBox(width: 20),
                                ]))
                          ],
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        //CAROUSEL
                        Container(
                          // height: MediaQuery.sizeOf(context).height,
                          // width: MediaQuery.sizeOf(context).width,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Image.asset(
                                'images/login/wp1.png',
                                height: 160,
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  Expanded(child: Container()),
                                  Text('Մուտքագրեք ${Consts.getString('phone')}\n'
                                  'հեռախոսահամարին ուղարկված\n'
                                  'SMS կոդը' ,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Color(0xffBE2A60),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  Expanded(child: Container()),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  Container(width: 40),
                                  Expanded(child: Container(margin: const EdgeInsets.all(00),
                                  child: PinInputTextField(

                                    onChanged: (v) {
                                      if (v.length == 6) {
                                        _focus.unfocus();

                                      }
                                    },
                                    autoFocus: true,
                                    focusNode: _focus,
                                    controller: _pinController,
                                    pinLength: 6,
                                    keyboardType: TextInputType.number,
                                    decoration: UnderlineDecoration(
                                      gapSpace: 30,
                                      colorBuilder:
                                          FixedColorBuilder(Colors.black26),
                                      textStyle: TextStyle(
                                          color: Color(0xffBE2A60), fontSize: 28),
                                    ),
                                  ))),
                                  Container(width: 40),
                                ],
                              ),
                              Divider(),
                              const SizedBox(height: 60),
                            ],
                          ),
                        ),
                        //ENTER BUTTON
                        Row(
                          children: [
                            Expanded(child: Container()),
                            InkWell(
                                onTap: () {
                                  _nextPressed();
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.7,
                                  height: 60,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Color(0xffBF2A61)),
                                  child: Text(tr(trEnter).toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                )),
                            Expanded(child: Container()),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                      _dimWidget(context),
                      _langWidget(context)
                      ]),
                  )
                );
  }

  Widget _dimWidget(BuildContext context) {
    return Visibility(
        visible: _visible,
        child: AnimatedBuilder(
          animation: _backgrounController,
          builder: (BuildContext context, Widget? child) {
            return GestureDetector(
                onTap: () {
                  _backgrounController.reverse().whenComplete(() {
                    setState(() {
                      _visible = false;
                    });
                  });
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  color: background.value,
                ));
          },
        ));
  }

  Widget _langWidget(BuildContext context) {
    return Visibility(
        visible: _visible,
        child: AnimatedBuilder(
          animation: _backgrounController,
          builder: (BuildContext context, Widget? child) {
            return Positioned(
                height: 160,
                top: langPos!.value,
                width: MediaQuery.sizeOf(context).width,
                child: Container(
                    color: Colors.white,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(tr(trLanguage))
                          ]),
                          Divider(),
                          for (final e in trLangList) ...[
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    Consts.setString("lang", e.title);
                                    _backgrounController
                                        .reverse()
                                        .whenComplete(() {
                                      setState(() {
                                        _visible = false;
                                      });
                                    });
                                  });
                                },
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Image.asset(
                                      e.image,
                                      height: 25,
                                      width: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(e.name),
                                  ],
                                )),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ])));
          },
        ));
  }

  void _nextPressed() async {
    if (_pinController.text.length < 4) {
      return;
    }
    WebEnterSms webEnterSms = WebEnterSms(
        phone: Consts.getString("phone"),
        sms: _pinController.text,
        fcmtoken: 'fcmToken');
    webEnterSms.request((mp) async {
      Consts.setString("bearer", mp['data']['token']);
      Consts.setInt("client_id", mp['data']['client_id']);
      Consts.setString("fcmtoken", '');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Screen2(),
        ),
        (route) => false,
      );
    }, (c, s) {
      try {
        Map<String, dynamic> msg = jsonDecode(s);
        Dlg.show(msg['message']);
        return;
      } catch (e) {
        print(e.toString());
      }
      Dlg.show(s);
    });
  }
}
