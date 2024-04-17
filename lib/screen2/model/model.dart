import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/dlg.dart';
import 'package:wagon_client/screen2/model/ac_type.dart';
import 'package:wagon_client/screen2/model/app_websocket.dart';
import 'package:wagon_client/screen2/model/requests.dart';
import 'package:wagon_client/screen2/model/suggestions.dart';
import 'package:wagon_client/screens/login/screen.dart';
import 'package:wagon_client/web/web_initopen.dart';
import 'package:wagon_client/web/web_parent.dart';
import 'package:wagon_client/web/yandex_geocode.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

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
  final markerStream = StreamController.broadcast();
  final initCoinStream = StreamController.broadcast();
  final List<dynamic> cars = [];

  Screen2Model() {
    mapController = MapController(this);
    requests = Requests(this);
    suggest = Suggestions(this);
    appState = AppState(this);

    if (Consts.getDouble('last_lat') > 0.01) {
      YandexGeocodeHandler().geocode(
          Consts.getDouble('last_lat'), Consts.getDouble('last_lon'), (d) {
        appState.addressFrom.text = d.title;
        appState.structAddressFrom = d;
        appState.addressTemp.text = d.title;
        appState.structAddressTemp = d;
      });}
  }

  void setAcType(int t, Function state) {
    appState.acType = t;
    switch (t) {
      case ACType.act_taxi:
        appState.dimVisible = true;
        state();
        requests.initCoin((){
          appState.dimVisible = false;
          state();
        }, (c,s){
          Dlg.show(s);
        });


        // WebInitOpen wr = WebInitOpen(latitude:  Consts.getDouble('last_lat'), longitude:  Consts.getDouble('last_lon'));
        // wr.request(parseWebInitOpen, parseError).then((value) {
        //   state();
        // });


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
    cars.clear();
    cars.addAll(d['data']['car_classes']);
    if (cars.isNotEmpty) {
      appState.currentCar = cars[0]['class_id'];
    }
    appState.dimVisible = false;
  }

  void parseError(int code, String err) {
    print('$code ---- $err');
  }

  void appResumed(Function parentState) {
    socket.authSocket();
    appState.getState(parentState).then((value) {
      if (appState.acType == ACType.act_taxi) {
        setAcType(appState.acType, parentState);
      }
    });

  }

  void appPaused() {
    socket.closeSocket();
  }

  void setAddressToText() {
    var first = true;
    var s = '';
    for (final e in appState.structAddressTod) {
      if (first) {
        first = false;
      } else {
        s += '→';
      }
      s += e.title;
    }
    appState.addressTo.text = s;
  }

  Future<void> centerme() async {
    Position p = await Geolocator.getCurrentPosition();
    mapController.mapController!.moveCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
            target: Point(latitude: p.latitude, longitude: p.longitude),
            zoom: 18)),
        animation: MapAnimation(duration: 1));
  }

  void logout() {
    Consts.setInt("client_id", 0);
    Consts.setString("phone", "");
    Consts.setString("bearer", "");
    Navigator.pushReplacement(
        Consts.navigatorKey.currentContext!,
        MaterialPageRoute(
            builder: (context) => LoginScreen()));
  }
}