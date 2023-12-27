import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/order_cancel_options.dart';

class DriverOrderCancelOptionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DriverOrderCancelOptionState();
}

class _DriverOrderCancelOptionState extends State<DriverOrderCancelOptionScreen> {
  CancelOrderOptionList _cancelOrderOptionList = CancelOrderOptionList(0, []);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Container(
            decoration: Consts.boxDecoration,
            child: Wrap(children: [
              Column(children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: _cancelOrderOptionList.options.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              _cancelOrderOptionList.setSelected(
                                  index,
                                  !_cancelOrderOptionList
                                      .options[index].selected);
                            });
                          },
                          child: Row(children: [
                            Checkbox(
                                activeColor: Consts.colorTaxiBlue,
                                value: _cancelOrderOptionList
                                    .options[index].selected,
                                onChanged: (bool? v) {
                                  setState(() {
                                    _cancelOrderOptionList.setSelected(
                                        index, v!);
                                  });
                                }),
                            Expanded(
                                child: Text(
                                    _cancelOrderOptionList.options[index].name))
                          ]));
                    }),
                Container(
                    height: 5,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white, Color(0xffcccccc)]))),
                Container(
                    margin: EdgeInsets.only(
                        left: 10, right: 10, top: 15, bottom: 15),
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () {
                          _sendCancelReason();
                        },
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Consts.colorOrange,
                            shape: RoundedRectangleBorder(
                                side:
                                BorderSide(color: Colors.black26, width: 0),
                                borderRadius: new BorderRadius.circular(5.0))),
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: 0.0, top: 15.0, bottom: 15.0),
                            child: Center(
                                child: Text(
                                  tr(trSend).toUpperCase(),
                                  style: Consts.textStyleButton,
                                  textAlign: TextAlign.center,
                                )))))
              ])
            ])));
  }

}