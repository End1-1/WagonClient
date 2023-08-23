import 'package:flutter/material.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screens/myaddresses_select/myaddress_select.dart';

import 'consts.dart';
import 'myaddressdetails.dart';
import 'web/web_myaddresses.dart';

class MyAddresses extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAddressesState();
  }
}

class MyAddressesState extends State<MyAddresses> {
  Map<String, dynamic> _addresses = Map();
  List<String> _otherAddresses = [];

  @override
  void initState() {
    super.initState();
    WebMyAddresses.getList(_getList, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
          Divider(
            color: Colors.transparent,
            height: 5,
          ),
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
            Expanded(child: Text(tr(trMyAddresses), textAlign: TextAlign.left))
          ]),
          Container(
              height: 5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffcccccc), Colors.white]))),
          Center(
              child: Image.asset(
            "images/myaddressbg.png",
            width: 200,
            height: 200,
          )),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                  padding: EdgeInsets.only(left: 30, top: 30),
                  child: Text(
                    tr(trMyAddresses),
                    style: Consts.textStyle10,
                  ))),
          Divider(height: 30, color: Colors.transparent),
          GestureDetector(
              onTap: _home,
              child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 50),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Center(
                            child: Container(
                                height: 50,
                                child: Image.asset(
                                  "images/home.png",
                                  width: 25,
                                  height: 25,
                                ))),
                        VerticalDivider(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(children: [
                          Container(
                              color: Colors.white,
                              height: 25,
                              child: Center(
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        tr(trHome),
                                        style: Consts.textStyle7,
                                        textAlign: TextAlign.start,
                                      )))),
                          Visibility(
                              visible: _getText("Дом").isNotEmpty,
                              child: Container(
                                  color: Colors.white,
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(_getText("Дом"),
                                          style: Consts.textStyle5))))
                        ])),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Center(
                                child: Container(
                                    child: Image.asset(
                              "images/arrowright.png",
                              width: 30,
                              height: 30,
                            )))),
                      ]))),
          Divider(height: 30),
          GestureDetector(
              onTap: _work,
              child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 50),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Center(
                            child: Container(
                                height: 50,
                                child: Image.asset(
                                  "images/work.png",
                                  width: 25,
                                  height: 25,
                                ))),
                        VerticalDivider(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(children: [
                          Container(
                              color: Colors.white,
                              height: 25,
                              child: Center(
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        tr(trWork),
                                        style: Consts.textStyle7,
                                        textAlign: TextAlign.start,
                                      )))),
                          Visibility(
                              visible: _getText("Работа").isNotEmpty,
                              child: Container(
                                  color: Colors.white,
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(_getText("Работа"),
                                          style: Consts.textStyle5))))
                        ])),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Center(
                                child: Container(
                                    child: Image.asset(
                              "images/arrowright.png",
                              width: 30,
                              height: 30,
                            )))),
                      ]))),
          Divider(height: 30),
          SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: _otherAddresses.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(children: [
                        Divider(height: 30),
                        GestureDetector(
                            onTap: () {
                              _editAddress(_otherAddresses[index]);
                            },
                            child: Padding(
                                padding: EdgeInsets.only(left: 30, right: 50),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //crossAxisAlignment: CrossAxisAlignment.end,
                                    textBaseline: TextBaseline.ideographic,
                                    children: [
                                      Image.asset(
                                        "images/placemark.png",
                                        width: 25,
                                        height: 25,
                                      ),
                                      VerticalDivider(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Column(children: [
                                        Container(
                                            color: Colors.white,
                                            child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  _otherAddresses[index],
                                                  style: Consts.textStyle7,
                                                  textAlign: TextAlign.start,
                                                ))),
                                        Container(
                                            color: Colors.white,
                                            child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    _getText(
                                                        _otherAddresses[index]),
                                                    style: Consts.textStyle5)))
                                      ])),
                                      Image.asset(
                                        "images/arrowright.png",
                                        width: 30,
                                        height: 30,
                                      ),
                                    ]))),
                      ]);
                    }),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: GestureDetector(
                        onTap: _newAddress,
                        child: Container(
                            color: Colors.black54,
                            child: Padding(
                                padding: EdgeInsets.all(30),
                                child: Text(
                                  tr(trAppendNewAddress),
                                  style: Consts.textStyle9,
                                )))))
              ],
            ),
          )
        ]))));
  }

  void _editAddress(String name) async {
    Map<String, dynamic> result;
    if (_addresses.containsKey(name)) {
      result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyAddressDetails(_addresses[name])));
    } else {
      result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => MyAddressSelect(name)));
    }
    if (result != null) {
      if (result.containsKey("needsave") ||
          result["name"] == "Дом" ||
          result["name"] == "Работа") {
        WebMyAddresses.create(
            result["name"],
            result["short_address"],
            result["address"],
            result["cords"]["lat"],
            result["cords"]["lut"], (d) {
          WebMyAddresses.getList(_getList, null);
        }, null);
      }
    }
    WebMyAddresses.getList(_getList, null);
  }

  void _home() {
    _editAddress("Дом");
  }

  void _work() {
    _editAddress("Работа");
  }

  void _newAddress() async {
    Map<String, dynamic> emptyAddress = new Map<String, dynamic>();
    emptyAddress["name"] = "";
    emptyAddress["address"] = "";
    emptyAddress["short_address"] = "";
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyAddressDetails(emptyAddress)));
    WebMyAddresses.getList(_getList, null);
  }

  String _getText(String name) {
    if (_addresses.containsKey(name)) {
      return _addresses[name]["address"];
    }
    return "";
  }

  void _getList(d) {
    _addresses.clear();
    _otherAddresses.clear();
    for (Map<String, dynamic> m in d) {
      _addresses[m["name"]] = m;
      if (m["name"] != "Дом" && m["name"] != "Работа") {
        _otherAddresses.add(m["name"]);
      }
    }
    setState(() {});
  }
}
