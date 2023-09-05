import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wagon_client/assessments.dart';
import 'package:wagon_client/car.dart';
import 'package:wagon_client/company.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/dlg.dart';
import 'package:wagon_client/freezed/chat_message.dart';
import 'package:wagon_client/history_all.dart';
import 'package:wagon_client/information.dart';
import 'package:wagon_client/order_cancel_options.dart';
import 'package:wagon_client/payment_type.dart';
import 'package:wagon_client/resources/resource_car_types.dart';
import 'package:wagon_client/screens/iphonedatepicker.dart';
import 'package:wagon_client/screens/login/screen.dart';
import 'package:wagon_client/screens/multiaddress_to_screen/screen.dart';
import 'package:wagon_client/screens/options_screen.dart';
import 'package:wagon_client/screens/payment/screen.dart';
import 'package:wagon_client/screens/single_address/screen.dart';
import 'package:wagon_client/screens/support/screen.dart';
import 'package:wagon_client/settings.dart';
import 'package:wagon_client/web/web_assessment.dart';
import 'package:wagon_client/web/web_broadcast_auth.dart';
import 'package:wagon_client/web/web_cancelaccept.dart';
import 'package:wagon_client/web/web_canceloptions.dart';
import 'package:wagon_client/web/web_cancelsearchtaxi.dart';
import 'package:wagon_client/web/web_initopen.dart';
import 'package:wagon_client/web/web_initorder.dart';
import 'package:wagon_client/web/web_realstate.dart';
import 'package:wagon_client/web/web_yandexkey.dart';
import 'package:wagon_client/widget/car_type.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'main_window_firstpage.dart';
import 'main_window_model.dart';
import 'model/address_model.dart';
import 'model/tr.dart';

class WMainWindow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WMainWidowState();
  }
}

class WMainWidowState extends State<WMainWindow> with WidgetsBindingObserver {

  final MainWindowModel model = MainWindowModel();
  final player = AudioPlayer();
  int _socketState = 0;
  WebSocket? _socket;
  bool _socket_connected = false;
  bool _driverIsFavorite = false;

  double _widgetTop = 0;
  double _menuLeft = 0;

  int _pageBeforeChat = 0;
  CancelOrderOptionList _cancelOrderOptionList = CancelOrderOptionList(0, []);
  ScrollController _scrollController = ScrollController();
  AssessmentList _assessments = AssessmentList([]);
  Assessment? _assessment;

  //Uint8List? _carRawImage;
  Widget? _currentWidget;

