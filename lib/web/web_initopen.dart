import 'web_parent.dart';

class WebInitOpen extends WebParent {
  late double latitude;
  late double longitude;

  WebInitOpen({required this.latitude, required this.longitude}) : super("/app/mobile/init_open", HttpMethod.POST);

  @override
  dynamic getBody() {
    return {
      'lat': latitude.toString(),
      'lut': longitude.toString()
    };
  }
}