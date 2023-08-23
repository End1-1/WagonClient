import 'web_parent.dart';

class WebEnterPhone extends WebParent {

  String? phone;

  WebEnterPhone({this.phone}) : super("/app/mobile/register", HttpMethod.POST);

  @override
  dynamic getBody() {
    return {
      'phone': phone
    };
  }

}