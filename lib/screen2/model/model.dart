import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/screen2/model/ac_type.dart';
import 'package:wagon_client/screen2/model/app_websocket.dart';
import 'package:wagon_client/screen2/model/requests.dart';
import 'package:wagon_client/screen2/model/suggestions.dart';
import 'package:wagon_client/web/web_initopen.dart';
import 'package:wagon_client/web/web_parent.dart';

import 'app_state.dart';
import 'map_controller.dart';

class Screen2Model {

  final socket = AppWebSocket();
  late final AppState appState;
  final acTypes = ACType();
  late final Suggestions suggest;
  late final Requests requests;
  late final MapController mapController;
  final suggestStream = StreamController.broadcast();
  final taxiCarsStream = StreamController.broadcast();

  Screen2Model() {
    mapController = MapController(this);
    requests = Requests(this);
    suggest = Suggestions(this);
    appState = AppState(this);
  }

  void setAcType(int t, Function state) {
    appState.acType = t;
    switch (t) {
      case ACType.act_taxi:
        appState.dimVisible = true;
        WebInitOpen wr = WebInitOpen(latitude:  Consts.getDouble('last_lat'), longitude:  Consts.getDouble('last_lon'));
        wr.request(parseWebInitOpen, parseError).then((value) {
          state();
        });
        // WebParent w = new WebParent('/app/mobile/init_open', HttpMethod.POST);
        // w.body = <dynamic, dynamic>{
        //   'lat': Consts.getDouble('last_lat'),
        //   'lut': Consts.getDouble('last_lon'),
        // };
        // w.request(parseWebInitOpen, parseError);
        break;
    }
  }

  void parseWebInitOpen(dynamic d) {
    List<dynamic> cars = d['data']['car_classes'];
    if (cars.isNotEmpty) {
      appState.currentCar = cars[0]['class_id'];
    }
    appState.dimVisible = false;
    taxiCarsStream.add(cars);
  }

  void parseError(int code, String err) {
    print('$code ---- $err');
  }

  void appResumed(Function parentState) {
    socket.authSocket();
    appState.getState(parentState);

  }

  void appPaused() {
    socket.closeSocket();
  }
}