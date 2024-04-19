import 'package:get/get.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/model/address_model.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as ym;

class YandexGeocodeHandler {
  static bool _canceled = false;
  static bool _busy = false;
  static bool _last = false;
  static double _lastLat = 0.0;
  static double _lastLon = 0.0;
  static String _lastAddress = '';
  static Function(AddressStruct)? _lastFunction;

  bool _isBusy() {
    print("------------Request busy " + (_busy ? "true" : "false"));
    return _busy;
  }

  Future<void> geocode(
      double latitude, double longitude, Function(AddressStruct) f) async {
    if (_isBusy()) {
      _last = true;
      _lastLat = latitude;
      _lastLon = longitude;
      _lastFunction = f;
      return;
    }
    _busy = true;



    try {
      PointRecord aaaa = (lat: latitude, lon: longitude);
      YandexGeocoder yg = YandexGeocoder(apiKey: Consts.yandexGeocodeKey);
      GeocodeRequest geocodeRequest = ReverseGeocodeRequest(
          results: 10,
          kind: KindRequest.house ,
          // spn: SearchAreaSPN(differenceLatitude: 3.552069, differenceLongitude: 2.400552),
          // ll: SearchAreaLL(latitude: _lastLat, longitude: _lastLon),
          pointGeocode: aaaa);
      GeocodeResponse geocodeResponse = await yg.getGeocode(geocodeRequest);

      if (_last) {
        _busy = false;
        _last = false;
        geocode(_lastLat, _lastLon, _lastFunction!);
        return;
      }

      print("ALLL ADDRESSES");

      Address? a = geocodeResponse.firstAddress;
      List<String> title = [];
      if (a != null) {
        String? street = a.components
            ?.firstWhere((e) => e.kind == KindResponse.street, orElse: () {
              return Component(
                  kind: KindResponse.street,
                  name: a.formatted
                      ?.replaceAll('Армения, ', '')
                      .replaceAll('Armenia, ', '')
                      .replaceAll('Հայաստան, ', ''));
            })
            .name
            ?.replaceAll('Армения, ', '')
            .replaceAll('Armenia, ', '')
            .replaceAll('Հայաստան, ', '');
        String? house = a.components
            ?.firstWhere((e) => e.kind == KindResponse.house, orElse: () {
          return Component(kind: KindResponse.house, name: '');
        }).name;
        if (street != null) {
          title.add(street);
        }
        if (house != null) {
          title.add(house);
        }
      }
      AddressStruct addressStruct = AddressStruct(
          address: a?.formatted
                  ?.replaceAll('Армения, ', '')
                  .replaceAll('Armenia, ', '')
                  .replaceAll('Հայաստան, ', '') ??
              '',
          title: title.join(", "),
          point: ym.Point(latitude: latitude, longitude: longitude));
      f(addressStruct);
    } catch (e) {
      e.printError();
    }

    _busy = false;
    _last = false;
  }

  Future<void> geocodeAddress(String address, Function f) async {
    if (_busy) {
      return;
    }
    _busy = true;

    try {
      YandexGeocoder yg = YandexGeocoder(apiKey: Consts.yandexGeocodeKey);
      GeocodeRequest geocodeRequest =
          DirectGeocodeRequest(addressGeocode:  address);
      GeocodeResponse geocodeResponse = await yg.getGeocode(geocodeRequest);

      AddressStruct addressStruct = AddressStruct(
          address: geocodeResponse.firstAddress?.formatted ?? '',
          title: '',
          point: ym.Point(
              latitude: geocodeResponse.firstPoint?.lat ?? 0,
              longitude: geocodeResponse.firstPoint?.lon ?? 0));

      f(addressStruct);
    } catch (e) {
      e.printError();
    }
    _busy = false;
    _last = false;
  }

  dynamic _find(String key, Map<String, dynamic> mp) {
    for (final k in mp.keys) {
      var v = mp[k];
      if (k == key) {
        return v;
      }
      if (v is Map<String, dynamic>) {
        var o = _find(key, v);
        if (o != null) {
          return o;
        }
      }
      if (v is List) {
        List<dynamic> l = v;
        for (final e in l) {
          var o = _find(key, e);
          if (o != null) {
            return o;
          }
        }
      }
    }
    return null;
  }

  void cancel() {
    _canceled = true;
  }
}
