import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.all(5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(children: [
                    IconButton(
                        icon: Image.asset(
                          "images/back.png",
                          height: 20,
                          width: 20,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    Text("ПОДДЕРЖКА")
                  ]),
                  Container(
                      height: 5,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xffcccccc), Colors.white]))),

                  const SizedBox(height: 10),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 90, right: 90, top: 30, bottom: 30),
                      child: Image.asset(
                        "images/logo_nyt.png",
                        height: 80,
                      )),


                  const SizedBox(height: 10),
                  InkWell(
                      onTap: () async {
                        String email = Uri.encodeComponent("info@wagon.am");
                        Uri mail = Uri.parse("mailto:$email");
                        if (await launchUrl(mail)) {
                        } else {
                          //email app is not opened
                        }
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text("E-mail: info@wagon.am",
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              )))),
                  const SizedBox(height: 10),
                  InkWell(
                      onTap: () async {
                        Uri phoneno = Uri.parse('tel:++37491090709');
                        if (await launchUrl(phoneno)) {
                        } else {}
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text("Телефон: +374 (91) 090709",
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              )))),
                  const SizedBox(height: 10),
                  InkWell(
                      onTap: () async {
                        Uri phoneno = Uri.parse('tel:++37491090709');
                        if (await launchUrl(phoneno)) {
                        } else {}
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child:
                              Text("Претензионный отдел:+374 (91) 090709", style: const TextStyle(
                                decoration: TextDecoration.underline,
                              )))),
                  const SizedBox(height: 10),
                ])));
  }
}
