import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wagon_client/web/yandex_geocode.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';


class MyAddressSelectModel {
  late String name;
  YandexGeocodeHandler geocode = YandexGeocodeHandler();
  List<SuggestItem> suggestList = [];
  final TextEditingController addressController = TextEditingController();
  dynamic result;
  late double lat;
  late double lon;

  MyAddressSelectModel() {
    Geolocator.getCurrentPosition().then((value) {
      lat = value.latitude;
      lon = value.longitude;
    });
  }
}