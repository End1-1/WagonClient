import 'package:wagon_client/screen2/model/app_websocket.dart';
import 'package:wagon_client/screen2/model/requests.dart';

import 'app_state.dart';
import 'map_controller.dart';

class Screen2Model {

  final socket = AppWebSocket();
  final appState = AppState();
  late final Requests requests;
  late final MapController mapController;

  Screen2Model() {
    mapController = MapController(this);
    requests = Requests(this);
  }

  void setAcType(int t) {
    appState.acType = t;
  }
}