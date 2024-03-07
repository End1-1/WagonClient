import 'package:flutter/material.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/screen2/model/model.dart';

class ScreenStatus4 extends StatefulWidget {
  final Screen2Model model;
  final Function parentState;

  ScreenStatus4(this.model, this.parentState);

  @override
  State<StatefulWidget> createState() => _ScreenStatus4();
}

class _ScreenStatus4 extends State<ScreenStatus4> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
        children: [
      Container(
        width: MediaQuery.sizeOf(context).width,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.model.appState.dimText),
              Text(widget.model.appState.driverName),
              Image.network(
                  'https://${Consts.host()}${widget.model.appState.driverPhoto}', height: 100,),
              Container(height: 30,)
            ],
          ))
    ]);
  }
}
