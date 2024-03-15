import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wagon_client/screen2/model/ac_type.dart';
import 'package:wagon_client/screen2/model/app_state.dart';
import 'package:wagon_client/screen2/model/model.dart';
import 'package:wagon_client/screen2/parts/cancel_order_button.dart';
import 'package:wagon_client/screen2/parts/screen_ac.dart';
import 'package:wagon_client/screen2/parts/screen_ac_selected.dart';
import 'package:wagon_client/screen2/parts/screen_address.dart';
import 'package:wagon_client/screen2/parts/screen_address_suggest.dart';
import 'package:wagon_client/screen2/parts/screen_bottom.dart';
import 'package:wagon_client/screen2/parts/screen_ride_options.dart';
import 'package:wagon_client/screen2/parts/screen_search_onmap.dart';
import 'package:wagon_client/screen2/parts/screen_status4.dart';
import 'package:wagon_client/screen2/parts/screen_status7.dart';
import 'package:wagon_client/screen2/parts/screen_taxi.dart';
import 'package:wagon_client/screens/mainwindow/anim_placemark.dart';
import 'package:wagon_client/screens/payment/screen.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class Screen2 extends StatefulWidget {
  final model = Screen2Model();

  @override
  State<StatefulWidget> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController _backgrounController;
  late Animation<Color?> background;
  Animation<double?>? langPos;

  late StreamSubscription<dynamic> events;

  void parentState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _backgrounController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    background = TweenSequence<Color?>(
      [
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            //begin: Colors.transparent,
            begin: Colors.black12,
            //begin: Colors.yellow,
            end: Colors.black54,
          ),
        ),
      ],
    ).animate(_backgrounController);

    events = widget.model.socket.eventBroadcast.stream.listen((event) {
      print(event);
      if (event['event'] == 'DriverOnWayOrderEvent' ||
          event['event'] == 'DriverInPlace' ||
          event['event'] == 'OrderStarted' ||
          event['event'] == 'ClientOrderEndData' ||
          event['event'] == 'DriverOnAcceptOrderEvent' ||
          event['event'] == 'AdminOrderCancel') {
        widget.model.appState.getState(parentState);
      }
    });

    widget.model.socket.eventBroadcast.onListen = () {
      print('Active');
    };
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.appState.appState == AppState.asNone) {
      widget.model.appState.getState(parentState);
    }
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      // ),
      body: SafeArea(
          child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          YandexMap(
            rotateGesturesEnabled: false,
            onMapCreated: widget.model.mapController.mapReady,
            onCameraPositionChanged: widget.model.mapController.cameraPosition,
            mapObjects: widget.model.mapController.mapObjects,
          ),
          if (widget.model.appState.appState == AppState.asSearchOnMapFrom ||
              widget.model.appState.appState == AppState.asSearchOnMapTo) ...[
            ScreenOnMap(widget.model, parentState),
            Align(
                alignment: Alignment.center, child: AnimPlaceMark(widget.model))
          ],
          if (widget.model.appState.appState == AppState.asNone) ...[
            _dimWidget(context, null)
          ],
          if (widget.model.appState.appState == AppState.asIdle) ...[
            Visibility(
                visible: widget.model.appState.addressFrom.text.isEmpty ||
                    widget.model.appState.addressTo.text.isEmpty,
                child: Align(
                    alignment: Alignment.center, child: StreamBuilder(stream: widget.model.markerStream.stream, builder: (builder, snapshot) {return AnimPlaceMark(widget.model);}))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Container()),
                if (widget.model.appState.acType == 0)
                  ScreenAC(widget.model, parentState),
                if (widget.model.appState.acType > 0)
                  ScreenAcSelected(widget.model, parentState),
                if (widget.model.appState.acType == ACType.act_taxi)
                  StreamBuilder(
                      stream: widget.model.taxiCarsStream.stream,
                      builder: (builder, snapshot) {
                        if (snapshot.data == null) {
                          return Container();
                        }
                        return ScreenTaxi(
                            widget.model, snapshot.data, parentState);
                      }),
                ScreenAddress(widget.model, parentState),
                ScreenRideOptions(widget.model, parentState),
                ScreenBottom(widget.model, parentState),
              ],
            ),
            _dimWidget(context, null),
            ScreenAddressSuggest(widget.model, parentState),
            AnimatedPositioned(
                child: PaymentWidget(widget.model, parentState, true),
                top: widget.model.appState.showChangePayment
                    ? 0
                    : MediaQuery.sizeOf(context).height,
                duration: const Duration(milliseconds: 300))
          ],
          if (widget.model.appState.appState == AppState.asSearchTaxi) ...[
            _dimWidget(context, CancelOrderButton(widget.model, parentState))
          ],
          if (widget.model.appState.appState == AppState.asDriverOnWay ||
              widget.model.appState.appState == AppState.asDriverAccept ||
              widget.model.appState.appState == AppState.asOnPlace ||
              widget.model.appState.appState == AppState.asOrderStarted) ...[
            ScreenStatus4(widget.model, parentState)
          ],
          if (widget.model.appState.appState == AppState.asOrderEnd) ...[
            ScreenStatus7(widget.model, parentState)
          ],
        ],
      )),
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
        widget.model.appResumed(parentState);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        widget.model.appPaused();
        break;
    }
  }

  Widget _dimWidget(BuildContext context, Widget? bottom) {
    return Visibility(
        visible: widget.model.appState.dimVisible,
        child: AnimatedBuilder(
          animation: _backgrounController,
          builder: (BuildContext context, Widget? child) {
            return Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              color: background.value,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Container()),
                    Image.asset(
                      'images/login/wp1.png',
                      height: 60,
                    ),
                    Text(widget.model.appState.dimText),
                    Expanded(child: Container()),
                    if (bottom != null)
                      bottom,
                    Container(height: 10,),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
