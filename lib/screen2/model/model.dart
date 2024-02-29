import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:wagon_client/screen2/model/ac_type.dart';
import 'package:wagon_client/screen2/model/app_websocket.dart';
import 'package:wagon_client/screen2/model/requests.dart';
import 'package:wagon_client/screen2/model/suggestions.dart';

import 'app_state.dart';
import 'map_controller.dart';

class Screen2Model {

  final socket = AppWebSocket();
  final appState = AppState();
  final acTypes = ACType();
  late final Suggestions suggest;
  late final Requests requests;
  late final MapController mapController;
  final suggestStream = StreamController.broadcast();

  Screen2Model() {
    mapController = MapController(this);
    requests = Requests(this);
    suggest = Suggestions(this);
  }

  void setAcType(int t) {
    appState.acType = t;
  }
}