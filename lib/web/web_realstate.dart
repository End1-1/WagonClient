
import 'web_parent.dart';

class WebRealState extends WebParent {
  static bool isBusy = false;
  WebRealState() : super("/app/mobile/real_state", HttpMethod.GET);

  @override
  Future<void> request(Function done, Function? fail) async {
    if (isBusy) {
      return;
    }
    try {
      isBusy = true;
      super.request((mp) {
        done(mp);
      }, (c, s) {
        if (fail != null) {
          fail(c, s);
        }
      });
    } finally {
      isBusy = false;
    }
  }
}