import 'package:sprintf/sprintf.dart';

import 'web_parent.dart';

class WebHistory extends WebParent {
  WebHistory(int skip, int take)
      : super(
            sprintf("/app/mobile/orders/%d/%d", [skip, take]), HttpMethod.GET);

  Future<void> request(Function done, Function? fail) async {
    super.request(done, fail);
  }
}
