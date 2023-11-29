import 'package:sprintf/sprintf.dart';

import 'web_parent.dart';

class WebHistoryDetail extends WebParent {

  WebHistoryDetail(int id) : super("/app/mobile/order_detail/${id}", HttpMethod.GET);
}