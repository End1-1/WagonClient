import 'package:flutter/material.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screen2/model/model.dart';

class ScreenStatus7 extends StatefulWidget {
  final Screen2Model model;
  final Function parentState;

  ScreenStatus7(this.model, this.parentState);

  @override
  State<StatefulWidget> createState() => _ScreenStatus7();

}

class _ScreenStatus7 extends State<ScreenStatus7> {
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
                  Row(children: [
                    Expanded(child: Text('${widget.model.appState.orderPrice} ${tr(trDramSymbol)}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)))
                  ],),
                  Text(widget.model.appState.dimText),
                  Divider(),

                  //STARS
                  Row(children: [
                    Expanded(
                        child: IconButton(
                            onPressed: () {
                              _iconPressed(1);
                            },
                            icon: widget.model.appState.driverRating >= 1
                                ? Image.asset("images/redstar.png")
                                : Image.asset("images/redstari.png"))),
                    Expanded(
                        child: IconButton(
                            onPressed: () {
                              _iconPressed(2);
                            },
                            icon: widget.model.appState.driverRating >= 2
                                ? Image.asset("images/redstar.png")
                                : Image.asset("images/redstari.png"))),
                    Expanded(
                        child: IconButton(
                            onPressed: () {
                              _iconPressed(3);
                            },
                            icon: widget.model.appState.driverRating >= 3
                                ? Image.asset("images/redstar.png")
                                : Image.asset("images/redstari.png"))),
                    Expanded(
                        child: IconButton(
                            onPressed: () {
                              _iconPressed(4);
                            },
                            icon: widget.model.appState.driverRating >= 4
                                ? Image.asset("images/redstar.png")
                                : Image.asset("images/redstari.png"))),
                    Expanded(
                        child: IconButton(
                            onPressed: () {
                              _iconPressed(5);
                            },
                            icon: widget.model.appState.driverRating >= 5
                                ? Image.asset("images/redstar.png")
                                : Image.asset("images/redstari.png")))
                  ]),

                  Divider(),

                  //FEEDBACK TEXT IF VERY-VERY-VERY ALL BAD
                  if (widget.model.appState.driverRating == 1)...[
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: TextFormField(
                      decoration: InputDecoration(
                        hintText: tr(trCommentForDriver),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)
                        )
                      ),
                      controller: widget.model.appState.feedbackText,
                    ))
                  ],


                  for (final e in widget.model.appState.assassment) ... [
                    InkWell(onTap: (){
                      setState(() {
                        widget.model.appState.assassmentOption = e['option'];
                        widget.model.appState.assassmentText = e['feedback'];
                      });
                    }, child: Row(children: [
                      Checkbox(value: widget.model.appState.assassmentOption == e['option'], onChanged: (v){
                        if (v ?? false) {
                          setState(() {
                            widget.model.appState.assassmentOption = e['option'];
                            widget.model.appState.assassmentText = e['feedback'];
                          });
                        }
                      }),
                      Text(e['feedback'])]))
                    ],

                  //FINISH BUTTON
                  Row(children:[Expanded(
                      child: Container(
                        alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: InkWell(
                              onTap: () {
                                widget.model.requests.endOrder(widget.parentState);
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
                                    tr(trFINISH),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )))))]),


                  Container(height: 30,)
                ],
              ))
        ]);
  }

  void _iconPressed(int rating) {
    setState(() {
      widget.model.appState.driverRating = rating;
    });
  }

}