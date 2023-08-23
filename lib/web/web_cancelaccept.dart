import 'web_parent.dart';

class WebCancelAccept extends WebParent {
  bool accepted = false;
  WebCancelAccept(this.accepted) : super("/app/mobile/cancel-accept-place", HttpMethod.POST);

  @override
  dynamic getBody() {
    // Map<String, dynamic> jo = Map();
    // jo["accept"] = accepted;
    // return utf8.encode(jsonEncode(jo));
    return {
      "accept" : accepted ? "true" : "false"
    };
  }
}