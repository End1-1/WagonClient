import 'package:flutter/material.dart';
import 'package:wagon_client/consts.dart';

class SelectServer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SelectServerState();
  }
}

class SelectServerState extends State<SelectServer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(child: Column(
      children: [
        Text("Select server"),
        Expanded(child: SingleChildScrollView(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: Consts.hosts.length,
                    itemBuilder: (BuildContext c, int index) {
                      final String h = Consts.hosts.elementAt(index);
                      return Row(
                        children: [
                          Container(
                              color: h == Consts.getString("host") ? Colors.yellow : Colors.white, child: Text(h)),
                          Expanded(child: Container()),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  Consts.setString("host", h);
                                });
                              },
                              child: Text("SET")),
                        ],
                      );
                    }))),
      ],
    ))));
  }
}
