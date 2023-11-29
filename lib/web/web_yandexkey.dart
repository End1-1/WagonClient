import 'package:sprintf/sprintf.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/web/web_parent.dart';

class WebYandexKey extends WebParent {
  WebYandexKey() : super("/app/mobile/get_api_keys/1/${ Consts.yandexGeocodeKey}", HttpMethod.GET);

  @override
  Future<void> request(Function done, Function? fail) async {
      return await super.request((mp) {
        Consts.yandexGeocodeKey = mp["_payload"]["key"];
        Consts.setString("yandexkey", Consts.yandexGeocodeKey);
      }, (c, s) {
        if (fail != null) {
          print('YANDEX KEY FAILED');
          fail(c, s);
        }
      });
  }
}