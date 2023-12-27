import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wagon_client/dlg.dart';
import 'package:wagon_client/order_cancel_options.dart';
import 'package:wagon_client/screen2/model/model.dart';
import 'package:wagon_client/web/web_cancelaccept.dart';
import 'package:wagon_client/web/web_cancelsearchtaxi.dart';

import '../../consts.dart';
import '../../model/tr.dart';

class DriverSearchText extends StatefulWidget {
  final Screen2Model model;
  DriverSearchText(this.model);
  @override
  State<StatefulWidget> createState() => _DriverSearchTextState();
}

class _DriverSearchTextState extends State<DriverSearchText> {
  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Container(
          height: 200,
          decoration: Consts.boxDecoration,
          child: Column(
            children: <Widget>[
              Text(
                tr(trSEARCHCAR),
                style: Consts.textStyle4,
                textAlign: TextAlign.center,
              ),
              Expanded(
                  child: Center(
                      child: Text(
                        tr(trFindingCar),
                        style: Consts.textStyle5,
                        textAlign: TextAlign.center,
                      ))),
              Container(
                  height: 5,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Color(0xffcccccc)]))),
              Container(
                  margin:
                  EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () {
                        _cancelSearchTaxi();
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Consts.colorOrange,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Consts.colorWhite, width: 0),
                              borderRadius: new BorderRadius.circular(5.0))),
                      child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(tr(trCancel).toUpperCase(),
                              style: Consts.textStyleButton))))
            ],
          ))
    ]);
  }

  void _cancelSearchTaxi() {
    WebCancelSearchTaxi webCancelSearchTaxi = WebCancelSearchTaxi();
    resetAddresses();
    webCancelSearchTaxi.request((mp) {
      mp = mp['data'];
      if (mp['cancel_fee'] == true) {
        Dlg.question(context,
            '${tr(trDriverInPlaceCancelFee)} ${mp["cancel_price"].toString()}')
            .then((value) {
          if (value) {
            WebCancelAccept webCancelAccept = WebCancelAccept(true);
            webCancelAccept.request((mp) {
              print(mp);
              Dlg.show(mp["message"]);
              _cancelOrderOptionList =
                  CancelOrderOptionList.fromJson(mp['data']);
              model.tracking = false;
              model.animateWindow(pageOrderCancelOption, null);
              setState(() {});
            }, (c, s) {
              Dlg.show(context, s);
              _restoreState();
            });
          } else {}
        });
      } else {
        _cancelOrderOptionList = CancelOrderOptionList.fromJson(mp);
        model.tracking = false;
        model.animateWindow(pageOrderCancelOption, null);
        setState(() {});
      }
    }, (c, s) {
      Dlg.show(context, s);
      _restoreState();
    });
  }

  void _sendCancelReason() {
    CancelOrderOption? oo = _cancelOrderOptionList.getSelected();
    if (oo == null) {
      return;
    }
    WebSendCancelReason webSendCancelReason = WebSendCancelReason(
        _cancelOrderOptionList.aborted_id,
        0,
        oo.option,
        oo.name,
        "",
        "",
        false,
        model.driverRating);
    webSendCancelReason.request((mp) {
      model.animateWindow(pageSelectShortAddress, () {
        setState(() {
          model.currentState = state_none;
        });
      });
    }, (c, s) {
      Dlg.show(context, s);
    });
  }
}