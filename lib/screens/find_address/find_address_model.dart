import 'package:flutter/cupertino.dart';
import 'package:wagon_client/web/web_transportspoint.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../airports_metro.dart';
import '../../preorders.dart';
import '../../web/web_myaddresses.dart';
import '../../web/yandex_geocode.dart';

class FindAddressModel {
  YandexGeocodeHandler geocode = YandexGeocodeHandler();
  TransportPoints transportPoints = TransportPoints([], [], []);
  TransportPoints transportFavorites = TransportPoints([], [], []);
  List<TransportPoint>? currentList;
  final TextEditingController addressFrom = TextEditingController();
  final TextEditingController addressTo = TextEditingController();
  List<SuggestItem>? suggestList;
  bool selectFrom = false;
  bool ready = true;

  FindAddressModel() {
    WebTransportPoints.getList((mp) {
      transportPoints = mp;
      WebMyAddresses.getList(getMyAddressesList, null);
    }, () {});
  }

  void getMyAddressesList(d) {
    for (Map<String, dynamic> m in d) {
      TransportPoint p = TransportPoint(0, 0, 0, m["name"], "", "",
          Coordinate(m["cords"]["lat"], m["cords"]["lut"]), m["address"]);
      p.tp = TP.TP_FAVORITE;
      transportFavorites.favorites.add(p);
    }
  }
}