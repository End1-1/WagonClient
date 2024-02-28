import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/dlg.dart';
import 'package:wagon_client/model/address_model.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screen2/model/model.dart';
import 'package:wagon_client/screens/login/screen.dart';
import 'package:wagon_client/web/web_initopen.dart';
import 'package:wagon_client/web/yandex_geocode.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:wagon_client/consts.dart';

class MapController {
  final mapBroadcast = StreamController.broadcast();
  late YandexMapController mapController;
  final Screen2Model model;
  final List<MapObject> mapObjects = [];

  MapController(this.model);

  void mapReady(YandexMapController controller) async {
    mapController = controller;
    mapController.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: Point(
                latitude: Consts.getDouble('last_lat'),
                longitude: Consts.getDouble('last_lon')))));
    await _getLocation();
    model.socket.authSocket();
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

    Position p = await Geolocator.getCurrentPosition();
    mapController.moveCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
            target: Point(latitude: p.latitude, longitude: p.longitude),
            zoom: 16)),
        animation: MapAnimation(duration: 1));

      RouteHandler.routeHandler.setPointFrom(p);
      model.mapController.mapController.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: Point(latitude: p.latitude, longitude: p.longitude),
              zoom: 16)));

      WebInitOpen webInitOpen =
      WebInitOpen(latitude: p.latitude!, longitude: p.longitude!);
      webInitOpen.request((mp) {
        model.requests.parseInitOpenData(mp);
        model.requests.initCoin(() {}, (c, s) {
          if (c == 401) {
            Consts.setString("bearer", "");
            Navigator.pushReplacement(Consts.navigatorKey.currentContext!,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          } else {
            Dlg.show("initCoin()\r\n" + s);
          }
        });
      }, (c, s) {
        if (c == 401) {
          Consts.setString("bearer", "");
          Navigator.pushReplacement(
              Consts.navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
          Dlg.show("initOpen()\r\n");
        }
      });

  }

  void cameraPosition(CameraPosition cameraPosition, CameraUpdateReason reason, bool finished) {
    model.appState.addressFrom.text = tr(trGettingAddress);
    YandexGeocodeHandler().geocode(cameraPosition.target.latitude, cameraPosition.target.longitude, (d) {
      print(d);
      model.appState.addressFrom.text = d.title;
    });
  }

  void geocodeResponse(AddressStruct ass) {
    // if (model.isMapPressed) {
    //   setState(() {
    //     model.isMapPressed = false;
    //   });
    // }
    RouteHandler.routeHandler.directionStruct.from = ass;
    model.appState.addressFrom.text = ass.title;
    // if (model.currentPage == pageSelectCar ||
    //     model.currentPage == pageSelectShortAddress) {
    //   model.initCoin(context, () {
    //     setState(() {});
    //   }, () {
    //     setState(() {});
    //   });
    //}
  }
}