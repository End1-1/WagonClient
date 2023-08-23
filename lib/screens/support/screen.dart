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
                  const SizedBox(height: 10),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 90, right: 90, top: 30, bottom: 30),
                      child: Image.asset(
                        "images/logo_nyt.png",
                        height: 40,
                      )),
                  const SizedBox(height: 10),
                  InkWell(
                      onTap: () async {
                        String email = Uri.encodeComponent("zakaztaxi@nyt.ru");
                        Uri mail = Uri.parse("mailto:$email");
                        if (await launchUrl(mail)) {
                        } else {
                          //email app is not opened
                        }
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text("E-mail: zakaztaxi@nyt.ru",
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              )))),
                  const SizedBox(height: 10),
                  InkWell(
                      onTap: () async {
                        Uri phoneno = Uri.parse('tel:+74959408888');
                        if (await launchUrl(phoneno)) {
                        } else {}
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text("Телефон: +7 (495) 940-8888",
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              )))),
                  const SizedBox(height: 10),
                  InkWell(
                      onTap: () async {
                        Uri phoneno = Uri.parse('tel:+74957803382');
                        if (await launchUrl(phoneno)) {
                        } else {}
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child:
                              Text("Претензионный отдел: +7 (495) 780-3382", style: const TextStyle(
                                decoration: TextDecoration.underline,
                              )))),
                  const SizedBox(height: 10),
                ])));
  }
}
