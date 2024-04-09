import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/screen2/model/model.dart';

class ScreenAcSelected extends StatefulWidget {
  final Screen2Model model;
  final Function parentState;

  ScreenAcSelected(this.model, this.parentState);

  @override
  State<StatefulWidget> createState() => _ScreenAcSelected();

}

class _ScreenAcSelected extends State<ScreenAcSelected> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * .75,
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25)),
            border:
            Border.fromBorderSide(BorderSide(color: Consts.colorRed)),
      ),
        child: Row(
      children: [
        InkWell(onTap: () async {
          widget.model.appState.acType = 0;
          await widget.model.mapController.removePolyline(centerMe: false);
          widget.model.appState.structAddressTod.clear();
          widget.model.appState.addressTo.clear();
          widget.parentState();
        }, child: Image.asset('images/arrowbackward.png',  height:  50,)),
        SvgPicture.asset(
          'images/ac/${widget.model.acTypes.imageName(widget.model.appState.acType)}.svg',
          height: 30,
        ),
        Container(
            constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
            child: Text(
              widget.model.acTypes.typeName(widget.model.appState.acType),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Consts.colorRed, fontWeight: FontWeight.bold),
            ))
      ],
    ));
  }

}