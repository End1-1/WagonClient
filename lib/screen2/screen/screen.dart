import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wagon_client/screen2/model/model.dart';
import 'package:wagon_client/screens/mainwindow/anim_placemark.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class Screen2 extends StatefulWidget {
  final model = Screen2Model();
  @override
  State<StatefulWidget> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            YandexMap(
              rotateGesturesEnabled: false,
              onMapCreated: widget.model.mapController.mapReady,
              onCameraPositionChanged: widget.model.mapController.cameraPosition,
              mapObjects: widget.model.mapController.mapObjects,
            ),
            Visibility(
                visible: widget.model.appState.addressFrom.text.isEmpty ||
                    widget.model.appState.addressTo.text.isEmpty,
                child: Align(
                    alignment: Alignment.center,
                    child: AnimPlaceMark(false))),
          ],
        )
      ),
    );
  }

  @override
  void dispose() {
    widget.model.socket.closeSocket();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        widget.model.socket.authSocket();
        widget.model.appState.getState();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        widget.model.socket.closeSocket();
        break;
    }
  }
}