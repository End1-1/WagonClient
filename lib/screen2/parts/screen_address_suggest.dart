import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screen2/model/model.dart';

class ScreenAddressSuggest extends StatefulWidget {
  final Screen2Model model;
  final Function parentState;
  ScreenAddressSuggest(this.model, this.parentState);

  @override
  State<StatefulWidget> createState() => _ScreenAddressSuggest();
}

class _ScreenAddressSuggest extends State<ScreenAddressSuggest> {
  final focusFrom = FocusNode();
  final focusTo = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (widget.model.appState.focusFrom) {
      focusFrom.requestFocus();
    } else {
      focusTo.requestFocus();
    }
    return AnimatedPositioned(
        bottom: 0,
        left: 0,
        right: 0,
        top: widget.model.appState.showFullAddressWidget
            ? 50
            : MediaQuery.sizeOf(context).height,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //short line for hide this menu
              Row(
                children: [
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      widget.model.appState.showFullAddressWidget = false;
                      widget.parentState();
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                      color: Colors.black26,
                      height: 5,
                      width: 50,
                    ),
                  ),
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
                        focusNode: focusFrom,
                        decoration: InputDecoration(
                          hintText: tr(trFrom),
                          hintStyle: const TextStyle(color: Colors.black12)
                        ),
                    controller: widget.model.appState.addressFrom,
                    onTap: () {

                    },
                    onChanged: (s) {
                      widget.model.suggest.suggest(s);
                    },
                  )),
                  InkWell(
                    onTap: () {
                      widget.model.appState.addressFrom.clear();
                      focusFrom.requestFocus();
                    },
                    child: Image.asset(
                      'images/close.png',
                      height: 30,
                    ),
                  ),
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

              //ADDRESS TO
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
                        focusNode: focusTo,
                        decoration: InputDecoration(
                            hintText: tr(trTo),
                            hintStyle: const TextStyle(color: Colors.black12)
                        ),
                        controller: widget.model.appState.addressTo,
                        onTap: () {

                        },
                        onChanged: (s) {
                          widget.model.suggest.suggest(s);
                        },
                      )),
                  InkWell(
                    onTap: () {
                      widget.model.appState.addressTo.clear();
                      focusTo.requestFocus();
                    },
                    child: Image.asset(
                      'images/close.png',
                      height: 30,
                    ),
                  ),
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

              StreamBuilder(
                  stream: widget.model.suggestStream.stream,
                  builder: (builder, snapshot) {
                    if (snapshot.data == null) {
                      return Container();
                    }
                    if (snapshot.data is bool) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final i in snapshot.data) ...[
                          Container(
                              height: 40,
                              decoration: const BoxDecoration(),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: InkWell(
                                      onTap: () {
                                        if (focusFrom.hasFocus) {
                                          widget.model.appState.addressFrom
                                              .text =
                                              i.displayText;
                                        } else {
                                          widget.model.appState.addressTo.text = i.displayText;
                                        }
                                        widget.model.suggestStream.add(null);
                                      },
                                      child: Text(i.displayText,
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis))),
                                ],
                              ))
                        ]
                      ],
                    )));
                  }),
            ],
          ),
        ),
        duration: Duration(milliseconds: 300));
  }
}