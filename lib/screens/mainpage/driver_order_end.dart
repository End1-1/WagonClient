import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wagon_client/assessments.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/dlg.dart';
import 'package:wagon_client/screens/app/model.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/web/web_assessment.dart';
import 'package:wagon_client/web/web_canceloptions.dart';

class DriverOrderEnd extends StatefulWidget {
  final MainWindowModel model;
  DriverOrderEnd(this.model) {
    model.tracking = false;
  }
  @override
  State<StatefulWidget> createState()  => _DriverOrderEndState();
}

class _DriverOrderEndState extends State<DriverOrderEnd> {
  AssessmentList _assessments = AssessmentList([]);
  Assessment? _assessment;
  bool _driverIsFavorite = false;
  
  @override
  Widget build(BuildContext context) {
    return Flex(direction: Axis.vertical, children: [
      Flex(direction: Axis.horizontal, children: [
        GestureDetector(
            onTap: () {
              setState(() {
                _driverIsFavorite = !_driverIsFavorite;
              });
            },
            child: Container(
              margin: EdgeInsets.only(left: 10, top: 10),
              child: Image.asset(
                  _driverIsFavorite ? "images/heart1.png" : "images/heart0.png",
                  width: 40,
                  height: 40),
            )),
        Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            child: Text(tr(trAppendDriverToFavorite)))
      ]),
      Expanded(child: Container()),
      Container(
          decoration: Consts.boxDecoration,
          child: Column(children: [
            Row(children: [
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        _iconPressed(1);
                      },
                      icon: widget.model.driverRating >= 1
                          ? Image.asset("images/redstar.png")
                          : Image.asset("images/redstari.png"))),
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        _iconPressed(2);
                      },
                      icon: widget.model.driverRating >= 2
                          ? Image.asset("images/redstar.png")
                          : Image.asset("images/redstari.png"))),
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        _iconPressed(3);
                      },
                      icon: widget.model.driverRating >= 3
                          ? Image.asset("images/redstar.png")
                          : Image.asset("images/redstari.png"))),
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        _iconPressed(4);
                      },
                      icon: widget.model.driverRating >= 4
                          ? Image.asset("images/redstar.png")
                          : Image.asset("images/redstari.png"))),
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        _iconPressed(5);
                      },
                      icon: widget.model.driverRating >= 5
                          ? Image.asset("images/redstar.png")
                          : Image.asset("images/redstari.png")))
            ]),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _assessments.list.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          _assessments.setSelected(
                              index, !_assessments.list[index].selected);
                        });
                      },
                      child: Row(children: [
                        Checkbox(
                            activeColor: Consts.colorTaxiBlue,
                            value: _assessments.list[index].selected,
                            onChanged: (bool? v) {
                              setState(() {
                                _assessments.setSelected(index, v!);
                              });
                            }),
                        Expanded(child: Text(_assessments.list[index].name))
                      ]));
                }),
            Visibility(
                visible: widget.model.driverRating > 0 && widget.model.driverRating < 3,
                child: Container(
                    margin: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 10),
                    child: TextField(
                        controller: widget.model.feedbackText,
                        keyboardType: TextInputType.multiline,
                        minLines: 4,
                        maxLines: null,
                        decoration: InputDecoration(
                            hintText: tr(trDescribeProblem),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal)))))),
            Center(
                child: Text(tr(trTotalPaid),
                    textAlign: TextAlign.center, style: Consts.textStyle4)),
            Center(
                child: Text(
                    "${widget.model.events["driver_order_end"]["payload"]["order"]["price"]} ${tr(trDramSymbol)}",
                    textAlign: TextAlign.center,
                    style: Consts.textStyle4)),
            Container(
                margin: EdgeInsets.all(5),
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () {
                      _orderEnd();
                    },
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Consts.colorOrange,
                        shape: RoundedRectangleBorder(
                            side:
                            BorderSide(color: Consts.colorWhite, width: 0),
                            borderRadius: new BorderRadius.circular(5.0))),
                    child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child:
                        Text(tr(trFINISH), style: Consts.textStyleButton))))
          ]))
    ]);
  }

  void _iconPressed(int index) {
    WebAssessments webAssessments = WebAssessments(index);
    webAssessments.request((mp) {
      Map<String, dynamic> mpp = Map();
      mpp["list"] = mp;
      setState(() {
        widget.model.driverRating = index;
        _assessments = AssessmentList.fromJson(mpp);
        _assessments.setSelected(-1, false);
      });
    }, (c, s) {
      Dlg.show(context, "_iconPressed()\r\n" + s);
    });
  }

  void _orderEnd() {
    resetAddresses();
    widget.model.commentFrom.clear();
    widget.model.addressFrom.clear();
    widget.model.addressTo.clear();
    _assessment = _assessments.getSelected();
    if (_assessment == null) {
      _assessment = Assessment("", 0, "", false);
      return;
    }
    WebSendCancelReason webSendAssessment = WebSendCancelReason(
        0,
        widget.model.events["driver_order_end"]["payload"]["order"]["order_id"],
        _assessment!.option_id == 0 ? null : _assessment!.option_id,
        _assessment!.name,
        _assessment!.assessment,
        widget.model.feedbackText.text,
        _driverIsFavorite,
        widget.model.driverRating);
    webSendAssessment.request((mp) {
      widget.model.animateWindow(pageSelectShortAddress, () {
        widget.model.currentState = state_none;
        _assessment = null;
        _assessments.list.clear();
        widget.model.enableTrackingPlace();
        widget.model.centerMeOnMap();
      });
    }, (c, s) {
      Dlg.show(context, s);
    });
  }
  
}