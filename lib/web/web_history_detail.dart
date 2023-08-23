import 'package:sprintf/sprintf.dart';

import 'web_parent.dart';

class WebHistoryDetail extends WebParent {

  WebHistoryDetail(int id) : super(sprintf("/app/mobile/order_detail/%d", [id]), HttpMethod.GET);
}