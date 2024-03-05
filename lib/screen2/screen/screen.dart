import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_geometry.dart';
import 'package:wagon_client/screen2/model/ac_type.dart';
import 'package:wagon_client/screen2/model/model.dart';
import 'package:wagon_client/screen2/parts/screen_ac.dart';
import 'package:wagon_client/screen2/parts/screen_ac_selected.dart';
import 'package:wagon_client/screen2/parts/screen_address.dart';
import 'package:wagon_client/screen2/parts/screen_address_suggest.dart';
import 'package:wagon_client/screen2/parts/screen_bottom.dart';
import 'package:wagon_client/screen2/parts/screen_payment.dart';
import 'package:wagon_client/screen2/parts/screen_ride_options.dart';
import 'package:wagon_client/screen2/parts/screen_taxi.dart';
import 'package:wagon_client/screens/mainwindow/anim_placemark.dart';
import 'package:wagon_client/screens/payment/screen.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class Screen2 extends StatefulWidget {
  final model = Screen2Model();
  @override
  State<StatefulWidget> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> with WidgetsBindingObserver {

  void parentState() {
    setState(() {

    });
  }

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Container()),
                if (widget.model.appState.acType == 0)
                  ScreenAC(widget.model, parentState),
                if (widget.model.appState.acType > 0)
                  ScreenAcSelected(widget.model, parentState),
                if (widget.model.appState.acType == ACType.act_taxi)
                  StreamBuilder(stream: widget.model.taxiCarsStream.stream , builder: (builder, snapshot) {
                    if (snapshot.data == null) {
                      return Container(child: CircularProgressIndicator(),);
                    }
                    return ScreenTaxi(widget.model, snapshot.data, parentState);
                  }),
                ScreenAddress(widget.model, parentState),
                ScreenRideOptions(widget.model, parentState),
                ScreenBottom(widget.model, parentState),
              ],
            ),
            ScreenAddressSuggest(widget.model, parentState),
            PaymentWidget(widget.model, parentState, true),
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