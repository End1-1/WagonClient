import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/dlg.dart';
import 'package:wagon_client/model/address_model.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/screen2/model/app_state.dart';
import 'package:wagon_client/screen2/model/model.dart';
import 'package:wagon_client/screens/login/screen.dart';
import 'package:wagon_client/web/web_initopen.dart';
import 'package:wagon_client/web/yandex_geocode.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';


class MapController {
  final mapBroadcast = StreamController.broadcast();
  late YandexMapController mapController;
  final Screen2Model model;
  final List<MapObject> mapObjects = [];

  final List<MapObjectId> routePolylineId = [
    MapObjectId("_routePolylineId1"),
    MapObjectId("_routePolylineId2"),
    MapObjectId("_routePolylineId3"),
    MapObjectId("_routePolylineId4")
  ];

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

      //RouteHandler.routeHandler.setPointFrom(p);
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
    model.appState.addressTemp.text = tr(trGettingAddress);
    if (!model.appState.mapPressed && !finished) {
      model.appState.mapPressed = true;
      model.markerStream.add(null);
    }
    if (finished) {
      model.appState.mapPressed = false;
      model.markerStream.add(null);
    }
    YandexGeocodeHandler().geocode(cameraPosition.target.latitude, cameraPosition.target.longitude, (d) {
      print(d);
      Consts.setDouble('last_lat', cameraPosition.target.latitude);
      Consts.setDouble('last_lon', cameraPosition.target.longitude);
      if (model.appState.appState == AppState.asIdle) {
        model.appState.addressFrom.text = d.title;
        model.appState.structAddressFrom = d;
        model.appState.addressTemp.text = d.title;
        model.appState.structAddressTemp = d;
        if (finished) {
          if (model.appState.acType > 0) {
            model.requests.initCoin(() async {
              await model.mapController.paintRoute();
            }, (c, e) {});
          }
        }
      }
      if (model.appState.appState == AppState.asSearchOnMapFrom
      || model.appState.appState == AppState.asSearchOnMapTo) {
          model.appState.addressTemp.text = d.title;
          model.appState.structAddressTemp = d;
      }
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

  Future<void> removePolyline({required bool centerMe}) async {
    if (centerMe) {
      await model.centerme();
    }
    while (mapObjects.isNotEmpty) {
      mapObjects.removeLast();
    }
  }

  Future<void> paintRoute() async {
    await removePolyline(centerMe: false);
    if (model.appState.structAddressTod.isEmpty) {
      return;
    }
    routePolylineId.clear();
    routePolylineId.addAll([
      MapObjectId("_routePolylineId1"),
      MapObjectId("_routePolylineId2"),
      MapObjectId("_routePolylineId3"),
      MapObjectId("_routePolylineId4")
    ]);
    var resultWithSession = YandexDriving.requestRoutes(
        points: [
          RequestPoint(point: model.appState.structAddressFrom!.point!, requestPointType: RequestPointType.wayPoint),
          for (int i = 0; i < model.appState.structAddressTod.length - 1; i++) ... [
            RequestPoint(point: model.appState.structAddressTod[i].point!, requestPointType: RequestPointType.viaPoint),
          ],
          RequestPoint(point: model.appState.structAddressTod.last.point!, requestPointType: RequestPointType.wayPoint),
        ],
        drivingOptions: const DrivingOptions(
            initialAzimuth: 0,
            routesCount: 1,
            avoidTolls: true
        )
    );

    if (model.appState.structAddressFrom != null && model.appState.structAddressTod.isNotEmpty) {

      final value = await resultWithSession.result;
      print(value);
      if (value.routes != null) {
        if (value.routes!.isNotEmpty) {
          print("DRAW ROUTE");
          DrivingRoute r = value.routes!.first;

          //Route
          mapObjects.add(PolylineMapObject(
            mapId: routePolylineId[0],
            polyline: Polyline(points: r.geometry),
            strokeColor: Colors.blue[700]!,
            strokeWidth: 5,
            // <- default value 5.0, this will be a little bold
            outlineColor: Colors.yellow[200]!,
            outlineWidth: 1.0,
          ));

          //Start point
          PlacemarkMapObject point1 = PlacemarkMapObject(
              mapId: MapObjectId('startpoint'),
              direction: 0,
              point: model.appState.structAddressFrom!.point!,
              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                      'images/circle_bold_black.png'),
                  rotationType: RotationType.rotate)));
          mapObjects.add(point1);

          //Via point
          for (int i = 0; i < model.appState.structAddressTod.length - 1; i++) {
            PlacemarkMapObject point = PlacemarkMapObject(
                mapId: MapObjectId('via${i}'),
                direction: 0,
                point: model.appState.structAddressTod[i].point!,
                icon: PlacemarkIcon.single(PlacemarkIconStyle(
                    image: BitmapDescriptor.fromAssetImage(
                        'images/circle_bold_red.png'),
                    rotationType: RotationType.rotate)));
            mapObjects.add(point);
          }

          //End point
          PlacemarkMapObject point = PlacemarkMapObject(
              mapId: MapObjectId('endpoint'),
              direction: 0,
              point: model.appState.structAddressTod.last.point!,
              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                      'images/circle_bold_black.png'),
                  rotationType: RotationType.rotate)));
          mapObjects.add(point);


        }
      }

    }
  }
}