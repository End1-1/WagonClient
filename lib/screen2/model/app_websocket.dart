import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/screen2/model/sound.dart';
import 'package:wagon_client/web/web_broadcast_auth.dart';

class AppWebSocket {
  WebSocket? socket;
  Timer? timerPingPong;
  final eventBroadcast = StreamController.broadcast();

  void authSocket() {
    WebBroadcastAuth webBroadcastAuth = WebBroadcastAuth(
        channelName: Consts.channelName(), socketID: Consts.socketId());
    webBroadcastAuth.request((mp) {
      openSocket();
    }, (c, s) {
      sleep(const Duration(seconds: 2));
      setConnectionState(false);
      authSocket();
    });
  }

  void openSocket() async {
    var connected = false;
    do {
      try {
        HttpClient client =
            HttpClient(); //.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        //HttpClientRequest request = await client.getUrl(Uri.parse("https://10.1.0.2:10002/app/324345"));// (sprintf('10.1.0.2', []), 10002, "/app/324345");
        HttpClientRequest request = await client
            .getUrl(Uri.parse('https://${Consts.host()}:6001/app/324345'));
        request.headers.add('Connection', 'upgrade');
        request.headers.add('Upgrade', 'websocket');
        // insert the correct version here
        request.headers.add('sec-websocket-version', '13');
        request.headers.add('sec-websocket-key', 'bHi/xD6v0LGIhSXi474s8g==');
        HttpClientResponse response = await request.close();
        Socket s = await response.detachSocket();
        socket = WebSocket.fromUpgradedSocket(s, serverSide: false);
        socket!.listen((msg) {
          socketOnMessage(msg);
        }, onError: _onSocketError, onDone: _onSocketDone);
        socket!.handleError((err) {
          print(err);
        });
        setConnectionState(true);
        timerPingPong = Timer.periodic(Duration(milliseconds: 30000), pingpong);
        subscribeToFreeChannel();
        connected = true;
      } catch (e) {
        print(e);
        sleep(const Duration(seconds: 2));
        authSocket();
        return;
      }
    } while (!connected);
  }

  void closeSocket() {
    if (socket != null) {
      socket!.close();
      socket = null;
    }
  }

  void setConnectionState(bool c) {
    if (c) {
    } else {
      if (timerPingPong != null) {
        timerPingPong!.cancel();
        timerPingPong = null;
      }
    }
  }

  void pingpong(Timer t) {
    if (socket == null) {
      t.cancel();
      return;
    }
    String auth = '{"data":{},  "event":"pusher:ping"}';
    socket!.add(auth);
  }

  void subscribeToFreeChannel() {
    String channel = 'free-${Consts.getString("channel_hash")}';
    ;
    Consts.setString(
        'free-channel', 'client-${Consts.getString('channel_hash')}');
    String strToCrypt = Consts.getString('socket_id') + ":" + channel;
    String secret = '34345';
    List<int> messageBytes = utf8.encode(strToCrypt);
    List<int> key = utf8.encode(secret);
    Hmac hmac = new Hmac(sha256, key);
    Digest digest = hmac.convert(messageBytes);
    String auth =
        '{"event":"pusher:subscribe","data":{"auth":"324345:${digest.toString()}","channel":"$channel"}}';
    socket!.add(auth);
  }

  void _onSocketError(a) {
    authSocket();
  }

  void _onSocketDone() {
    authSocket();
  }

