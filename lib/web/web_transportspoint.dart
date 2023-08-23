

import 'package:wagon_client/airports_metro.dart';
import 'package:wagon_client/web/web_parent.dart';

class WebTransportPoints extends WebParent {
  WebTransportPoints() : super("/app/mobile/transports_point/moscow", HttpMethod.GET);

  static void getList(Function done, Function fail) async {
    WebTransportPoints webTransportPoints = WebTransportPoints();
    await webTransportPoints.request((mp) {
      TransportPoints tp = TransportPoints.fromJson(mp);
      done(tp);
    }, fail);
  }
}