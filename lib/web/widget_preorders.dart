import 'package:flutter/material.dart';
import 'package:wagon_client/web/web_preorders.dart';

import '../consts.dart';

class Preorders extends StatefulWidget {

  @override
  State createState() {
    return PreordersState();
  }
}

class PreordersState extends State<Preorders> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
        child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Divider(color: Colors.transparent, height: 5,),
                Row(
                  children: [
                    IconButton(icon: Image.asset("images/back.png", height: 20, width: 20,), onPressed: (){Navigator.pop(context);}),
                    Text("ИСТОРИЯ ЗАКАЗОВ")
                  ]
                )
              ]
            )
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
          ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: (){},
                    child: Column (
                      children: [
                        Container(
                            color: Colors.white,
                            margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Image.asset("images/calendar.png", width: 20, height: 20,),
                                ),
                                Text("_historyList.list[index].started"),
                                Expanded(
                                    child: Container()
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 5),
                                ),
                                Text("_historyList.list[index].cost.toString()", style: Consts.textStyle22)
                              ],
                            )
                        ),
                        Divider(color: Colors.black26),
                        Container(
                            color: Colors.white,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Row (
                              children: [
                                Column(
                                  children: [
                                    Image.asset("images/od_black.png", width: 15, height: 15,),
                                    Divider(height: 2, color: Colors.transparent),
                                    Image.asset("images/line.png",width: 10, height: 30,),
                                    Divider(height: 2, color: Colors.transparent),
                                    Image.asset("images/od_red.png", width: 15, height: 15,)
                                  ],
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    child: Column(
                                        children: [
                                          Text("_historyList.list[index].ordered_from"),
                                          Divider(color: Colors.black26, height: 30, thickness: 13,),
                                          Text("_historyList.list[index].ordered_to")
                                        ]
                                    )
                                ),
                              ],
                            )
                        ),
                        Divider(color: Colors.black26, thickness: 1,)
                      ],
                    )
                );
              }
          )
        ]
        )
      )
    );
  }

  @override
  void initState() {
    WebPreorders.get(0, 10, (mp) {
      print(mp);
    }, () {
      Navigator.pop(context);
    });
  }
}