  void socketOnMessage(dynamic message) {
    print(message);
    Map<String, dynamic> mp = jsonDecode(message.toString());
    String event = mp["event"];
    if (event == "pusher:connection_established") {
      mp = jsonDecode(mp["data"]);
      Consts.setString("socket_id", mp["socket_id"]);
      String channel = Consts.channelName();
      String strToCrypt = mp["socket_id"] + ":" + channel;
      String secret = "34345";

      List<int> messageBytes = utf8.encode(strToCrypt);
      List<int> key = utf8.encode(secret);
      Hmac hmac = new Hmac(sha256, key);
      Digest digest = hmac.convert(messageBytes);

      print("digest");
      print(digest);

      String auth =
          '{"event":"pusher:subscribe","data":{"auth":"324345:${digest.toString()}","channel":"$channel"}}';
      socket!.add(auth);
    } else if (event == "pusher_internal:subscription_succeeded") {
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\DriverOnAcceptOrderEvent") {
      Map<String, dynamic> md = jsonDecode(mp["data"]);
      eventBroadcast.add({event: 'DriverOnAcceptOrderEvent', 'data': md});
      //??? check and remove na xuy
      Consts.setString("channel_hash", md["hash"]);
      //check and remove na xuy
      //subscribeToFreeChannel();
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\DriverOnWayOrderEvent") {
      eventBroadcast.add(
          {'event': 'DriverOnWayOrderEvent', 'data': jsonDecode(mp["data"])});
    } else if (event == "Src\\Broadcasting\\Broadcast\\Client\\DriverInPlace") {
      eventBroadcast
          .add({'event': 'DriverInPlace', 'data': jsonDecode(mp["data"])});
    } else if (event == "Src\\Broadcasting\\Broadcast\\Client\\OrderStarted") {
      eventBroadcast
          .add({'event': 'OrderStarted', 'data': jsonDecode(mp["data"])});
      //why here is mp??????
      //model.events["driver_order_started"] = mp;
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\ClientOrderEndCreditCardDecline") {
      eventBroadcast.add({
        'event': 'ClientOrderEndCreditCardDecline',
        'data': jsonDecode(mp["data"])
      });
      // setState(() {
      //   model.showWallet = true;
      // });
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\ClientOrderEndData") {
      eventBroadcast
          .add({'event': 'ClientOrderEndData', 'data': jsonDecode(mp["data"])});
      // model.timeline["arrival_time"] = "00:00";
      // model.timeline["travel_time"] = "00:00";
      // model.timeline["past_length"] = 0;
      // model.timeline["total_length"] = 0;
      // model.removePolyline(centerMe: true);
      // model.selectedCarOptions.clear();
      // model.mapObjects.clear();
      // model.animateWindow(pageOrderEnd, () {
      //   Map<String, dynamic> data = jsonDecode(mp["data"]);
      //   data["payload"] = Map<String, dynamic>();
      //   data["payload"]["order"] = Map<String, dynamic>();
      //   data["payload"]["order"]["order_id"] = data["orderId"];
      //   data["payload"]["order"]["price"] = 0;
      //   data["payload"]["order"]["price"] =
      //       double.parse(data["price"].toString());
      //   model.events["driver_order_end"] = data;
      //   setState(() {});
      // });
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\NonDriverEvent") {
      eventBroadcast
          .add({'event': 'NonDriverEvent', 'data': jsonDecode(mp["data"])});
      // resetAddresses();
      // Map<String, dynamic> msg = jsonDecode(mp["data"]);
      // Dlg.show(context, msg["message"].toString());
      // _restoreState();
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\ListenTaxiPositionEvent") {
      eventBroadcast.add(
          {'event': 'ListenTaxiPositionEvent', 'data': jsonDecode(mp["data"])});
      // Map<String, dynamic> data = jsonDecode(mp["data"]);
      // Point p = Point(
      //     latitude: data["driver"]["current_coordinate"]["lat"],
      //     longitude: data["driver"]["current_coordinate"]["lut"]);
      // model.mapController?.moveCamera(
      //     CameraUpdate.newCameraPosition(CameraPosition(
      //         target: p,
      //         zoom: model.rideZoom,
      //         azimuth: double.parse(data["driver"]["azimuth"].toString()))),
      //     animation: MapAnimation(duration: 1));
      // model.mapObjects.clear();
      // setState(() {
      //   model.mapObjects.add(PlacemarkMapObject(
      //       mapId: model.carId,
      //       point: p,
      //       opacity: 1,
      //       icon: PlacemarkIcon.single(PlacemarkIconStyle(
      //           image: BitmapDescriptor.fromAssetImage('images/car.png'),
      //           rotationType: RotationType.rotate))));
      //});
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\BroadwayDriverTalk") {
      eventBroadcast
          .add({'event': 'BroadwayDriverTalk', 'data': jsonDecode(mp["data"])});
      playSoundChat();
      //model.getChatCount().then((value) => setState(() {}));
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\ListenRadiusTaxiEvent") {
      eventBroadcast.add(
          {'event': 'ListenRadiusTaxiEvent', 'data': jsonDecode(mp["data"])});
      // _clearTaxiOnMap();
      // Map<String, dynamic> tl = jsonDecode(mp["data"]);
      // ListenRadiusTaxiEvent te = ListenRadiusTaxiEvent.fromJson(tl);
      // //final orimg = img.decodePng(_carRawImage!);
      // for (CarPos cp in te.taxis) {
      //   PlacemarkMapObject pm = PlacemarkMapObject(
      //       opacity: 1,
      //       mapId:
      //       MapObjectId("taxionmap" + model.mapObjects.length.toString()),
      //       point: Point(
      //           latitude: cp.current_coordinate.getLat(),
      //           longitude: cp.current_coordinate.getLon()),
      //       icon: PlacemarkIcon.single(PlacemarkIconStyle(
      //           image: BitmapDescriptor.fromAssetImage('images/car.png'),
      //           rotationType: RotationType.rotate)),
      //       direction: cp.azimuth.toDouble());
      //   model.mapObjects.add(pm);
      // }
      // setState(() {});
    } else if (event == "Src\\Broadcasting\\Broadcast\\Client\\DriverLate") {
      eventBroadcast.add({'event': 'DriverLate', 'data': jsonDecode(mp["data"])});
      // setState(() {
      //   String chat = Consts.getString("chat");
      //   if (chat.isEmpty) {
      //     chat = "{\"chat\":[]}";
      //   }
      //   DateTime time = DateTime.now();
      //   DateFormat df = DateFormat("HH:mm");
      //
      //   Map<String, dynamic> chatdata = jsonDecode(chat);
      //   Map<String, dynamic> msg = jsonDecode(mp["data"]);
      //   msg = msg["payload"];
      //   Map<String, dynamic> om = Map();
      //   om["messageData"] = msg;
      //   om["messageData"]["sender"] = "driver"; // ng, dynamic>();
      //   om["messageData"]["time"] = df.format(time);
      //   chatdata["chat"].add(om);
      //   Consts.setString("chat", jsonEncode(chatdata));
      //   if (model.currentPage != pageChat) {
      //     _pageBeforeChat = model.currentPage;
      //     model.currentPage = pageChat;
      //   }
      // });
    } else if (event == "Src\\Broadcasting\\Broadcast\\Client\\OrderReset") {
      eventBroadcast.add({'event': 'OrderReset', 'data': jsonDecode(mp["data"])});
      //_restoreState();
    } else if (event ==
        "Src\\Broadcasting\\Broadcast\\Client\\AdminOrderCancel") {
      eventBroadcast
          .add({'event': 'AdminOrderCancel', 'data': jsonDecode(mp["data"])});
      // resetAddresses();
      // Map<String, dynamic> msg = jsonDecode(mp["data"]);
      // Dlg.show(context, msg["message"].toString());
      // _restoreState();
    } else if (event == Consts.getString("free-channel")) {
      print(mp);
      //why? what the fuck? check and remove
      // setState(() {
      //   model.timeline = mp["data"]["msg"];
      // });
    }
  }
}
