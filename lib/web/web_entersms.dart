import 'web_parent.dart';

class WebEnterSms extends WebParent {

  String? sms;
  String? phone;
  String? fcmtoken;

  WebEnterSms({this.sms, this.phone, this.fcmtoken}) : super("/app/mobile/auth", HttpMethod.POST);

  @override
  dynamic getBody() {
    return {
      'phone': phone,
      'accept_code': sms,
      'fcmtoken': fcmtoken
    };
  }

}