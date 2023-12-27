import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'consts.dart';
import "dlg.dart";
import 'model/tr.dart';
import 'order_detail.dart';
import 'utils.dart';
import 'web/web_history_detail.dart';

class HistoryOrder extends StatefulWidget {

  int orderId;

  HistoryOrder({required this.orderId});

  @override
  State createState() {
    return HistoryOrderState();
  }
}

class HistoryOrderState extends State<HistoryOrder> {

  late YandexMapController _mapController;
  final List<MapObject> _mapObjects = [];
  final MapObjectId _polylineId = MapObjectId('polyline');
  final MapObjectId _pm1 = MapObjectId("pm1");
  final MapObjectId _pm2 = MapObjectId("pm2");

  OrderDetail _orderDetail = OrderDetail(0, "", "", 0.0, "",
      OrderDateTime("", "", "", ""), [],
      OrderDriver("", "", ""),
      OrderCar("", "", "", ""));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea (
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            children: [
              Divider(color: Colors.transparent, height: 5,),
              Row(
                children: [
                  IconButton(icon: Image.asset("images/back.png", height: 20, width: 20,), onPressed: (){Navigator.pop(context);}),
                  Text("Назад"),
                ]
              ),
              Container(
                  height: 5,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xffcccccc), Colors.white]
                      )
                  )
              ),

              /****MAP
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width - 10,
                  //height: MediaQuery.of(context).size.width - 10,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: YandexMap(onMapCreated: _mapReady, mapObjects: _mapObjects,)
                )
              ),
                  MAP*****/
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Image.asset("images/calendar.png", width: 20, height: 20,),
                    ),
                    Text(_orderDetail.datetime.end_date),
                    Expanded(
                        child: Container()
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Image.asset("images/clock.png", width: 20, height: 20),
                    ),
                    Text(_orderDetail.datetime.end_time)
                  ],
                )
              ),
              Divider(color: Colors.black26),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Row (
                  children: [
                    Column(
                      children: [
                        Image.asset("images/od_black.png", width: 15, height: 15,),
                        Divider(height: 2, color: Colors.transparent),
                        Image.asset("images/line.png",width: 10, height: 30,),
                        Divider(height: 2, color: Colors.transparent),
                        Image.asset("images/od_red.png", width: 15, height: 15,)
                      ],
                    ),
                    Expanded(child: Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_orderDetail.from, style: Consts.textStyle11),
                          Divider(color: Colors.black26, height: 30,),
                          Text(_orderDetail.to,  style: Consts.textStyle11)
                        ]
                      ))
                    ),
                  ],
                )
              ),
              Divider(color: Colors.black26,),
              Container(
                margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                child: Row(
                  children: [
                    Text("Метод оплаты"),
                    Expanded(child: Container()),
                    Text(paymenthod(_orderDetail.payment_type), style: Consts.textStyle6,),
                  ],
                )
              ),
              Divider(color: Colors.black26),
              Container(
                  margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                  child: Row(
                    children: [
                      Text(tr(trCost).toUpperCase()),
                      Expanded(child: Container()),
                      Text(_orderDetail.price.toString(), style: Consts.textStyle6,)
                    ],
                  )
              ),
              Divider(color: Colors.black26,),
              Container(
                  margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                  child: Row(
                    children: [
                      Container(
                        child: Image.asset("images/driver.png", width: 40, height: 40)
                      ), Column(
                          children: [
                            Text(_orderDetail.driver.getSurname()),
                            Text(_orderDetail.driver.name)
                          ],

                      ),
                      Expanded(child: Container()),
                    ],
                  )
              ),
              Divider(color: Colors.black26,),
              Container(
                  margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tr(trCarModel)),
                          Align(alignment: Alignment.centerLeft, child: Text(_orderDetail.car.mark + " " + _orderDetail.car.model, style: Consts.textStyle12))
                        ]
                      ),
                      Expanded(child: Container()),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(tr(trCarNumber)),
                          Text( _orderDetail.car.state_license, style: Consts.textStyle12)
                        ],
                      )
                    ],
                  )
              ),
              Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Row (
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr(trCarColor)),
                        Text(_orderDetail.car.color, style: Consts.textStyle12)
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(tr(trCarClass)),
                        Text(_orderDetail.car.carClass()!, style: Consts.textStyle12)
                      ],
                    )
                  ],
                )
              )
            ],
          )
        )
      ),
    );
  }

  @override
  void initState() {
    WebHistoryDetail webHistoryDetail = WebHistoryDetail(widget.orderId);
    webHistoryDetail.request((mp){
      setState((){
        _orderDetail = OrderDetail.fromJson(mp);
        //_drawRoute();
      });
    }, (c, s){
      Dlg.show(s);
      Navigator.pop(context);
    });
  }

  void _mapReady(YandexMapController ymc) {
    _mapController = ymc;
  }

  void _drawRoute() {
    _mapObjects.clear();
    PolylineMapObject polyline = PolylineMapObject(mapId: _polylineId, polyline: Polyline(points: _orderDetail.coordinates()));
    _mapObjects.add(polyline);
    Point? p1, p2;
    if ((p1 = _orderDetail.firstPoint()) != null) {
      PlacemarkMapObject pm1 = PlacemarkMapObject(
          mapId: _pm1,
          icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('images/place.png'),
            rotationType: RotationType.rotate
            )),
          opacity: 1,
          point: p1!, );
      _mapObjects.add(pm1);
    }
    if ((p2 = _orderDetail.lastPoint()) != null) {
      PlacemarkMapObject pm2 = PlacemarkMapObject(
        mapId: _pm2,
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('images/circle_bold_black.png'),
            rotationType: RotationType.rotate
        )),
        opacity: 1,
        point: p2!, );
      _mapObjects.add(pm2);
    }
    if (p1 != null && p2 != null) {
      Point p3 = Utils.midPoint(p1.latitude, p1.longitude, p2.latitude, p2.longitude);
      double zoom = 13;
      _mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: p3, zoom: zoom)));
    }
  }

  String paymenthod(String s) {
    if (s.toLowerCase() == 'наличными') {
      return tr(trCash);
    } else if (s.toLowerCase() == 'безнал и кредитка') {
      return tr(trPayByCompany);
    }
    return 'WOW!';
  }
}