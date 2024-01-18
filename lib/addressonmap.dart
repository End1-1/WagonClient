import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:wagon_client/model/address_model.dart';

import 'consts.dart';
import 'model/tr.dart';
import 'web/yandex_geocode.dart';

class AddressOnMap extends StatefulWidget {

  @override
  State createState() {
    return AddressOnMapState();
  }
}

class AddressOnMapState extends State<AddressOnMap> {
  late YandexMapController _mapController;
  YandexGeocodeHandler _yandexGeocode = YandexGeocodeHandler();
  String _address = tr(trGettingAddress);
  AddressStruct data = AddressStruct(address: '', title: '',  point: null);

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: SafeArea (
        child: Stack (
          children: [
            YandexMap(onMapCreated: _mapReady, mapObjects: [], onCameraPositionChanged: (c,v, b){},),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text("$_address", style: Consts.textStyle7, )
                  )
                ),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: TextButton(
                    onPressed: _ready,
                    child: Text(tr(trReady))
                  )
                )
              ],
            ),
            Center (
              child: Image.asset("images/placemark.png", width: 120, height: 120)
            )
          ]
        )
      )
    );
  }

  void _mapReady(YandexMapController controller) async {
   _mapController = controller;
   Position p = await Geolocator.getCurrentPosition();
   _mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: Point(latitude: p.latitude, longitude: p.longitude))));
  }

  void _ready() {
    Navigator.pop(context, data);
  }

  @override
  void dispose() {
    _yandexGeocode.cancel();
    //_mapController.dispose();
    super.dispose();
  }


}