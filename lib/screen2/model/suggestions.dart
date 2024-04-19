import 'dart:math';

import 'package:wagon_client/consts.dart';
import 'package:wagon_client/model/address_model.dart';
import 'package:wagon_client/screens/find_address/full_address_state.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'model.dart';

class Suggestions {
  final Screen2Model model;

  Suggestions(this.model);

  void suggest(String template) async {
    if (template.length < 3) {
      return;
    }
    model.suggestStream.add(true);
    var suggestResultWithSession = await YandexSuggest.getSuggestions(
        text: template.trim(),
        boundingBox: BoundingBox(
            northEast: Point(
                latitude: 40.250797,
                longitude: 44.586990),
            southWest: Point(
                latitude: 40.146545,
                longitude: 44.389950)),
        suggestOptions: SuggestOptions(
            suggestType: SuggestType.unspecified,
            suggestWords: true,
            userPosition: Point(latitude: Consts.getDouble('last_lat'), longitude:  Consts.getDouble('last_lon'))));
    suggestResultWithSession.$2.then((value) {
      final items = [];
      for (final i in value.items ?? []) {
        if (i.tags.contains('province')) {
          continue;
        }
        if (i.center == null) {
          continue;
        }
        var distance = CalcGPSDistance(Consts.getDouble('last_lat'), Consts.getDouble('last_lon'), i.center.latitude, i.center.longitude);
        if (distance > 50000 ){
          continue;
        }
        if (i.type == SuggestItemType.toponym ||
            i.type == SuggestItemType.business) {
          items.add(i);
        }
      }
      model.suggestStream.add(items);
    });
  }



  double CalcGPSDistance(double latitud1, double longitud1, double latitud2, double longitud2){
    var PI = 3.14159265358979323846;
    var RADIO_TERRESTRE = 6372797.56085;
    var GRADOS_RADIANES  = PI / 180;

    double haversine;
    double temp;
    double distancia_puntos;

    latitud1  = latitud1  * GRADOS_RADIANES;
    longitud1 = longitud1 * GRADOS_RADIANES;
    latitud2  = latitud2  * GRADOS_RADIANES;
    longitud2 = longitud2 * GRADOS_RADIANES;

    haversine = (pow(sin((1.0 / 2) * (latitud2 - latitud1)), 2)) + ((cos(latitud1)) * (cos(latitud2)) * (pow(sin((1.0 / 2) * (longitud2 - longitud1)), 2)));
    temp = 2 * asin(min(1.0, sqrt(haversine)));
    distancia_puntos = RADIO_TERRESTRE * temp;

    return distancia_puntos;
  }

}