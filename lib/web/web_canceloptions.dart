import 'dart:convert';

import '../consts.dart';
import 'web_parent.dart';

class WebSendCancelReason extends WebParent {

  int aborted_order_id;
  int? completed_order_id;
  int? optionId;
  String text;
  String assessment;
  String feedbackText;
  bool favorite;
  int driverRating;

  WebSendCancelReason(
      this.aborted_order_id,
      this.completed_order_id,
      this.optionId,
      this.text,
      this.assessment,
      this.feedbackText,
      this.favorite,
      this.driverRating
      ) : super("/app/mobile/add_feedback", HttpMethod.POST);

  @override
  dynamic getBody() {
    Map<String, dynamic> jo = Map();
    if (aborted_order_id > 0) {
      jo["aborted_order_id"] = aborted_order_id;
    }
    if (completed_order_id! > 0) {
      jo["completed_order_id"] = completed_order_id;
    }
    Map<String, dynamic> joption = Map();
    joption["option_id"] = optionId;
    joption["text"] = text;
    //joption["assessment"] = assessment;
    if (aborted_order_id > 0) {
      joption["assessment"] = "";
    }
    if (completed_order_id! > 0) {
      joption["assessment"] = driverRating;
    }
    jo["feedback"] = joption;
    jo["feedback"]["text"] = feedbackText;
    jo["favorite"] = favorite;
    return utf8.encode(jsonEncode(jo));
  }

  @override
  dynamic getHeader() {
    return {
      'content-type': 'application/json',
      'Accept':'application/json',
      'Authorization': 'Bearer ' + Consts.getString("bearer")
    };
  }
}