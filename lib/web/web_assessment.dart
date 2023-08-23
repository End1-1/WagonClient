import 'package:sprintf/sprintf.dart';

import 'web_parent.dart';

class WebAssessments extends WebParent {

  WebAssessments(int rate) : super(sprintf("/app/mobile/get_details_assessment/%d", [rate]), HttpMethod.GET);

}