import 'dart:core';
import 'package:flutter/material.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/screens/app/model.dart';
import 'package:wagon_client/model/address_model.dart';

class MultiaddressToScreen extends StatefulWidget {
  Function callback;
  final MainWindowModel model;
  MultiaddressToScreen(this.model, this.callback);

  @override
  State<StatefulWidget> createState() => _MultiaddressToScreen();
}

class _MultiaddressToScreen extends State<MultiaddressToScreen> {
  double rowHeight = 70;
  List<double> positionsList = [];

  _MultiaddressToScreen() {

  }

  @override
  Widget build(BuildContext context) {
    positionsList.clear();
    int routeCount = RouteHandler.routeHandler.directionStruct.to.length;
    for (int i = 0; i < routeCount; i++) {
      positionsList.add(MediaQuery.sizeOf(context).height - 20 -
          (((routeCount - i)) * rowHeight) -
          rowHeight);
    }
    return Stack(
      children: [
        Container(
          color: Colors.white54,
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
        ),
        for (int i = 0;
            i < RouteHandler.routeHandler.directionStruct.to.length;
            i++) ...[
          Positioned(
              top: positionsList[i],
              child: Draggable(
                feedback: _widget(context, i),
                  child:  _widget(context, i),
                onDragUpdate: (d) {
                  print("${positionsList[i]} - ${d.delta.dy} ");
                },
                onDragEnd: (d) {
                  print(d.offset);
                  print(positionsList);
                  double oldY = positionsList[i];
                  double diff = oldY - d.offset.dy;
                  if (diff < 0) {
                    diff += rowHeight;
                  }
                  print("$oldY -> ${d.offset.dy} $diff");
                  if (diff.abs() > 15) {
                    int steps = (diff / rowHeight).truncate();
                    if (diff > 0) {
                      steps = i - steps.abs() - 1;
                      if (steps > positionsList.length - 1) {
                        steps = positionsList.length - 1;
                      }
                      if (steps < 0) {
                        steps = 0;
                      }
                    } else {
                      steps = i + steps.abs() + 1;
                      if (steps < 0) {
                        steps = 0;
                      }
                      if (steps > positionsList.length - 1) {
                        steps = positionsList.length - 1;
                      }
                    }
                    AddressStruct a = RouteHandler.routeHandler.directionStruct.to[i];
                    RouteHandler.routeHandler.directionStruct.to[i] = RouteHandler.routeHandler.directionStruct.to[steps].copyWith();
                    RouteHandler.routeHandler.directionStruct.to[steps] = a.copyWith();
                    setState((){});
                  }
                },
              ))
        ],
        Positioned(
          top: MediaQuery.sizeOf(context).height - rowHeight - 20,
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            color: Colors.white,
            height: rowHeight,
            child: OutlinedButton(
              onPressed: () async {
                widget.model.showMultiAddress = false;
                await widget.model.paintRoute();
                widget.callback();
              },
              style: OutlinedButton.styleFrom(
                fixedSize: Size(double.infinity, rowHeight),
                minimumSize: Size(double.infinity, rowHeight),
                backgroundColor: Consts.colorOrange,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black26, width: 0),
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
              child: Padding(
                  padding: EdgeInsets.only(left: 0.0, top: 0, bottom: 0.0),
                  child: Center(
                      child: Text(
                    "Готово",
                    style: Consts.textStyleButton,
                    textAlign: TextAlign.center,
                  )))),
        ))
      ],
    );
  }

  Widget _widget(BuildContext context, int i) {

    return Material(child: Container(
      //padding: const EdgeInsets.fromLTRB(5, 20, 10, 20),
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.black38))),
        height: rowHeight,
        child: Row(
          children: [
            Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                decoration: const BoxDecoration(
                    color: Colors.black38,
                    borderRadius:
                    BorderRadius.all(Radius.circular(20))),
                child: Text((i + 1).toString())),
            Expanded(child:Text(RouteHandler
                .routeHandler.directionStruct.to[i].title, maxLines: 2, overflow: TextOverflow.ellipsis,),),
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(0, 15, 10, 5),
                child: InkWell(
                    onTap: () {

                    },
                    child: Container(
                        width: 25,
                        height: 25,
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Divider(
                              height: 2,
                              color: Consts.colorButtonGray,
                              thickness: 3,
                            )),
                        Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Divider(
                              height: 2,
                              color: Consts.colorButtonGray,
                              thickness: 3,
                            )),
                        Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Divider(
                              height: 2,
                              color: Consts.colorButtonGray,
                              thickness: 3,
                            ))
                      ],
                    )))),
            Container(
              height: 25,
                width: 25,
                margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                child: InkWell(
                    onTap: () {
                      RouteHandler.routeHandler.directionStruct.to
                          .removeAt(i);
                      setState(() {});
                    },
                    child: Image.asset("images/remove_acc.png"))),
          ],
        )));
  }
}
