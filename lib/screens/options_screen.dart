import 'package:flutter/material.dart';
import 'package:wagon_client/screen2/model/model.dart';

import '../consts.dart';
import 'app/model.dart';

class OptionScreen extends StatelessWidget {
  final Screen2Model model;
  final Function parentState;

  OptionScreen({required this.model, required this.parentState});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 0, right: 0),
        child: Container(
            decoration: Consts.boxDecoration,
            child: Padding(
                padding: EdgeInsets.only(left: 0, right: 10, top: 5),
                child: Wrap(children: [
                  //THERE WAS PREVIOUSLY USED CAR OPTIONS
                  // ListView.builder(
                  //     shrinkWrap: true,
                  //     itemCount: model.carOptions.length,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return GestureDetector(
                  //           onTap: () {
                  //             model.carOptions[index].selected =
                  //                 !model.carOptions[index].selected;
                  //             parentState();
                  //           },
                  //           child: Row(children: [
                  //             Checkbox(
                  //               activeColor: Consts.colorTaxiBlue,
                  //               value: model.selectedCarOptions
                  //                   .contains(model.carOptions[index].id),
                  //               onChanged: (bool? v) {
                  //                 model.carOptions[index].selected =
                  //                     !model.carOptions[index].selected;
                  //                 if (model.carOptions[index].selected) {
                  //                   if (!model.selectedCarOptions
                  //                       .contains(model.carOptions[index].id)) {
                  //                     model.selectedCarOptions
                  //                         .add(model.carOptions[index].id);
                  //                   }
                  //                 } else {
                  //                   if (model.selectedCarOptions
                  //                       .contains(model.carOptions[index].id)) {
                  //                     model.selectedCarOptions
                  //                         .remove(model.carOptions[index].id);
                  //                   }
                  //                 }
                  //                 parentState();
                  //               },
                  //             ),
                  //             Expanded(
                  //                 child: Text(model.carOptions[index].option)),
                  //             Container(
                  //                 margin: EdgeInsets.only(right: 5),
                  //                 child: Text(
                  //                     model.carOptions[index].price.toString()))
                  //           ]));
                  //     }),
                  Container(
                      height: 5,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white, Color(0xffcccccc)]))),
                  Container(
                      margin: EdgeInsets.all(0),
                      width: double.infinity,
                      //height: 60,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 15, bottom: 15),
                          child: OutlinedButton(
                              onPressed: () {
                                //model.appState.loadingData = true;
                                parentState();
                                model.requests.initCoin( () {

                                  parentState();
                                }, () {

                                  parentState();
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: Consts.colorOrange,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.black26, width: 0),
                                      borderRadius:
                                          new BorderRadius.circular(5.0))),
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.0, top: 15.0, bottom: 15.0),
                                  child: Center(
                                      child: SizedBox(
                                          width: 100,
                                          height: 25,
                                          child: Text(
                                                  "ГОТОВО",
                                                  style: Consts.textStyleButton,
                                                  textAlign: TextAlign.center,
                                                )))))))
                ]))));
  }
}
