import 'package:flutter/material.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screen2/model/app_state.dart';
import 'package:wagon_client/screen2/model/model.dart';

class ScreenOnMap extends StatefulWidget {
  final Screen2Model model;
  final Function parentState;

  ScreenOnMap(this.model, this.parentState);

  @override
  State<StatefulWidget> createState() => _ScreenOnMap();
}

class _ScreenOnMap extends State<ScreenOnMap> {
  @override
  Widget build(BuildContext context) {
    var comment = widget.model.appState.appState == AppState.asSearchOnMapFrom
        ? tr(trFrom)
        : tr(trTo);
    return Row(mainAxisSize: MainAxisSize.max, children: [
      Container(
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                InkWell(
                    onTap: () {
                      widget.model.appState.appState = AppState.asIdle;
                      widget.parentState();
                    },
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border.fromBorderSide(
                                BorderSide(color: Consts.colorRed)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Image.asset(
                          'images/arrowbackward.png',
                          height: 50,
                        ))),
                Expanded(child: Container())
              ]),
              Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    Text(comment,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20)),
                    TextFormField(
                      readOnly: true,
                      controller: widget.model.appState.addressTemp,
                    ),


                    //READY BUTTON
                    Container(height: 10,),
                    Row(children:[Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: InkWell(
                                onTap: () {
                                  widget.model.appState.dimVisible = true;
                                  widget.parentState();
                                  widget.model.appState.copyTempAddress();
                                  widget.model.requests.initCoin((){
                                    widget.model.appState.appState = AppState.asIdle;
                                    widget.model.appState.dimVisible = false;
                                    widget.parentState();
                                  }, (c, s){
                                    widget.model.appState.dimVisible = false;
                                    widget.model.appState.appState = AppState.asIdle;
                                    widget.parentState();
                                  });
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
                                      tr(trReady),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )))))]),


                    Container(height: 30,)

                  ],
                ),
              )
            ],
          ))
    ]);
  }
}
