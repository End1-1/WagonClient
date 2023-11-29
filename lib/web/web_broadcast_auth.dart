import 'dart:convert';

import 'web_parent.dart';

class WebBroadcastAuth extends WebParent {

  String? channelName;
  String? socketID;

  WebBroadcastAuth({this.channelName, this.socketID}) : super("/app/mobile/broadcasting/auth", HttpMethod.POST);

  @override
  getBody() {
    return {
      "channel_name": channelName,
      "socket_id": socketID
    };
  }
}