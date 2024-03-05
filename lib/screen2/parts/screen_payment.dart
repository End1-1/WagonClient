import 'package:flutter/material.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screen2/model/model.dart';

class ScreenPayment extends StatefulWidget {
  final Screen2Model model;
  final Function parentState;
  var isCash = false;

  ScreenPayment(this.model, this.parentState);

  @override
  State<StatefulWidget> createState() => _ScreenPayment();

}

class _ScreenPayment extends State<ScreenPayment> {
  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(
      color: Colors.white
    ), child:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [Expanded(child: Container(
              color: Consts.colorOrange,
              child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, top: 40, bottom: 40),
                  child: Image.asset("images/logo_nyt.png")
              )
          ))]),

          Row(children: [
            Checkbox(value: widget.isCash, onChanged: (v){setState(() {
              widget.isCash = v ?? false;
            });}),
            const SizedBox(width: 10,),
            Text(tr(trCash))
          ],),

          Row(children: [
            Checkbox(value: widget.isCash, onChanged: (v){setState(() {
              widget.isCash = v ?? true;
            });}),
            const SizedBox(width: 10,),
            Text(tr(trBankCard))
          ],),

          Row(children: [
            Expanded(child: Container()),
            TextButton(onPressed: (){}, child: Text(tr(trYes))),
            const SizedBox(width: 10),
            TextButton(onPressed: (){}, child: Text(tr(trCancel))),
            Expanded(child: Container())
          ],)
        ],
      ));
  }

}