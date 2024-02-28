import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wagon_client/screen2/model/model.dart';

class ScreenAddressSuggest extends StatefulWidget {
  final Screen2Model model;
  final Function parentState;

  ScreenAddressSuggest(this.model, this.parentState);

  @override
  State<StatefulWidget> createState() => _ScreenAddressSuggest();

}

class _ScreenAddressSuggest extends State<ScreenAddressSuggest> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: 0,
        left: 0,
        right: 0,
        top: widget.model.appState.showFullAddressWidget ? 50 : MediaQuery.sizeOf(context).height,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //short line for hide this menu
              Row(
                children: [
                  Expanded(child: Container()),
                  InkWell(onTap: (){
                    widget.model.appState.showFullAddressWidget = false;
                    widget.parentState();
                  }, child:
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                      color: Colors.black26,
                      height: 5,
                      width: 50,
                    ),),
                  Expanded(child: Container()),
                ],
              ),

              //ADDRESS FROM
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                    child: Image.asset(
                      'images/frompoint.png',
                      height: 20,
                    ),
                  ),
                  Expanded(
                      child: TextFormField(
                        controller: widget.model.appState.addressFrom,
                        onTap: () {
                          widget.model.appState.showFullAddressWidget = true;
                          widget.parentState();
                        },
                        onChanged: (s) {
                          widget.model.suggest.suggest(s);
                        },
                      )),
                  InkWell(
                    onTap: () {
                      exit(0);
                    },
                    child: Container(
                      child: Image.asset(
                        'images/mappin.png',
                        height: 20,
                      ),
                    ),
                  )
                ],
              ),

              StreamBuilder(stream: widget.model.suggestStream.stream, builder: (builder, snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }
                if (snapshot.data is bool) {
                  return Center(child: CircularProgressIndicator());
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final i in snapshot.data) ... [
                      Container(
                        height: 40,
                        decoration: const BoxDecoration(

                ),
                          child: Row(
                      children: [
                        InkWell(onTap: (){
                          widget.model.appState.addressFrom.text = i.displayText;
                        }, child: Text(i.displayText, overflow: TextOverflow.ellipsis))
                      ],
                      ))

                    ]
                  ],
                );

    }),

            ],
          ),
        ), duration: Duration(milliseconds: 300));
  }

}