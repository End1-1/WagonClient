import 'package:wagon_client/consts.dart';

import 'web_parent.dart';

class WebSettings extends WebParent {

  WebSettings(HttpMethod method) : super("/app/mobile/c_settings", method);

  static void get(Function done, Function fail) {
    WebSettings webSettings = WebSettings(HttpMethod.GET);
    webSettings.request(done, fail);
  }

  static void save(Function done, Function fail) {
    WebSettings webSettings = WebSettings(HttpMethod.PUT);
    webSettings.request(done, fail);
  }

  @override
  dynamic getBody() {
    switch (method) {
      case HttpMethod.GET:
        return super.getBody();
      case HttpMethod.PUT:
        return {
          "_method": "PUT",
          "show_cord": Consts.getBoolean("show_me_for_driver") ? "1" : "0",
          "call": Consts.getBoolean("do_not_call") ? "1" : "0"
        };
      default:
        return super.getBody();
    }
  }
}