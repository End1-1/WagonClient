import 'package:flutter/material.dart';
import 'package:wagon_client/model/tr.dart';

import 'consts.dart';

class Information extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea (
        child: Column(
          children: [
            Divider(color: Colors.transparent, height: 5,),
            Row(
              children: [
                IconButton(icon: Image.asset("images/back.png", height: 20, width: 20,), onPressed: (){Navigator.pop(context);}),
                Text(tr(trINFO))
              ]
            ),
            Container(
                height: 5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffcccccc), Colors.white]
                    )
                )
            ),
            Expanded(
              child: Center (
                child: Text(Consts.app_version, textAlign: TextAlign.center,)
              )
            )
          ]
        )
      )
    );
  }
}