import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screen2/model/model.dart';
import 'package:wagon_client/web/web_cancelsearchtaxi.dart';

class CancelOrderButton extends StatelessWidget {
  final Screen2Model model;
  final Function parentState;

  CancelOrderButton(this.model, this.parentState);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child:


             Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: InkWell(
                    onTap: () {
                      model.requests.cancelSearchTaxi(parentState);

                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: 55,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Color(0xfff2a649),
                            border: Border.fromBorderSide(
                                BorderSide(color: Color(0xFFF2A649))),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5))),
                        child:  Text(
                          tr(trCancel),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )))))
      ],
    );
  }

}