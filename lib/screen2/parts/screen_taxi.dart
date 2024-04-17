import 'package:flutter/material.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/model/tr.dart';
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
            Expanded(
                child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final c in widget.cars) ...[taxi(context, c)]
                ],
              ),
            ))
          ],
        ));
  }

  Widget taxi(BuildContext context, dynamic c) {
    return
      Stack(children: [InkWell(
          onTap: () {
            if (c['time'] < 0) {
              return;
            }
            widget.model.appState.currentCar = c['class_id'];
            widget.model.appState.currentCar = c['class_id'];
            widget.parentState();
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            decoration: BoxDecoration(
                color: widget.model.appState.currentCar == c['class_id']
                    ? Colors.black12
                    : Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.fromBorderSide(BorderSide(
                    color: widget.model.appState.currentCar == c['class_id']
                        ? Consts.colorRed
                        : Consts.colorOrange))),
            child: Column(
              children: [
                Row(children: [
                  c['time'] < 0 ? Icon(Icons.dangerous_outlined, color: Consts.colorRed) : Consts.car_class_images[widget.model.appState.acType]![
                      c['class_id']]!,
                  Container(child: c['time'] < 0 ? Container() : Text(
                              '${c['time']} ${tr(trMinOneSymbole)}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Consts.colorRed,
                                  fontWeight: FontWeight.bold),
                            ))
                ]),
                Container(
                    constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                    child: Text(
                      c['name'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Consts.colorRed, fontWeight: FontWeight.bold),
                    )),
                Container(
                    constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                    child: Text(
                      '${c['min_price']} ${tr(trDramSymbol)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Consts.colorRed, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          )),

      ]);
  }
}
