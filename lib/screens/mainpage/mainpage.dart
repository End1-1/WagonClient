import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wagon_client/model/address_model.dart';
import 'package:wagon_client/screen2/model/model.dart';
import 'package:wagon_client/widget/car_type.dart';

import '../../consts.dart';
import '../app/model.dart';
import '../../model/tr.dart';

class FirstPage extends StatefulWidget {
  final Screen2Model model;

  FirstPage({required this.model});

  @override
  State<StatefulWidget> createState() => _FirstPageState(model);
}


class _FirstPageState extends State<FirstPage> {
  final Screen2Model model;

  _FirstPageState(this.model);

  @override
  Widget build(BuildContext context) {
    // if (model.mapController != null) {
    //   if (RouteHandler.routeHandler.routeNotDefined()) {
    //     model.enableTrackingPlace();
    //   }
    //   if (model.addressFrom.text.isEmpty && model.init) {
    //     Geolocator.getCurrentPosition().then((value) {
    //       model.geocode
    //           .geocode(value.latitude, value.longitude, model.setAddressFromTo);
    //     });
    //   }
    // }
    Widget w1 = Wrap(children: [
      Align(
          alignment: Alignment.topRight,
          child: Container(
              margin: EdgeInsets.only(right: 20, bottom: 100),
              child: IconButton(
                  onPressed: (){}, //model.centerMeOnMap,
                  icon: Image.asset("images/picklocation.png")))),
      Container(
          decoration: Consts.boxDecoration,
          child: Column(children: [
            //SERVICE TYPES
            Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                width: MediaQuery
                    .sizeOf(context)
                    .width,
                height: 120,
                child: CarTypeList()),

            //FROM
            Row(
              children: [
                Container(
                  height: 20,
                )
              ],
            ),
            const Divider(
              height: 2,
            ),
            Padding(
                padding: EdgeInsets.all(5),
                child: Row(children: <Widget>[
                  Image.asset(
                    "images/frompoint.png",
                    height: 15,
                    width: 15,
                    isAntiAlias: true,
                  ),
                  VerticalDivider(
                    width: 10,
                  ),
                  Expanded(
                      child: TextFormField(
                        readOnly: true,
                        onTap: () {
                          // model.selectRoute(context, true);
                          // if (model.currentPage == pageSelectCar) {
                          //   model.loadingData = true;
                          //   parentState();
                          //   model.initCoin(context, () {
                          //     model.loadingData = false;
                          //     parentState();
                          //   }, () {
                          //     model.loadingData = false;
                          //     parentState();
                          //   });
                          // }
                        },
                        decoration: InputDecoration(
                            hintText: tr(trFrom),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                        controller: model.appState.addressFrom,
                      )),
                  IconButton(
                    icon: Image.asset(
                      "images/mapdraw.png",
                      height: 25,
                      width: 25,
                      isAntiAlias: true,
                    ),
                    onPressed: () {
                     // model.searchOnMap(context, true);
                    },
                  )
                ])),
            Container(
              color: Colors.black12,
              margin: const EdgeInsets.fromLTRB(30, 0, 15, 0),
              height: 2,
            ),
            Padding(
                padding: EdgeInsets.all(5),
                child: Row(children: <Widget>[
                  Image.asset(
                    "images/flajok.png",
                    height: 25,
                    width: 25,
                    isAntiAlias: true,
                  ),
                  VerticalDivider(width: 10),
                  Expanded(
                      child: TextFormField(
                        readOnly: true,
                        minLines: 1,
                        maxLines: 6,
                        onTap: () {
                          if (RouteHandler.routeHandler.directionStruct.to
                              .length >
                              1) {
                            //model.showMultiAddress = true;

                            return;
                          }
                          // model.selectRoute(context, false);
                          // if (model.currentPage == pageSelectCar) {
                          //   model.loadingData = true;
                          //   parentState();
                          //   model.initCoin(context, () {
                          //     model.loadingData = false;
                          //     parentState();
                          //   }, () {
                          //     model.loadingData = false;
                          //     parentState();
                          //   });
                          // }
                        },
                        decoration: InputDecoration(
                            hintText: tr(trTo),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                        controller: model.appState.addressTo,
                      )),
                  if (RouteHandler.routeHandler.directionStruct.to.isEmpty)
                    IconButton(
                      icon: Image.asset(
                        "images/mapdraw.png",
                        height: 25,
                        width: 25,
                        isAntiAlias: true,
                      ),
                      onPressed: () {
                        //model.searchOnMap(context, false);
                      },
                    ),
                  if (RouteHandler.routeHandler.directionStruct.to.length > 0 &&
                      RouteHandler.routeHandler.directionStruct.to.length < 4)
                    IconButton(
                      icon: Image.asset(
                        "images/plus.png",
                        height: 15,
                        width: 15,
                        isAntiAlias: true,
                      ),
                      onPressed: () {
                        // model.showSingleAddress = true;
                        // parentState();
                      },
                    ),
                ])),
            Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    margin: EdgeInsets.all(5),
                    child: AbsorbPointer(
                        //absorbing: model.loadingData,
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: InkWell(
                                onTap: () {
                                  if (!RouteHandler.routeHandler
                                      .sourceDefined()) {
                                    Fluttertoast.showToast(
                                        msg: tr(trWaitForCoordinate),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Color(0xFF1564A1),
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    return;
                                  }

                                  },
                                child:
                                    Image.asset("images/arrowcircleright.png",
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover))))))
          ])),
    ]);
    return Stack(alignment: Alignment.bottomCenter, children: [w1]);
  }

  // void countRoute() {
  //   setState(() {
  //     model.loadingData = true;
  //   });
  //   model .initCoin(context, () {
  //     setState(() {
  //       model.loadingData = false;
  //     });
  //   }, () {
  //     setState(() {
  //       model.loadingData = false;
  //     });
  //   });
  // }
}