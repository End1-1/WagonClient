import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/screen2/model/model.dart';

class ScreenTaxi extends StatefulWidget {
  final Screen2Model model;
  final Function parentState;
  final List<dynamic> cars;

  ScreenTaxi(this.model, this.cars, this.parentState);

  @override
  State<StatefulWidget> createState() => _ScreenTaxi();

}

class _ScreenTaxi extends State<ScreenTaxi> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
        child: Row(
      children: [
        Expanded(child:
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final c in widget.cars)...[
                taxi(context, c)
              ]
            ],
          ),
        ))
      ],
    ));
  }

  Widget taxi(BuildContext context, dynamic c) {
    return InkWell(
        onTap: () {
          widget.model.appState.selectedTaxi = c['class_id'];
          widget.parentState();
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: BoxDecoration(
              color: widget.model.appState.selectedTaxi == c['class_id'] ? Colors.black12 : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border:
              Border.fromBorderSide(BorderSide(color:  widget.model.appState.selectedTaxi == c['class_id'] ? Consts.colorRed : Consts.colorOrange))),
          child: Column(
            children: [
              Image.memory(base64Decode(c['image']),
                height: 30,
              ),
              Container(
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                  child: Text(
                    c['name'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Consts.colorRed, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ));
  }

}