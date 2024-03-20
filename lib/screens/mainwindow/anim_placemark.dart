import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wagon_client/screen2/model/model.dart';

class AnimPlaceMark extends StatefulWidget {
  final Screen2Model model;
  AnimPlaceMark(this.model);

  @override
  State<StatefulWidget> createState() => _AnimPlaceMark();

}

class _AnimPlaceMark extends State<AnimPlaceMark> {
  @override
  Widget build(BuildContext context) {
    return Visibility(visible: !widget.model.appState.dimVisible, child: Container(
      decoration: BoxDecoration(
        //border: Border.fromBorderSide(BorderSide(color: Colors.indigo, width: 2))
      ),
      width: 60,
      height: 180,
      child: Stack(
        children: [
          AnimatedPositioned(left: 3,
            top: widget.model.appState.mapPressed ? 0 : 15,
              child: Image.asset("images/placemark.png", width: 50), duration: const Duration(milliseconds: 300)),
          Positioned(top: 65, left: 18, child: Image.asset('images/ellipse.png', width: 20, height: 20,))
        ],
      ),
    ));
  }

}