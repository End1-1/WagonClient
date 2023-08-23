import 'package:sprintf/sprintf.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/web/web_parent.dart';

class WebYandexKey extends WebParent {
  WebYandexKey() : super(sprintf("/app/mobile/get_api_keys/%d/%s", [1, Consts.yandexGeocodeKey]), HttpMethod.GET);

  @override
  Future<void> request(Function done, Function? fail) async {
      super.request((mp) {
        print(mp);
        Consts.yandexGeocodeKey = mp["_payload"]["key"];
      }, (c, s) {
        if (fail != null) {
          fail(c, s);
        }
      });
  }
}