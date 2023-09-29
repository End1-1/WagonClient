import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimPlaceMark extends StatefulWidget {
  var isPressed = false;
  AnimPlaceMark(this.isPressed);

  @override
  State<StatefulWidget> createState() => _AnimPlaceMark();

}

class _AnimPlaceMark extends State<AnimPlaceMark> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.fromBorderSide(BorderSide(color: Colors.indigo, width: 2))
      ),
      width: 60,
      height: 180,
      child: Stack(
        children: [
          AnimatedPositioned(left: 3,
            top: widget.isPressed ? 0 : 15,
              child: Image.asset("images/placemark.png", width: 50), duration: const Duration(milliseconds: 300)),
          Positioned(top: 65, left: 18, child: Image.asset('images/ellipse.png', width: 20, height: 20,))
        ],
      ),
    );
  }

}