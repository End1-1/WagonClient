import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:wagon_client/outlined_yellowbutton.dart';
import 'package:wagon_client/screen2/screen/screen.dart';
import 'package:wagon_client/web/web_entersms.dart';

import 'consts.dart';
import 'dlg.dart';
import 'model/tr.dart';

class WEnterSMS extends StatefulWidget {
  WEnterSMS({Key? key}) : super(key: key);

  @override
  _WEnterSMSState createState() => _WEnterSMSState();
}

class _WEnterSMSState extends State<WEnterSMS> with CodeAutoFill {
  TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listenForCode();
    // SmsRetrieved.getAppSignature().then((value) {
    //   print("app signature $value");
    // });
  }

  @override
  void dispose() {
    super.dispose();
    unregisterListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/bg1.png"), fit: BoxFit.cover)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Row(children: [
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(color: Consts.colorOrange),
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
                child: Center(
                    child: Text(
                  Consts.getString("sms_message"),
                  style: Consts.textStyle3,
                  textAlign: TextAlign.center,
                ))),
            Divider(height: 30, color: Colors.transparent),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: PinInputTextField(
                autoFocus: true,
                controller: _pinController,
                pinLength: 6,
                decoration: BoxLooseDecoration(
                  strokeColorBuilder: FixedColorBuilder(Colors.white),
                  textStyle: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onChanged: _codeChanged,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(top: 30.0),
                child: Center(
                    child: new Text(tr(trSendSMSAgain).toUpperCase(),
                        style: Consts.textStyle2)),
              ),
            ),
            Container(
                margin: EdgeInsets.all(30),
                child: Center(
                    child: OutlinedYellowButton.createButtonText(
                        _nextPressed, tr(trNEXT).toUpperCase())))
          ]),
        ),
      )),
    );
  }

  void _nextPressed() async {
    //final fcmToken = await FirebaseMessaging.instance.getToken();
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

  void _codeChanged(String otpCode) {
    if (_pinController.text.length != 6) {
      return;
    }
    //_nextPressed();
  }

  @override
  void codeUpdated() {
    _pinController.text = code!;
    _nextPressed();
  }
}
