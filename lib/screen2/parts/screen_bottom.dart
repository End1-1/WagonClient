import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screen2/model/model.dart';

class ScreenBottom extends StatefulWidget {
  final Screen2Model model;
  final Function parentState;

  ScreenBottom(this.model, this.parentState);

  @override
  State<StatefulWidget> createState() => _ScreenBottom();
}

class _ScreenBottom extends State<ScreenBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          //Wallet button
          Container(
              height: 55,
              child: InkWell(
                  onTap: () {
                    widget.model.appState.showChangePayment = true;
                    widget.parentState();
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                          border: Border.fromBorderSide(
                              BorderSide(color: Color(0xFFF2A649))),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Image.asset(
                        'images/wallet.png',
                        height: 30,
                      )))),

          //Order button
          Expanded(
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: InkWell(
                      onTap: () {
                        if (widget.model.appState.acType > 0) {
                          widget.model.requests.initOrder(widget.parentState);
                        }
                      },
                      child: Container(
                        height: 55,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: widget.model.appState.acType == 0 ? Colors.white : Color(0xfff2a649),
                              border: Border.fromBorderSide(
                                  BorderSide(color: Color(0xFFF2A649))),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: widget.model.appState.acType == 0
                              ? Text(
                                  tr(trForOrderChooseService),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Consts.colorRed,
                                      fontWeight: FontWeight.bold),
                                )
                              : Center(child: Text(
                                  tr(trORDER),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            textAlign: TextAlign.center,
                                )))))),

          //Options button
          Container(
              height: 55,
              child: InkWell(
                  onTap: () {
                   widget.model.appState.showRideOptions = !widget.model.appState.showRideOptions;
                   widget.parentState();
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                          border: Border.fromBorderSide(
                              BorderSide(color: Color(0xFFF2A649))),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: SvgPicture.asset('images/arrowoption.svg',
                        height: 30,
                      ))))
        ],
      ),
    );
  }
}
