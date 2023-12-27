import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/screens/app/model.dart';

class DriverAcceptWidget extends StatefulWidget {
  final MainWindowModel model;
  DriverAcceptWidget(this.model);
  @override
  State<StatefulWidget> createState() => _DriverAcceptWidget();
  
}

class _DriverAcceptWidget extends State<DriverAcceptWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 0, right: 0),
        child: Container(
            decoration: Consts.boxDecoration,
            child: Wrap(children: [
              Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(top: 30, bottom: 30),
                      child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Column(children: [
                            Text(widget.model.currentStateName(),
                                style: Consts.textStyle7),
                            Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Divider(
                                  color: Consts.colorGray,
                                )),
                            Text(
                                '${ widget.model.events["driver_accept"]["payload"]
                                ["car"]["color"]} ${widget.model.events["driver_accept"]["payload"]
                                ["car"]["mark"]} ${widget.model.events["driver_accept"]["payload"]
                                ["car"]["state_license_plate"]}',
                                style: Consts.textStyle7)
                          ])))),
              Padding(
                  padding: EdgeInsets.only(left: 5, bottom: 5, right: 5),
                  child: Container(
                      child: Row(children: [
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  launchUrl(Uri.parse(
                                      "tel://${widget.model.events["driver_accept"]["payload"]["phone"]}"));
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: Image.asset(
                                            "images/call.png",
                                            width: 60,
                                            height: 60,
                                          )),
                                    ]))),
                        if (widget.model.currentPage != pageDriverOnPlace)
                          Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    _cancelSearchTaxi();
                                  },
                                  child: Column(children: [
                                    Center(
                                        child: Image.asset("images/cancel.png",
                                            width: 60, height: 60)),
                                  ]))),
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _pageBeforeChat = widget.model.currentPage;
                                    widget.model.currentPage = pageChat;
                                  });
                                },
                                child: Stack(children: [
                                  Center(
                                      child: Image.asset("images/help.png",
                                          width: 60, height: 60)),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Visibility(
                                          visible:
                                          widget.model.unreadChatMessagesCount > 0,
                                          child: Container(
                                              margin:
                                              const EdgeInsets.only(right: 30),
                                              height: 30,
                                              width: 30,
                                              padding: EdgeInsets.all(3),
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(30))),
                                              child: Text(
                                                  '${widget.model.unreadChatMessagesCount}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold)))))
                                ])))
                      ]))),
              Divider(
                height: 30,
                color: Colors.transparent,
              )
            ])));
  }
  
}
