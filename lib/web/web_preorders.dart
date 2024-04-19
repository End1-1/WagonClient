import 'web_parent.dart';

class WebPreorders extends WebParent {

  WebPreorders(skip, take) : super("/app/mobile/preorders", HttpMethod.GET);

  static void get(int skip, int take, Function done, Function fail) {
    WebPreorders webPreorders = WebPreorders(skip, take);
    webPreorders.request(done, fail);
  }

  @override
  dynamic getBody() {
    switch (method) {
      case HttpMethod.GET:
        return super.getBody();
      case HttpMethod.DELE:
        return super.getBody();
      default:
        return "";
    }
  }
}