  @override
  void initState() {
    super.initState();

    ResourceCarTypes.res.clear();
    ResourceCarTypes.res
        .add(CarTypeStruct('images/car.png', 'Taxi', selected: true)
          ..types.addAll([
            CarSubtypeStruct('images/car2.png', 'Comfort',
                'Up to 4 person and one cat', 300),
            CarSubtypeStruct('images/car2.png', 'Econome plus',
                'Up to 3 person and one dog', 400),
            CarSubtypeStruct('images/car2.png', 'Business',
                'Up to 14 person and one eliphant', 600),
          ]));

    ResourceCarTypes.res.add(CarTypeStruct('images/car.png', 'Eaculator')
      ..types.addAll([
        CarSubtypeStruct(
            'images/car2.png', 'Comfort', 'Up to 4 person and one cat', 300),
        CarSubtypeStruct('images/car2.png', 'Econome plus',
            'Up to 3 person and one dog', 400),
        CarSubtypeStruct('images/car2.png', 'Business',
            'Up to 14 person and one eliphant', 600),
      ]));

    ResourceCarTypes.res.add(CarTypeStruct('images/car.png', 'Navigator')
      ..types.addAll([
        CarSubtypeStruct(
            'images/car2.png', 'Comfort', 'Up to 4 person and one cat', 300),
        CarSubtypeStruct('images/car2.png', 'Econome plus',
            'Up to 3 person and one dog', 400),
        CarSubtypeStruct('images/car2.png', 'Business',
            'Up to 14 person and one eliphant', 600),
      ]));

    ResourceCarTypes.res.add(CarTypeStruct('images/car.png', 'Tractor')
      ..types.addAll([
        CarSubtypeStruct(
            'images/car2.png', 'Comfort', 'Up to 4 person and one cat', 300),
        CarSubtypeStruct('images/car2.png', 'Econome plus',
            'Up to 3 person and one dog', 400),
        CarSubtypeStruct('images/car2.png', 'Business',
            'Up to 14 person and one eliphant', 600),
      ]));

    ResourceCarTypes.res.add(CarTypeStruct('images/car.png', 'Kran')
      ..types.addAll([
        CarSubtypeStruct(
            'images/car2.png', 'Comfort', 'Up to 4 person and one cat', 300),
        CarSubtypeStruct('images/car2.png', 'Econome plus',
            'Up to 3 person and one dog', 400),
        CarSubtypeStruct('images/car2.png', 'Business',
            'Up to 14 person and one eliphant', 600),
      ]));

    WebYandexKey().request(() {}, null);

    WidgetsBinding.instance.addObserver(this);
    _restoreState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _socketState = 1;
        _authSocket();
        _restoreState();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        model.tracking = false;
        _socketState = 2;
        if (_socket != null) {
          _socket!.close();
          _socket = null;
        }
        break;
    }
  }

  @override
  void dispose() {
    if (_socket != null) {
      _socket!.close();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
                child: Stack(children: [
              YandexMap(
                rotateGesturesEnabled: false,
                onMapCreated: _mapReady,
                onCameraPositionChanged: _cameraPosition,
                mapObjects: model.mapObjects,
              ),
              Visibility(visible: isMenuVisible(), child: _menuWidget()),
              _stepWidget(),
              Visibility(
                  visible: (model.currentPage == pageSelectShortAddress) &&
                      (model.addressFrom.text.isEmpty ||
                          model.addressTo.text.isEmpty),
                  child: Align(
                      alignment: Alignment.center,
                      child: Image.asset("images/placemark.png", width: 50))),
              Visibility(
                  visible: !_socket_connected,
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          height: 60,
                          color: Colors.red,
                          child: Center(
                              child: Text(tr(trMissingInternet),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)))))),
              _appendAddressToWidget(context),
              _multiAddressWiget(context),
              _walletOptions(context),
            ]))));
  }

  Future<bool> _onWillPop() async {
    if (model.showSingleAddress) {
      setState(() {
        model.showSingleAddress = false;
      });
      return false;
    }
    return true;
  }

  Widget _menuWidget() {
    return Align(
        alignment: Alignment.topLeft,
        child: Stack(children: [
          Column(children: [
            Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                alignment: Alignment.center,
                child: Image.asset(
                  "images/wagonlogooriginal.png",
                  height: 60,
                ))
          ]),
          GestureDetector(
              onTap: _showMenu,
              child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 25),
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Center(
                          child: Wrap(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 5, left: 5, right: 5),
                              child: Divider(
                                height: 2,
                                color: Consts.colorButtonGray,
                                thickness: 3,
                              )),
                          Padding(
                              padding:
                                  EdgeInsets.only(bottom: 5, left: 5, right: 5),
                              child: Divider(
                                height: 2,
                                color: Consts.colorButtonGray,
                                thickness: 3,
                              )),
                          Padding(
                              padding:
                                  EdgeInsets.only(bottom: 5, left: 5, right: 5),
                              child: Divider(
                                height: 2,
                                color: Consts.colorButtonGray,
                                thickness: 3,
                              ))
                        ],
                      ))))),
        ]));
  }

  Widget? _widgetForAnimation(Widget? w) {
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    return Stack(children: [
      Positioned(
          left: _menuLeft,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          top: _widgetTop - bottom,
          //top:0,
          child: Align(alignment: Alignment.bottomLeft, child: w))
    ]);
  }

  Widget _stepWidget() {
    switch (model.currentPage) {
      case pageRealState:
        _currentWidget = _stepRealState();
        break;
      case pageSelectShortAddress:
        _currentWidget = FirstPage(
            model: model,
            parentState: () {
              setState(() {});
            });
        break;
      case pageSelectCar:
        _currentWidget = _stepCar();
        break;
      case pageCarOptions:
        _currentWidget = OptionScreen(
            model: model,
            parentState: () {
              setState(() {});
            });
        break;
      case pageSearchTaxi:
        _currentWidget = _stepSearchTaxi();
        break;
      case pageOrderCancelOption:
        _currentWidget = _stepOrderCancelOption();
        break;
      case pageDriverAccept:
      case pageDriverOnWayToClient:
      case pageDriverOnPlace:
        _currentWidget = _stepDriverAccept();
        break;
      case pageOrderStarted:
        _currentWidget = _stepOrderStarted();
        break;
      case pageOrderEnd:
        _currentWidget = _stepOrderEnd();
        break;
      case pageChat:
        _currentWidget = _stepChat();
        break;
      case pageMenu:
        _currentWidget = _stepMenuWidget();
        break;
      case pagePayment:
        _currentWidget = _stepPaymentType();
        break;
    }
    if (model.currentPage != pageMenu) {
      _menuLeft = 0;
    }
    return _widgetForAnimation(_currentWidget)!;
  }

  Widget _stepRealState() {
    Widget w = Center(
        child: CircularProgressIndicator(
      strokeWidth: 5,
    ));
    return w;
  }

  Widget _stepCar() {
    model.tracking = false;
    if (RouteHandler.routeHandler.fromPoint() != null) {
      model.drawPoint();
    }
    _clearTaxiOnMap();
    Widget w1 = Wrap(children: [
      InkWell(
          onTap: () {
            setState(() {
              model.currentPage = pageSelectShortAddress;
            });
          },
          child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Center(
                  child: Image.asset('images/arrow.backward.png',
                      width: 30, height: 30)))),
      Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Center(
              child: Image.asset(ResourceCarTypes.selected()!.imageName,
                  width: 30, height: 30))),
      Container(
          decoration: Consts.boxDecoration,
          child: Column(children: [
            Visibility(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(children: [
                  VerticalDivider(
                    color: Colors.transparent,
                    width: 10,
                  ),
                  Text(tr(trRentTime)),
                  VerticalDivider(
                    color: Colors.transparent,
                    width: 60,
                  ),
                ]),
              ),
              visible: model.isRent,
            ),
            Visibility(
                visible: model.isRent,
                child: Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    child: Divider(
                      color: Colors.black12,
                      thickness: 1,
                    ))),
            Padding(
                padding: EdgeInsets.all(5),
                child: Row(children: [
                  Image.asset(
                    "images/frompoint.png",
                    height: 15,
                    width: 15,
                    isAntiAlias: true,
                  ),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 5),
                          child: TextFormField(
                            readOnly: true,
                            onTap: () async {
                              await model.selectRoute(context, true);
                              if (model.currentPage == pageSelectCar) {
                                setState(() {
                                  model.loadingData = true;
                                });
                                model.initCoin(context, () {
                                  setState(() {
                                    model.loadingData = false;
                                  });
                                }, () {
                                  setState(() {
                                    model.loadingData = false;
                                  });
                                });
                              }
                            },
                            decoration: InputDecoration(
                                hintText: tr(trFrom),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none),
                            controller: model.addressFrom,
                          ))),
                  IconButton(
                    icon: Image.asset(
                      "images/mapdraw.png",
                      height: 15,
                      width: 15,
                      isAntiAlias: true,
                    ),
                    onPressed: () {
                      model.searchOnMap(context, true);
                    },
                  ),
                ])),
            Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Divider(
                  color: Colors.black12,
                  thickness: 1,
                )),
            Visibility(
                visible: !model.isRent,
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(children: [
                      Image.asset(
                        "images/flajok.png",
                        height: 15,
                        width: 15,
                        isAntiAlias: true,
                      ),
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(left: 5),
                              child: TextFormField(
                                readOnly: true,
                                minLines: 1,
                                maxLines: 6,
                                onTap: () async {
                                  if (RouteHandler.routeHandler.directionStruct
                                          .to.length >
                                      1) {
                                    model.showMultiAddress = true;
                                    setState(() {});

                                    return;
                                  }
                                  await model.selectRoute(context, false);
                                  if (model.currentPage == pageSelectCar) {
                                    setState(() {
                                      model.loadingData = true;
                                    });
                                    model.initCoin(context, () {
                                      setState(() {
                                        model.loadingData = false;
                                      });
                                    }, () {
                                      setState(() {
                                        model.loadingData = false;
                                      });
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: tr(trTo),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none),
                                controller: model.addressTo,
                              ))),
                      if (RouteHandler.routeHandler.directionStruct.to.isEmpty)
                        IconButton(
                          icon: Image.asset(
                            "images/mapdraw.png",
                            height: 15,
                            width: 15,
                            isAntiAlias: true,
                          ),
                          onPressed: () {
                            model.searchOnMap(context, false);
                          },
                        ),
                      if (RouteHandler.routeHandler.directionStruct.to.length >
                              0 &&
                          RouteHandler.routeHandler.directionStruct.to.length <
                              4)
                        IconButton(
                          icon: Image.asset(
                            "images/plus.png",
                            height: 15,
                            width: 15,
                            isAntiAlias: true,
                          ),
                          onPressed: () {
                            model.showSingleAddress = true;
                            setState(() {});
                          },
                        ),
                    ]))),
            ListView.builder(
                shrinkWrap: true,
                itemCount: ResourceCarTypes.selected()?.types.length ?? 0,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        setState(() {
                          ResourceCarTypes.deselectSubType(
                              ResourceCarTypes.selected());
                          ResourceCarTypes.selected()?.selectSubtype(
                              ResourceCarTypes.selected()?.types[index]);
                        });
                      },
                      child: CarSubtypeWidget(
                          ResourceCarTypes.selected()?.types[index] ??
                              CarSubtypeStruct(
                                  'imageName', 'title', 'subTitle', 999)));
                }),
            AnimatedContainer(
                height: model.showOptions ? 160 : 0,
                duration: Duration(milliseconds: 300),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        height: 70,
                        child: InkWell(
                            onTap: () {
                              _setDriverComment();
                            },
                            child: Row(children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(tr(trDriverComment),
                                            style:
                                                const TextStyle(fontSize: 16)),
                                        model.commentFrom.text.isEmpty
                                            ? Container()
                                            : Text(model.commentFrom.text,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold))
                                      ])),
                              Expanded(child: Container()),
                              Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                      model.commentFrom.text.isEmpty
                                          ? 'images/arrowright.png'
                                          : 'images/check.png',
                                      height: 20,
                                      width: 20)),
                              VerticalDivider(
                                width: 10,
                              )
                            ]))),
                    Divider(
                      color: Colors.black12,
                      thickness: 1,
                    ),
                    Container(
                        height: 70,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 5),
                        child: InkWell(
                            onTap: () async {
                              await IPhoneDatePicker.setOrderTime(
                                  context, model);
                              setState(() {});
                            },
                            child: Row(children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tr(trPlan),
                                      style: const TextStyle(fontSize: 16)),
                                  model.orderDateTime.isBefore(DateTime.now())
                                      ? Container()
                                      : Text(
                                          '${Consts.dateToStr(model.orderDateTime)} ${Consts.timeToStr(model.orderDateTime)}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold))
                                ],
                              ),
                              Expanded(child: Container()),
                              Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                      model.orderDateTime
                                              .isBefore(DateTime.now())
                                          ? 'images/clock.png'
                                          : 'images/check.png',
                                      height: 20,
                                      width: 20)),
                              VerticalDivider(
                                width: 10,
                              )
                            ]))),
                  ],
                ))),
            Container(
                height: 5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Color(0xffcccccc)]))),
            Divider(height: 15, color: Colors.transparent),
            Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                //width: double.infinity,
                height: 50,
                child: AbsorbPointer(
                    absorbing: model.loadingData,
                    child: Row(children: [
                      //WALLET
                      OutlinedButton(
                          onPressed: () {
                            setState(() {
                              model.showWallet = !model.showWallet;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                              minimumSize: Size(10, 0),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.black26, width: 1),
                                  borderRadius:
                                      new BorderRadius.circular(5.0))),
                          child: Padding(
                              padding: EdgeInsets.only(top: 15, bottom: 15),
                              child: Image.asset(
                                'images/wallet.png',
                                width: 25,
                                height: 25,
                              ))),
                      //ORDERBUTTON BUTTON
                      VerticalDivider(width: 7, color: Colors.transparent),
                      Expanded(
                          child: OutlinedButton(
                              onPressed: _searchTaxi,
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Consts.colorOrange,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black26, width: 0),
                                    borderRadius:
                                        new BorderRadius.circular(5.0)),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.0, top: 15.0, bottom: 15.0),
                                  child: model.loadingData
                                      ? Image.asset("images/load1.gif",
                                          width: 130,
                                          height: 30,
                                          fit: BoxFit.cover)
                                      : Center(
                                          child: Text(
                                          model.orderDateTime
                                                  .isBefore(DateTime.now())
                                              ? tr(trORDER)
                                              : tr(trBOOK),
                                          style: Consts.textStyleButton,
                                          textAlign: TextAlign.center,
                                        ))))),
                      VerticalDivider(width: 7, color: Colors.transparent),
                      //OPTIONS BUTTON
                      AbsorbPointer(
                          absorbing: false,
                          child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  model.showOptions = !model.showOptions;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  minimumSize: Size(10, 0),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.black26, width: 1),
                                      borderRadius:
                                          new BorderRadius.circular(5.0))),
                              child: Padding(
                                  padding: EdgeInsets.only(top: 15, bottom: 15),
                                  child: Image.asset(
                                    model.showOptions
                                        ? 'images/downarrow.png'
                                        : 'images/options.png',
                                    width: 25,
                                    height: 25,
                                  ))))
                    ]))),
            Divider(height: 15, color: Colors.transparent),
          ])),
    ]);

    return w1;
  }

  Widget _stepPaymentType() {
    return Wrap(
      children: [
        Container(
            decoration: Consts.boxDecoration,
            child: Wrap(children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: model.paymentTypes.payment_types.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              model.paymentTypes.uncheckAll();
                              model.paymentTypes.payment_types[index].selected =
                                  true;
                            });
                          },
                          child: Row(children: [
                            Checkbox(
                              activeColor: Consts.colorTaxiBlue,
                              value: model
                                  .paymentTypes.payment_types[index].selected,
                              onChanged: (bool? v) {
                                setState(() {
                                  model.paymentTypes.uncheckAll();
                                  model.paymentTypes.payment_types[index]
                                      .selected = true;
                                });
                              },
                            ),
                            Expanded(
                                child: Text(model
                                    .paymentTypes.payment_types[index].name)),
                          ])),
                      _paymentSubwidget(index)
                    ]);
                  }),
              Container(
                  height: 5,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Color(0xffcccccc)]))),
              Container(
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () {
                        if (model.paymentTypes.getSelected()!.id == 2) {
                          if (model.companies.getSelected() == null) {
                            return;
                          }
                        }
                        setState(() {
                          model.currentPage = pageSelectCar;
                          model.loadingData = true;
                          model.initCoin(context, () {
                            setState(() {
                              model.loadingData = false;
                            });
                          }, () {
                            setState(() {
                              model.loadingData = false;
                            });
                          });
                        });
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Consts.colorOrange,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Consts.colorWhite, width: 0),
                              borderRadius: new BorderRadius.circular(5.0))),
                      child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child:
                              Text("ГОТОВО", style: Consts.textStyleButton))))
            ]))
      ],
    );
  }

  Widget _stepSearchTaxi() {
    Widget w = Wrap(children: [
      Container(
          height: 200,
          decoration: Consts.boxDecoration,
          child: Column(
            children: <Widget>[
              Text(
                tr(trSEARCHCAR),
                style: Consts.textStyle4,
                textAlign: TextAlign.center,
              ),
              Expanded(
                  child: Center(
                      child: Text(
                tr(trFindingCar),
                style: Consts.textStyle5,
                textAlign: TextAlign.center,
              ))),
              Container(
                  height: 5,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Color(0xffcccccc)]))),
              Container(
                  margin:
                      EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () {
                        _cancelSearchTaxi();
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Consts.colorOrange,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Consts.colorWhite, width: 0),
                              borderRadius: new BorderRadius.circular(5.0))),
                      child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(tr(trCancel).toUpperCase(),
                              style: Consts.textStyleButton))))
            ],
          ))
    ]);

    return w;
  }

  Widget _stepOrderCancelOption() {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Container(
            decoration: Consts.boxDecoration,
            child: Wrap(children: [
              Column(children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: _cancelOrderOptionList.options.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              _cancelOrderOptionList.setSelected(
                                  index,
                                  !_cancelOrderOptionList
                                      .options[index].selected);
                            });
                          },
                          child: Row(children: [
                            Checkbox(
                                activeColor: Consts.colorTaxiBlue,
                                value: _cancelOrderOptionList
                                    .options[index].selected,
                                onChanged: (bool? v) {
                                  setState(() {
                                    _cancelOrderOptionList.setSelected(
                                        index, v!);
                                  });
                                }),
                            Expanded(
                                child: Text(
                                    _cancelOrderOptionList.options[index].name))
                          ]));
                    }),
                Container(
                    height: 5,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white, Color(0xffcccccc)]))),
                Container(
                    margin: EdgeInsets.only(
                        left: 10, right: 10, top: 15, bottom: 15),
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () {
                          _sendCancelReason();
                        },
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Consts.colorOrange,
                            shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.black26, width: 0),
                                borderRadius: new BorderRadius.circular(5.0))),
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: 0.0, top: 15.0, bottom: 15.0),
                            child: Center(
                                child: Text(
                              tr(trSend).toUpperCase(),
                              style: Consts.textStyleButton,
                              textAlign: TextAlign.center,
                            )))))
              ])
            ])));
  }

  Widget _stepDriverAccept() {
    return Padding(
        padding: EdgeInsets.only(left: 0, right: 0),
        child: Container(
            decoration: Consts.boxDecoration,
            child: Wrap(children: [
              Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(top: 30, bottom: 30),
                      child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Column(children: [
                            Text(model.currentStateName(),
                                style: Consts.textStyle7),
                            Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Divider(
                                  color: Consts.colorGray,
                                )),
                            Text(
                                sprintf("%s %s %s", [
                                  model.events["driver_accept"]["payload"]
                                          ["car"]["color"]
                                      .toString(),
                                  model.events["driver_accept"]["payload"]
                                          ["car"]["mark"]
                                      .toString(),
                                  model.events["driver_accept"]["payload"]
                                          ["car"]["state_license_plate"]
                                      .toString()
                                ]),
                                style: Consts.textStyle7)
                          ])))),
              Padding(
                  padding: EdgeInsets.only(left: 5, bottom: 5, right: 5),
                  child: Container(
                      child: Row(children: [
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse(
                                  "tel://${model.events["driver_accept"]["payload"]["phone"]}"));
                            },
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Image.asset(
                                    "images/call.png",
                                    width: 60,
                                    height: 60,
                                  )),
                                ]))),
                    if (model.currentPage != pageDriverOnPlace)
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                _cancelSearchTaxi();
                              },
                              child: Column(children: [
                                Center(
                                    child: Image.asset("images/cancel.png",
                                        width: 60, height: 60)),
                              ]))),
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _pageBeforeChat = model.currentPage;
                                model.currentPage = pageChat;
                              });
                            },
                            child: Stack(children: [
                              Center(
                                  child: Image.asset("images/help.png",
                                      width: 60, height: 60)),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Visibility(
                                      visible:
                                          model.unreadChatMessagesCount > 0,
                                      child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 30),
                                          height: 30,
                                          width: 30,
                                          padding: EdgeInsets.all(3),
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          child: Text(
                                              '${model.unreadChatMessagesCount}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.bold)))))
                            ])))
                  ]))),
              Divider(
                height: 30,
                color: Colors.transparent,
              )
            ])));
  }

  Widget _stepOrderStarted() {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Container(
            decoration: Consts.boxDecoration,
            child: Wrap(children: [
              Divider(height: 1, color: Colors.transparent),
              Center(
                  child: Text(tr(trOrderStarted),
                      textAlign: TextAlign.center, style: Consts.textStyle4))
            ])));
  }

  Widget _stepOrderEnd() {
    model.tracking = false;
    return Flex(direction: Axis.vertical, children: [
      Flex(direction: Axis.horizontal, children: [
        GestureDetector(
            onTap: () {
              setState(() {
                _driverIsFavorite = !_driverIsFavorite;
              });
            },
            child: Container(
              margin: EdgeInsets.only(left: 10, top: 10),
              child: Image.asset(
                  _driverIsFavorite ? "images/heart1.png" : "images/heart0.png",
                  width: 40,
                  height: 40),
            )),
        Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            child: Text(tr(trAppendDriverToFavorite)))
      ]),
      Expanded(child: Container()),
      Container(
          decoration: Consts.boxDecoration,
          child: Column(children: [
            Row(children: [
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        _iconPressed(1);
                      },
                      icon: model.driverRating >= 1
                          ? Image.asset("images/redstar.png")
                          : Image.asset("images/redstari.png"))),
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        _iconPressed(2);
                      },
                      icon: model.driverRating >= 2
                          ? Image.asset("images/redstar.png")
                          : Image.asset("images/redstari.png"))),
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        _iconPressed(3);
                      },
                      icon: model.driverRating >= 3
                          ? Image.asset("images/redstar.png")
                          : Image.asset("images/redstari.png"))),
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        _iconPressed(4);
                      },
                      icon: model.driverRating >= 4
                          ? Image.asset("images/redstar.png")
                          : Image.asset("images/redstari.png"))),
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        _iconPressed(5);
                      },
                      icon: model.driverRating >= 5
                          ? Image.asset("images/redstar.png")
                          : Image.asset("images/redstari.png")))
            ]),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _assessments.list.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          _assessments.setSelected(
                              index, !_assessments.list[index].selected);
                        });
                      },
                      child: Row(children: [
                        Checkbox(
                            activeColor: Consts.colorTaxiBlue,
                            value: _assessments.list[index].selected,
                            onChanged: (bool? v) {
                              setState(() {
                                _assessments.setSelected(index, v!);
                              });
                            }),
                        Expanded(child: Text(_assessments.list[index].name))
                      ]));
                }),
            Visibility(
                visible: model.driverRating > 0 && model.driverRating < 3,
                child: Container(
                    margin: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 10),
                    child: TextField(
                        controller: model.feedbackText,
                        keyboardType: TextInputType.multiline,
                        minLines: 4,
                        maxLines: null,
                        decoration: InputDecoration(
                            hintText: tr(trDescribeProblem),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal)))))),
            Center(
                child: Text(tr(trTotalPaid),
                    textAlign: TextAlign.center, style: Consts.textStyle4)),
            Center(
                child: Text(
                    "${model.events["driver_order_end"]["payload"]["order"]["price"].toString()} ${tr(trDramSymbol)}",
                    textAlign: TextAlign.center,
                    style: Consts.textStyle4)),
            Container(
                margin: EdgeInsets.all(5),
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () {
                      _orderEnd();
                    },
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Consts.colorOrange,
                        shape: RoundedRectangleBorder(
                            side:
                                BorderSide(color: Consts.colorWhite, width: 0),
                            borderRadius: new BorderRadius.circular(5.0))),
                    child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child:
                            Text(tr(trFINISH), style: Consts.textStyleButton))))
          ]))
    ]);
  }

  Widget _stepChat() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUnreadMessages();
    });
    String chatStr = Consts.getString("chat");
    if (chatStr.isEmpty) {
      chatStr = "{\"chat\":[]}";
    }
    Map<String, dynamic> chat = jsonDecode(chatStr);
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).viewInsets.bottom,
        color: Colors.white,
        child: Column(children: [
          Row(children: [
            IconButton(
                icon: Image.asset(
                  "images/back.png",
                  height: 20,
                  width: 20,
                ),
                onPressed: () {
                  setState(() {
                    model.unreadChatMessagesCount = 0;
                    model.currentPage = _pageBeforeChat;
                  });
                }),
            Text(tr(trDialogWithDriver))
          ]),
          Container(
              height: 5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffcccccc), Colors.white]))),
          Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: chat["chat"].length,
                  itemBuilder: (BuildContext context, int index) {
                    bool driverMessage = chat["chat"][index]["messageData"]
                            ["sender"] ==
                        "driver";
                    return Column(children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            driverMessage
                                ? Container()
                                : Expanded(child: Container()),
                            driverMessage
                                ? Container(
                                    padding: EdgeInsets.all(3),
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                        border: Border.fromBorderSide(
                                            BorderSide(color: Colors.black12)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: Image.asset('images/profile.png'))
                                : Container(),
                            Column(
                                crossAxisAlignment: driverMessage
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.end,
                                children: [
                                  Align(
                                      alignment: driverMessage
                                          ? Alignment.centerLeft
                                          : Alignment.centerRight,
                                      child: Text(chat["chat"][index]
                                          ["messageData"]["time"])),
                                  Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    constraints: BoxConstraints(
                                        minWidth: 20,
                                        maxWidth:
                                            (MediaQuery.of(context).size.width *
                                                    0.9) -
                                                30),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: driverMessage
                                            ? Consts.colorOrange
                                            : Consts.colorGreen,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                            bottomLeft: driverMessage
                                                ? Radius.circular(0)
                                                : Radius.circular(30),
                                            bottomRight: driverMessage
                                                ? Radius.circular(30)
                                                : Radius.circular(0))),
                                    child: Text(
                                        chat["chat"][index]["messageData"]
                                            ["text"],
                                        softWrap: true,
                                        style: Consts.textStyle7),
                                  )
                                ]),
                            driverMessage
                                ? Expanded(child: Container())
                                : Container(
                                    padding: EdgeInsets.all(3),
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                        border: Border.fromBorderSide(
                                            BorderSide(color: Colors.black12)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: Image.asset('images/profile.png'))
                          ]),
                      const Divider(
                        height: 20,
                        color: Colors.white10,
                      )
                    ]);
                  })),
          Container(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Image.asset('images/operator.png', height: 36, width: 36),
                  VerticalDivider(width: 5),
                  Expanded(
                      child: TextFormField(
                    controller: model.chatTextController,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        hintStyle: const TextStyle(color: Colors.black12),
                        hintText: tr(trMessage).toUpperCase()),
                  )),
                  VerticalDivider(width: 5),
                  IconButton(
                      icon: Image.asset("images/send.png"),
                      onPressed: _sendChatMessage)
                ],
              ))
        ]));
  }

  Widget _stepMenuWidget() {
    return Draggable(
        onDragUpdate: (dt) {
          if (_menuLeft + dt.delta.dx > 0) {
            _menuLeft = 0;
          } else if (_menuLeft + dt.delta.dx < -180) {
            _hideMenu();
            return;
          } else {
            _menuLeft += dt.delta.dx;
          }
          setState(() {});
        },
        onDragEnd: (dt) {
          setState(() {
            if (_menuLeft < 0) {
              _menuLeft = 0;
            }
          });
        },
        feedback: Container(),
        child: Container(
            width: 300,
            color: Colors.white,
            child: Column(children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 19, bottom: 18),
                      child: Text(_getPhoneFormatted(),
                          style: Consts.textStylePhoneHeader))),
              Divider(
                color: Consts.colorBlue,
                thickness: 4,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: GestureDetector(
                          onTap: _callHistory,
                          child: Text(tr(trORDERSHISTORY),
                              style: Consts.textStyleMenu)))),
              Divider(
                color: Colors.black38,
                thickness: 1,
              ),
              // Align(
              //     alignment: Alignment.centerLeft,
              //     child: Padding(
              //         padding: EdgeInsets.only(left: 20, top: 10),
              //         child: GestureDetector(
              //             onTap: () {
              //               model.currentPage = _pageBeforeChat;
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => MyAddresses()));
              //             },
              //             child: Text("МОИ АДРЕСА",
              //                 style: Consts.textStyleMenu)))),
              // Divider(
              //   color: Colors.black38,
              //   thickness: 1,
              // ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: GestureDetector(
                          onTap: () {
                            model.currentPage = _pageBeforeChat;
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SettingsWindow()))
                                .then((value) {
                              if (value != null) {
                                if (value) {
                                  _socketState = 2;
                                  _socket!.close();
                                  _socket = null;
                                  Consts.setInt("client_id", 0);
                                  Consts.setString("phone", "");
                                  Consts.setString("bearer", "");
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                      (route) => false);
                                }
                              }
                            });
                          },
                          child: Text(tr(trSETTINGS),
                              style: Consts.textStyleMenu)))),
              Divider(
                color: Colors.black38,
                thickness: 1,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: GestureDetector(
                          onTap: () {
                            model.currentPage = _pageBeforeChat;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Information()));
                          },
                          child:
                              Text(tr(trINFO), style: Consts.textStyleMenu)))),
              Divider(
                color: Colors.black38,
                thickness: 1,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SupportScreen()));
                          },
                          child: Text(tr(trSUPPORT),
                              style: Consts.textStyleMenu)))),
              Divider(
                color: Colors.black38,
                thickness: 1,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: GestureDetector(
                          onTap: () {
                            Consts.setInt("client_id", 0);
                            Consts.setString("phone", "");
                            Consts.setString("bearer", "");
                            if (_socket != null) {
                              _socket!.close();
                              _socket = null;
                            }
                            // if (model.mapController != null) {
                            //   model.mapController!.dispose();
                            //   model.mapController = null;
                            // }
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child:
                              Text(tr(trEXIT), style: Consts.textStyleMenu)))),
              Divider(
                color: Colors.black38,
                thickness: 1,
              ),
              Divider(color: Colors.transparent, height: 10),
              Expanded(child: Container()),
              Image.asset(
                "images/logo_nyt.png",
                width: 100,
              ),
              Divider(height: 30, color: Colors.transparent)
            ])));
  }

  void _searchTaxi() {
    if (model.paymentTypes.payment_types.length > 0) {
      setState(() {
        model.loadingData = true;
      });
      WebInitOrder webInitOrder = WebInitOrder(
          RouteHandler.routeHandler.directionStruct.from!,
          model.currentCar,
          model.paymentTypes.getSelected()!.id,
          model.paymentTypes.getSelected()!.id == 2
              ? (model.companies.getSelected() == null
                  ? 0
                  : model.companies.getSelected()!.id)
              : 0,
          Consts.getString("driverComment"),
          model.selectedCarOptions,
          model.orderDateTime.add(Duration(
              minutes: model.orderDateTime.difference(DateTime.now()) <
                      Duration(minutes: 60)
                  ? 15
                  : 0)),
          model.commentFrom.text);

      webInitOrder.request((mp) {
        if (mp.containsKey("message")) {
          if (mp["message"].toString() == "Order created successful") {
            Dlg.show(context, tr(trYourPreorderAccept));
            setState(() {
              model.currentPage = pageSelectShortAddress;
              model.loadingData = false;
            });
          }
        } else {
          setState(() {
            model.animateWindow(pageSearchTaxi, () {});
            model.loadingData = false;
          });
        }
      }, (c, s) {
        setState(() {
          model.loadingData = false;
        });
        Dlg.show(context, s);
      });
    }
  }

  void _cancelSearchTaxi() {
    WebCancelSearchTaxi webCancelSearchTaxi = WebCancelSearchTaxi();
    resetAddresses();
    webCancelSearchTaxi.request((mp) {
      mp = mp['data'];
      if (mp['cancel_fee'] == true) {
        Dlg.question(context,
                '${tr(trDriverInPlaceCancelFee)} ${mp["cancel_price"].toString()}')
            .then((value) {
          if (value) {
            WebCancelAccept webCancelAccept = WebCancelAccept(true);
            webCancelAccept.request((mp) {
              print(mp);
              Dlg.show(context, mp["message"]);
              _cancelOrderOptionList =
                  CancelOrderOptionList.fromJson(mp['data']);
              model.tracking = false;
              model.animateWindow(pageOrderCancelOption, null);
              setState(() {});
            }, (c, s) {
              Dlg.show(context, s);
              _restoreState();
            });
          } else {}
        });
      } else {
        _cancelOrderOptionList = CancelOrderOptionList.fromJson(mp);
        model.tracking = false;
        model.animateWindow(pageOrderCancelOption, null);
        setState(() {});
      }
    }, (c, s) {
      Dlg.show(context, s);
      _restoreState();
    });
  }

  void _sendCancelReason() {
    CancelOrderOption? oo = _cancelOrderOptionList.getSelected();
    if (oo == null) {
      return;
    }
    WebSendCancelReason webSendCancelReason = WebSendCancelReason(
        _cancelOrderOptionList.aborted_id,
        0,
        oo.option,
        oo.name,
        "",
        "",
        false,
        model.driverRating);
    webSendCancelReason.request((mp) {
      model.animateWindow(pageSelectShortAddress, () {
        setState(() {
          model.currentState = state_none;
        });
      });
    }, (c, s) {
      Dlg.show(context, s);
    });
  }

  void _mapReady(YandexMapController controller) async {
    model.mapController = controller;
    model.enableTrackingPlace();
    await _getLocation();
    _authSocket();
  }

  Future<void> _getLocation() async {
    bool _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!_serviceEnabled) {
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    );

      if ((model.currentPage != pageSelectShortAddress) && model.init) {
        return;
      }

    Position p = await Geolocator.getCurrentPosition();
    model.mapController!.moveCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
            target: Point(
                latitude: p.latitude,
                longitude: p.longitude),
            zoom: 16)),
        animation: MapAnimation(duration: 1));

      if (!model.init) {
        model.init = true;
        RouteHandler.routeHandler.setPointFrom(p);
        model.mapController?.moveCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: Point(latitude: p.latitude, longitude: p.longitude), zoom: 16)));

        WebInitOpen webInitOpen = new WebInitOpen(
            latitude: p.latitude!, longitude: p.longitude!);
        webInitOpen.request((mp) {
          model.paymentTypes = PaymentTypes.fromJson(mp['data']);
          for (var e in model.paymentTypes.payment_types) {
            if (e.name.toLowerCase() == 'наличными') {
              e.name = 'Наличные';
            } else if (e.name.toLowerCase() == 'безнал и кредитка') {
              e.name = 'За счёт компании';
            }
          }
          model.companies = Companies.fromJson(mp['data']);
          //TODO GET CAR CLASSES FROM HERE
          //model.setCarClasses(CarClasses.fromJson(mp['data']));
          for (int rt in mp["data"]["rent_times"]) {
            model.rentTimes.add(rt);
          }
          if (model.paymentTypes.payment_types.length > 0) {
            model.paymentTypes.payment_types[0].selected = true;
          }
          model.initCoin(context, () {}, (c, s) {
            if (c == 401) {
              Consts.setString("bearer", "");
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            } else {
              Dlg.show(context, "initCoin()\r\n" + s);
            }
            setState(() {});
          });
        }, (c, s) {
          if (c == 401) {
            Consts.setString("bearer", "");
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          } else {
            Dlg.show(context, "initOpen()\r\n" + s);
          }
          setState(() {});
        });
      }

  }

  void _geocodeResponse(AddressStruct ass) {
    RouteHandler.routeHandler.directionStruct.from = ass;
    model.addressFrom.text = ass.title;
    if (model.currentPage == pageSelectCar ||
        model.currentPage == pageSelectShortAddress) {
      model.initCoin(context, () {
        setState(() {});
      }, () {
        setState(() {});
      });
    }
  }

  void _subscribeToFreeChannel() {
    String channel = sprintf("free-%s", [Consts.getString("channel_hash")]);
    Consts.setString("free-channel",
        sprintf("client-%s", [Consts.getString("channel_hash")]));
    String strToCrypt = Consts.getString("socket_id") + ":" + channel;
    String secret = "34345";
    List<int> messageBytes = utf8.encode(strToCrypt);
    List<int> key = utf8.encode(secret);
    Hmac hmac = new Hmac(sha256, key);
    Digest digest = hmac.convert(messageBytes);
    String auth = sprintf(
        '{"event":"pusher:subscribe","data":{"auth":"324345:%s","channel":"%s"}}',
        [digest.toString(), channel]);
    _socket!.add(auth);
  }

  void _socketOnMessage(dynamic message) {
    print(message);
    Map<String, dynamic> mp = jsonDecode(message.toString());
    String event = mp["event"];
    if (event == "pusher:connection_established") {
      mp = jsonDecode(mp["data"]);
      Consts.setString("socket_id", mp["socket_id"]);
      String channel = Consts.channelName();
      String strToCrypt = mp["socket_id"] + ":" + channel;
      String secret = "34345";

      List<int> messageBytes = utf8.encode(strToCrypt);
      List<int> key = utf8.encode(secret);
      Hmac hmac = new Hmac(sha256, key);
      Digest digest = hmac.convert(messageBytes);

      print("digest");
      print(digest);

      String auth = sprintf(
          '{"event":"pusher:subscribe","data":{"auth":"324345:%s","channel":"%s"}}',
          [digest.toString(), channel]);
      print(auth);
      //auth='{"event":"pusher:subscribe","data":{"auth":"324345:aeef0999c5700fd432be7d1b05df896904f9c5a736f5c8a4abffb42e69899f31","channel":"private-client-api-base.15.374999666"}}'.toString();
      _socket!.add(auth);
    } else if (event == "pusher_internal:subscription_succeeded") {
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\DriverOnAcceptOrderEvent") {
      model.animateWindow(pageDriverAccept, () {
        model.currentState = state_driver_accept;
        Map<String, dynamic> md = jsonDecode(mp["data"]);
        model.events["driver_accept"] = md;
        Consts.setString("channel_hash", md["hash"]);
        _subscribeToFreeChannel();
      });
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\DriverOnWayOrderEvent") {
      model.animateWindow(pageDriverAccept, () {
        model.currentState = state_driver_onway;
        model.events["driver_accept"] = jsonDecode(mp["data"]);
        model.events["driver_accept"]["message"] =
            model.events["driver_accept"]["timeline"];
      });
    } else if (event == "Src\\Broadcasting\\Broadcast\\Client\\DriverInPlace") {
      model.animateWindow(pageDriverOnPlace, () {
        model.currentState = state_driver_onplace;
        model.events["driver_accept"] = jsonDecode(mp["data"]);
      });
    } else if (event == "Src\\Broadcasting\\Broadcast\\Client\\OrderStarted") {
      model.animateWindow(pageOrderStarted, () {
        model.events["driver_order_started"] = mp;
      });
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\ClientOrderEndData") {
      model.timeline["arrival_time"] = "00:00";
      model.timeline["travel_time"] = "00:00";
      model.timeline["past_length"] = 0;
      model.timeline["total_length"] = 0;
      model.removePolyline(centerMe: true);
      model.selectedCarOptions.clear();
      model.mapObjects.clear();
      model.animateWindow(pageOrderEnd, () {
        Map<String, dynamic> data = jsonDecode(mp["data"]);
        data["payload"] = Map<String, dynamic>();
        data["payload"]["order"] = Map<String, dynamic>();
        data["payload"]["order"]["order_id"] = data["orderId"];
        data["payload"]["order"]["price"] = 0;
        data["payload"]["order"]["price"] =
            double.parse(data["price"].toString());
        model.events["driver_order_end"] = data;
        setState(() {});
      });
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\NonDriverEvent") {
      resetAddresses();
      Map<String, dynamic> msg = jsonDecode(mp["data"]);
      Dlg.show(context, msg["message"].toString());
      _restoreState();
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\ListenTaxiPositionEvent") {
      Map<String, dynamic> data = jsonDecode(mp["data"]);
      Point p = Point(
          latitude: data["driver"]["current_coordinate"]["lat"],
          longitude: data["driver"]["current_coordinate"]["lut"]);
      model.mapController?.moveCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
              target: p,
              zoom: model.rideZoom,
              azimuth: double.parse(data["driver"]["azimuth"].toString()))),
          animation: MapAnimation(duration: 1));
      model.mapObjects.clear();
      setState(() {
        model.mapObjects.add(PlacemarkMapObject(
            mapId: model.carId,
            point: p,
            opacity: 1,
            icon: PlacemarkIcon.single(PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage('images/car.png'),
                rotationType: RotationType.rotate))));
      });
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\BroadwayDriverTalk") {
      playSoundChat();
      model.getChatCount().then((value) => setState(() {}));
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\ListenRadiusTaxiEvent") {
      _clearTaxiOnMap();
      Map<String, dynamic> tl = jsonDecode(mp["data"]);
      ListenRadiusTaxiEvent te = ListenRadiusTaxiEvent.fromJson(tl);
      //final orimg = img.decodePng(_carRawImage!);
      for (CarPos cp in te.taxis) {
        PlacemarkMapObject pm = PlacemarkMapObject(
            opacity: 1,
            mapId:
                MapObjectId("taxionmap" + model.mapObjects.length.toString()),
            point: Point(
                latitude: cp.current_coordinate.getLat(),
                longitude: cp.current_coordinate.getLon()),
            icon: PlacemarkIcon.single(PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage('images/car.png'),
                rotationType: RotationType.rotate)),
            direction: cp.azimuth.toDouble());
        model.mapObjects.add(pm);
      }
      setState(() {});
    } else if (event == "Src\\Broadcasting\\Broadcast\\Client\\DriverLate") {
      setState(() {
        String chat = Consts.getString("chat");
        if (chat.isEmpty) {
          chat = "{\"chat\":[]}";
        }
        DateTime time = DateTime.now();
        DateFormat df = DateFormat("HH:mm");

        Map<String, dynamic> chatdata = jsonDecode(chat);
        Map<String, dynamic> msg = jsonDecode(mp["data"]);
        msg = msg["payload"];
        Map<String, dynamic> om = Map();
        om["messageData"] = msg;
        om["messageData"]["sender"] = "driver"; // ng, dynamic>();
        om["messageData"]["time"] = df.format(time);
        chatdata["chat"].add(om);
        Consts.setString("chat", jsonEncode(chatdata));
        if (model.currentPage != pageChat) {
          _pageBeforeChat = model.currentPage;
          model.currentPage = pageChat;
        }
      });
    } else if (event == "Src\\Broadcasting\\Broadcast\\Client\\OrderReset") {
      _restoreState();
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\AdminOrderCancel") {
      resetAddresses();
      Map<String, dynamic> msg = jsonDecode(mp["data"]);
      Dlg.show(context, msg["message"].toString());
      _restoreState();
    } else if (event == Consts.getString("free-channel")) {
      print(mp);
      setState(() {
        model.timeline = mp["data"]["msg"];
      });
    }
  }

  void _iconPressed(int index) {
    WebAssessments webAssessments = WebAssessments(index);
    webAssessments.request((mp) {
      Map<String, dynamic> mpp = Map();
      mpp["list"] = mp;
      setState(() {
        model.driverRating = index;
        _assessments = AssessmentList.fromJson(mpp);
        _assessments.setSelected(-1, false);
      });
    }, (c, s) {
      Dlg.show(context, "_iconPressed()\r\n" + s);
    });
  }

  void _orderEnd() {
    resetAddresses();
    model.commentFrom.clear();
    model.addressFrom.clear();
    model.addressTo.clear();
    _assessment = _assessments.getSelected();
    if (_assessment == null) {
      _assessment = Assessment("", 0, "", false);
      return;
    }
    WebSendCancelReason webSendAssessment = WebSendCancelReason(
        0,
        model.events["driver_order_end"]["payload"]["order"]["order_id"],
        _assessment!.option_id == 0 ? null : _assessment!.option_id,
        _assessment!.name,
        _assessment!.assessment,
        model.feedbackText.text,
        _driverIsFavorite,
        model.driverRating);
    webSendAssessment.request((mp) {
      model.animateWindow(pageSelectShortAddress, () {
        model.currentState = state_none;
        _assessment = null;
        _assessments.list.clear();
        model.enableTrackingPlace();
        model.centerMeOnMap();
      });
    }, (c, s) {
      Dlg.show(context, s);
    });
  }

  void _sendChatMessage() {
    if (model.chatTextController.text.isEmpty) {
      return;
    }
    String msg = sprintf(
        "{\n" +
            "\"channel\": \"private-client-api-base.%d.%s\",\n" +
            "\"data\": {\"text\": \"%s\"},\n" +
            "\"event\": \"client-broadcast-api/broadway-driver\"\n"
                "}",
        [
          Consts.getInt("client_id"),
          Consts.getString("phone").replaceAll("+", ""),
          model.chatTextController.text
        ]);
    print(msg);
    _socket!.add(msg);

    String chat = Consts.getString("chat");
    if (chat.isEmpty) {
      chat = "{\"chat\":[]}";
    }
    DateTime time = DateTime.now();
    DateFormat df = DateFormat("HH:mm");

    Map<String, dynamic> nmsg = Map();
    nmsg["text"] = model.chatTextController.text;
    nmsg["sender"] = "passenger";
    nmsg["time"] = df.format(time);
    Map<String, dynamic> chatdata = jsonDecode(chat);
    Map<String, dynamic> mmsg = Map();
    mmsg["messageData"] = nmsg;
    chatdata["chat"].add(mmsg);
    Consts.setString("chat", jsonEncode(chatdata));
    setState(() {
      model.chatTextController.clear();
    });
  }

  void _callHistory() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HistoryAll()));
    _hideMenu();
  }

  bool isMenuVisible() {
    bool v = model.currentState < state_driver_accept;
    v = v || model.currentPage == pageOrderStarted;
    return v;
  }

  void _showMenu() {
    setState(() {
      _pageBeforeChat = model.currentPage;
      model.currentPage = pageMenu;
      _menuLeft = 0;
    });
  }

  void _hideMenu() {
    setState(() {
      _menuLeft = -300;
      model.currentPage = _pageBeforeChat;
      _menuLeft = 0;
    });
  }

  void _scrollChatToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.elasticOut);
    } else {
      Timer(Duration(milliseconds: 400), () => _scrollChatToBottom());
    }
  }

  void _setDriverComment() {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(contentPadding: EdgeInsets.all(10), children: [
            SizedBox(
                width: MediaQuery.of(ctx).size.width * 0.95,
                child: TextFormField(
                    controller: model.commentFrom,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Consts.colorOrange, width: 1)),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Consts.colorOrange)),
                        hintText: tr(trCommentForDriver)))),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Consts.colorOrange),
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text(tr(trSave),
                    style:
                        const TextStyle(fontSize: 16, color: Colors.black54)))
          ]);
        });
  }

  void _authSocket() {
    //_openSocket();
    WebBroadcastAuth webBroadcastAuth = WebBroadcastAuth(
        channelName: Consts.channelName(), socketID: Consts.socketId());
    webBroadcastAuth.request((mp) {
      _openSocket();
    }, (c, s) {
      sleep(const Duration(seconds: 2));
      _setSocketConnected(false);
      _authSocket();
    });
  }

  void _openSocket() async {
    do {
      try {
        HttpClient client =
            HttpClient(); //.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        //HttpClientRequest request = await client.getUrl(Uri.parse("https://10.1.0.2:10002/app/324345"));// (sprintf('10.1.0.2', []), 10002, "/app/324345");
        HttpClientRequest request = await client.getUrl(
            Uri.parse(sprintf('https://%s:6001/app/324345', [Consts.host()])));
        request.headers.add('Connection', 'upgrade');
        request.headers.add('Upgrade', 'websocket');
        request.headers.add(
            'sec-websocket-version', '13'); // insert the correct version here
        request.headers.add('sec-websocket-key', 'bHi/xD6v0LGIhSXi474s8g==');
        HttpClientResponse response = await request.close();
        Socket socket = await response.detachSocket();
        _socket = WebSocket.fromUpgradedSocket(socket, serverSide: false);
        _socket!.listen((msg) {
          _socketOnMessage(msg);
        }, onError: _onSocketError, onDone: _onSocketDone);
        _socket!.handleError((err) {
          print(err);
        });
        _setSocketConnected(true);
        _pingpong();
        if (model.currentPage == pageDriverAccept ||
            model.currentPage == pageDriverOnPlace ||
            model.currentPage == pageDriverOnWayToClient ||
            model.currentPage == pageOrderStarted) {
          _subscribeToFreeChannel();
        }
      } catch (e) {
        print(e);
        sleep(const Duration(seconds: 2));
        _authSocket();
        return;
      }
    } while (!_socket_connected);
  }

  void _onSocketError(a) {
    print(_socketState);
    print("SOCKET ERROR");
    if (_socketState == 2) {
      return;
    }
    _authSocket();
  }

  void _onSocketDone() {
    print(_socketState);
    print("SOCKET DONE");
    if (_socketState == 2) {
      return;
    }
    _authSocket();
  }

  Widget _paymentSubwidget(int index) {
    if (model.paymentTypes.payment_types[index].id != 2) {
      return Container();
    }
    if (model.paymentTypes.getSelected()!.id != 2) {
      return Container();
    }
    return ListView.builder(
        itemCount: model.companies.companies.length,
        //model.companies.companies.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int cidx) {
          return GestureDetector(
              onTap: () {
                setState(() {
                  model.companies.setChecked(cidx);
                });
              },
              child: Row(children: [
                VerticalDivider(width: 20, color: Colors.transparent),
                Checkbox(
                  tristate: true,
                  activeColor: Consts.colorTaxiBlue,
                  value: model.companies.companies[cidx].checked,
                  onChanged: (bool? v) {
                    setState(() {
                      model.companies.setChecked(cidx);
                    });
                  },
                ),
                Expanded(child: Text(model.companies.companies[cidx].name)),
              ]));
        });
  }

  void _restoreState() {
    WebRealState webRealState = WebRealState();
    webRealState.request((Map<String, dynamic> mp) {
      model.currentState = mp["status"];
      switch (mp["status"]) {
        case state_none:
          model.currentPage = pageSelectShortAddress;
          break;
        case state_pending_search:
          model.tracking = false;
          model.currentPage = pageSearchTaxi;
          break;
        case state_driver_accept:
          model.tracking = false;
          model.currentPage = pageDriverAccept;
          model.events["driver_accept"] = mp;
          break;
        case state_driver_onway:
          model.tracking = false;
          model.currentPage = pageDriverOnWayToClient;
          model.events["driver_accept"] = mp;
          break;
        case state_driver_onplace:
          model.tracking = false;
          model.currentPage = pageDriverOnPlace;
          model.events["driver_accept"] = mp;
          break;
        case state_driver_orderstarted:
          model.tracking = false;
          model.currentPage = pageOrderStarted;
          model.events["driver_order_started"] = mp;
          break;
        case state_driver_orderend:
          model.tracking = false;
          model.currentPage = pageOrderEnd;
          model.events["driver_order_end"] = mp;
          break;
      }
      setState(() {});
    }, (c, s) {
      if (c == 401) {
        Consts.setString("bearer", "");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        setState(() {
          model.currentPage = pageRealState;
        });
        sleep(const Duration(seconds: 2));
        model.init = false;
        _restoreState();
      }
    });
    model.getChatCount();
  }

  String _getPhoneFormatted() {
    MaskTextInputFormatter mf = MaskTextInputFormatter(
        mask: '+### (##) ###-###',
        filter: {"#": RegExp(r'[0-9]')},
        initialText: Consts.getString("phone"));
    String s = mf.getMaskedText();
    return s;
  }

  void _pingpong() {
    if (_socket == null) {
      return;
    }
    String auth = '{"data":{},  "event":"pusher:ping"}';
    _socket!.add(auth);
    Timer(Duration(milliseconds: 30000), () => _pingpong());
  }

  void _setSocketConnected(bool v) {
    setState(() {
      _socket_connected = v;
    });
  }

  void _cameraPosition(
      CameraPosition cameraPosition, CameraUpdateReason reason, bool finished) {
    if (!model.tracking) {
      return;
    }
    if (!model.init) {
      return;
    }
    model.rideZoom = cameraPosition.zoom;
    Consts.setDouble("last_lat", cameraPosition.target.latitude);
    Consts.setDouble("last_lon", cameraPosition.target.longitude);
    if (model.currentPage != pageSelectShortAddress) {
      return;
    }
    setState(() {});

    if (RouteHandler.routeHandler.destinationDefined()) {
      setState(() {
        model.loadingData = true;
      });
      model.initCoin(context, () {
        setState(() {
          model.loadingData = false;
        });
      }, () {
        setState(() {
          model.loadingData = false;
        });
      });
      return;
    }

    model.addressFrom.text = "определяем адрес...";
    model.geocode.geocode(cameraPosition.target.latitude,
        cameraPosition.target.longitude, _geocodeResponse);
  }

  void resetAddresses() {
    model.removePolyline(centerMe: true);
    model.addressTo.text = "";
    RouteHandler.routeHandler.directionStruct.to.clear();
    setState(() {});
  }

  void _clearTaxiOnMap() {
    List<MapObject> mm = [];
    for (MapObject mo in model.mapObjects) {
      if (mo.mapId.toString().contains("taxionmap")) {
        mm.add(mo);
      }
    }
    for (MapObject mo in mm) {
      model.mapObjects.remove(mo);
    }
  }

  void _getUnreadMessages() {
    var client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(client);
    ioClient.get(
        Uri.parse(
            'https://${Consts.host()}/app/mobile/get_unread_messages?clientDriverConversation="true"'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Consts.getString("bearer")}'
        }).then((value) {
      print(value.body.toString());
      Map<String, dynamic> m = jsonDecode(value.body.toString());
      ChatMessageList cml = ChatMessageList.fromJson({'list': m['messages']});
      print(cml);

      String chat = Consts.getString("chat");
      if (chat.isEmpty) {
        chat = "{\"chat\":[]}";
      }
      Map<String, dynamic> chatdata = jsonDecode(chat);

      DateTime time = DateTime.now();
      DateFormat df = DateFormat("HH:mm");
      String ids = '';
      for (var e in cml.list) {
        Map<String, Map<String, String>> msg = {"messageData": {}};
        msg["messageData"]!.addAll({"sender": "driver"});
        msg["messageData"]!.addAll({"time": df.format(time)});
        msg["messageData"]!.addAll({"text": e.message});
        chatdata["chat"].add(msg);
        if (ids.isNotEmpty) {
          ids += ',';
        }
        ids += e.order_conversation_id.toString();
      }

      var client2 = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      IOClient ioClient2 = IOClient(client2);
      ioClient2
          .post(Uri.parse('https://${Consts.host()}/app/mobile/message_read'),
              headers: {
                'content-type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${Consts.getString("bearer")}',
              },
              body: '{"ids":[$ids], "clientDriverConversation":"true"}')
          .then((value) {
        print(value.body.toString());
      });

      Consts.setString("chat", jsonEncode(chatdata));
    });
    _scrollChatToBottom();
  }

  Future<void> playSoundChat() async {
    print(DateTime.now());
    const alarmAudioPath = "chat.mp3";
    var p = AudioPlayer();
    p.setReleaseMode(ReleaseMode.stop);
    await p.play(AssetSource(alarmAudioPath), mode: PlayerMode.lowLatency);
    //await player.stop();
    //player.dispose();
    print(DateTime.now());
  }

  Widget _appendAddressToWidget(BuildContext context) {
    return AnimatedPositioned(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        duration: Duration(milliseconds: 300),
        top: model.showSingleAddress ? 00 : MediaQuery.of(context).size.height,
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: SingleAddressSelect(model, () {
            FocusManager.instance.primaryFocus?.unfocus();
            setState(() {
              model.addressTo.text =
                  RouteHandler.routeHandler.addressTo().join(" → ");
            });
            countRoute();
          }),
        ));
  }

  Widget _multiAddressWiget(BuildContext context) {
    return AnimatedPositioned(
        width: MediaQuery.of(context).size.width,
        //top: model.showMultiAddress ? MediaQuery.of(context).size.height - (RouteHandler.routeHandler.directionStruct.to.length * 30.0) : MediaQuery.of(context).size.height,
        top: model.showMultiAddress ? 0 : MediaQuery.of(context).size.height,
        child: MultiaddressToScreen(model, () {
          model.addressTo.text =
              RouteHandler.routeHandler.addressTo().join(" → ");
          countRoute();
        }),
        duration: Duration(milliseconds: 200));
  }

  void countRoute() {
    if (model.currentPage == pageSelectCar) {
      setState(() {
        model.loadingData = true;
      });
      model.initCoin(context, () {
        setState(() {
          model.loadingData = false;
        });
      }, () {
        setState(() {
          model.loadingData = false;
        });
      });
    } else {
      setState(() {});
    }
  }

  Widget _walletOptions(BuildContext context) {
    return AnimatedPositioned(
      top: model.showWallet ? 0 : MediaQuery.sizeOf(context).height,
        child: PaymentWidget(model, (){setState(() {

        });}), duration: const Duration(milliseconds: 300));
  }
}
