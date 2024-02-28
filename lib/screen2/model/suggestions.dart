import 'package:wagon_client/model/address_model.dart';
import 'package:wagon_client/screens/find_address/full_address_state.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'model.dart';

class Suggestions {
  final Screen2Model model;

  Suggestions(this.model);

  void suggest(String template) {
    model.suggestStream.add(true);
    var suggestResultWithSession = YandexSuggest.getSuggestions(
        text: template.trim(),
        boundingBox: BoundingBox(
            northEast: Point(
                latitude: 40.250797,
                longitude: 44.586990),
            southWest: Point(
                latitude: 40.146545,
                longitude: 44.389950)),
        suggestOptions: SuggestOptions(
            suggestType: SuggestType.geo,
            suggestWords: true,
            userPosition: RouteHandler.routeHandler.lastPoint));
    suggestResultWithSession.result.then((value) {
      model.suggestStream.add(value.items);
    });
  }
}