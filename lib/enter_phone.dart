import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:wagon_client/outlined_yellowbutton.dart';
import 'package:wagon_client/select_server.dart';
import 'package:wagon_client/web/web_enterphone.dart';

import 'consts.dart';
import 'dlg.dart';
import 'enter_sms.dart';
import 'model/tr.dart';

class WEnterPhone extends StatefulWidget {
  WEnterPhone({Key? key}) : super(key: key);

  @override
  _WEnterPhoneState createState() => _WEnterPhoneState();
}

class _WEnterPhoneState extends State<WEnterPhone> {
  final TextEditingController _tePhone = TextEditingController();
  final MaskTextInputFormatter _formatter =
      MaskTextInputFormatter(mask: "(##) ##-##-##");
  var color = Colors.transparent;
  var langTop = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/bg1.png"), fit: BoxFit.cover)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(children: [
                    Expanded(
                        child: Container(
                            decoration:
                                BoxDecoration(color: Consts.colorOrange),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 90, right: 90, top: 10, bottom: 10),
                                child: Image.asset(
                                  "images/wagonwhite.png",
                                  height: 90,
                                ))))
                  ]),
                  Container(
                      margin: EdgeInsets.only(top: 30),
                      child: new Text(tr(trPhoneNumber),
                          style: Consts.textStyle1)),
                  Row(children: [
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.all(30),
                            child: TextFormField(
                              controller: _tePhone,
                              inputFormatters: [_formatter],
                              style: const TextStyle(
                                  fontSize: 30, color: Consts.colorOrange),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  prefixIcon: Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      child: Text('+374',
                                          style: TextStyle(
                                              color: Consts.colorOrange,
                                              fontSize: 30))),
                                  hintText: "(91) 12-34-56",
                                  hintStyle: TextStyle(
                                      fontSize: 30, color: Consts.colorWhite2),
                                  enabledBorder: Consts.underlineInputBorder1,
                                  focusedBorder: Consts.underlineInputBorder1),
                            )))
                  ]),
                  Container(
                      margin: EdgeInsets.all(0),
                      child:
                          Text(tr(trPrivatePolicy), style: Consts.textStyle2)),
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
                    child: Row(
                      children: [
                        Expanded(child: Container()),
                        new Text(tr(trPressNextIfAgree),
                            style: Consts.textStyle3),
                        new Text(tr(trAgreements), style: Consts.textStyle2),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(30),
                      child: OutlinedYellowButton.createButtonText(
                          _nextPressed, tr(trNEXT).toUpperCase())),
                  Expanded(child: Container()),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      InkWell(
                          onTap: () {
                            setState(() {
                              color = color == Colors.transparent
                                  ? Colors.black54
                                  : Colors.transparent;
                            });
                          },
                          child: Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 30, 30),
                              child: Text(currentLanguage(),
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white)))),
                    ],
                  )
                ]),
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                Expanded(child: Container()),
                InkWell(
                    onTap: () {
                      setState(() {
                        langTop = 140;
                        color = color == Colors.transparent
                            ? Colors.black54
                            : Colors.transparent;
                      });
                    },
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 30, 30),
                        child: Text(currentLanguage(),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white)))),
              ],
            )
          ],
        ),
        Visibility(
            visible: color != Colors.transparent,
            child: AnimatedContainer(
                width: double.infinity,
                height: double.infinity,
                color: color,
                duration: const Duration(milliseconds: 500),
                alignment: Alignment.bottomCenter,
                child: Container())),
        AnimatedPositioned(
            width: MediaQuery.sizeOf(context).width,
            top: MediaQuery.sizeOf(context).height - langTop,
            height: 140,
            duration: const Duration(milliseconds: 800),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Text(tr(trLanguage), style: const TextStyle()),
                  Divider(
                    color: Colors.black54,
                  ),
                  for (final e in trLangList) ...[
                    InkWell(
                        onTap: () {
                          setState(() {
                            Consts.setString("lang", e.title);
                            color = Colors.transparent;
                            langTop = 0;
                          });
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              e.image,
                              height: 20,
                              width: 20,
                            ),
                            Text(e.name),
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    )
                  ]
                ],
              ),
            ))
      ])),
    );
  }

  void _nextPressed() async {
    String s = '+7${_tePhone.text.replaceAll("+", "")}';
    s = s.replaceAll("-", "");
    s = s.replaceAll("(", "");
    s = s.replaceAll(")", "");
    s = s.replaceAll(" ", "");
    if (s.contains("9999999999")) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SelectServer()));
      return;
    }
    if (s.length < 8) {
      Dlg.show(tr(trIncorrectPhoneNumber));
      return;
    }
    s = '+37477019107';
    Consts.setString("phone", s);
    WebEnterPhone webEnterPhone =
        WebEnterPhone(phone: Consts.getString("phone"));
    webEnterPhone.request((mp) {
      Consts.setString("sms_message", mp['message']);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WEnterSMS()));
    }, (c, s) {
      Dlg.show(s);
    });
  }
}
