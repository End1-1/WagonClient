import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppScreen extends StatelessWidget {
  final String title;
  AppScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
              Expanded(child: Text(title, textAlign: TextAlign.left))
            ]),
            Container(
                height: 5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffcccccc), Colors.white]))),
            for (final w in body())...[
              w
            ]
          ],
        ),
      ),
    );
  }

  List<Widget> body();
}

