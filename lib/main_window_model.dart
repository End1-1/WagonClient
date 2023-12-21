import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/io_client.dart';
import 'package:wagon_client/resources/resource_car_types.dart';
import 'package:wagon_client/screens/find_address/find_address_screen.dart';
import 'package:wagon_client/screens/payment/card_info.dart';
import 'package:wagon_client/screens/payment/cashback_info.dart';
import 'package:wagon_client/screens/payment/company_info.dart';
import 'package:wagon_client/web/web_initcoin.dart';
import 'package:wagon_client/web/yandex_geocode.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'addressonmap.dart';
import 'cars.dart';
import 'consts.dart';
import 'dlg.dart';
import 'freezed/chat_message.dart';
import 'model/address_model.dart';

const int pageRealState = 0;
const int pageSelectShortAddress = 1;
const int pageSelectCar = 2;
const int pageCarOptions = 3;
const int pageSearchTaxi = 4;
const int pageOrderCancelOption = 5;
const int pageDriverAccept = 6;
const int pageDriverOnWayToClient = 7;
const int pageDriverOnPlace = 8;
const int pageOrderStarted = 9;
const int pageOrderEnd = 10;
const int pageChat = 11;
const int pageMenu = 12;

const state_none = 1;
const state_pending_search = 2;
const state_driver_accept = 3;
const state_driver_onway = 4;
const state_driver_onplace = 5;
const state_driver_orderstarted = 6;
const state_driver_orderend = 7;

class MainWindowModel {
  final commentFrom = TextEditingController();
  final addressFrom = TextEditingController();
  final addressTo = TextEditingController();
  final chatTextController = TextEditingController();
  final feedbackText = TextEditingController();

  final List<MapObject> mapObjects = [];
  YandexMapController? mapController;
  DateTime orderDateTime = DateTime.now();
  Map<String, dynamic> timeline = Map();
  Map<String, dynamic> events = Map();
  bool isMapPressed = false;
  int driverRating = 0;
  int currentPage = 0;
  int currentState = 0;
  var order_id = 0;
  bool loadingData = false;
  bool showWallet = false;
  bool tracking = false;
  bool showOptions = false;
  var dimvisible = false;
  double rideZoom = 16;
  final YandexGeocodeHandler geocode = YandexGeocodeHandler();
  YandexMap? yandexMap;
  bool init = false;
  bool isRent = false;
  String rentTime = "";
  List<int> rentTimes = [];
  var paymentTypeId = 1;
  var paymentCompanyId = 0;
  var paymentCardId = '';
  int using_cashback = 0;
  double using_cashback_balance = 0.0;
  final List<CompanyInfo> companies = [];
  final List<CardInfo> paymentCards = [];
  var cashbackInfo =
      CashbackInfo(client_id: 0, balance: '0', client_wallet_id: 0);

  int unreadChatMessagesCount = 0;

  int currentCar = 0;
  List<int> selectedCarOptions = [];

  final List<MapObjectId> routePolylineId = [
    MapObjectId("_routePolylineId1"),
    MapObjectId("_routePolylineId2"),
    MapObjectId("_routePolylineId3"),
    MapObjectId("_routePolylineId4")
  ];
  final MapObjectId carId = MapObjectId("_carId");
  final List<MapObjectId> pointBId = [
    MapObjectId("_pointB1"),
    MapObjectId("_pointB2"),
    MapObjectId("_pointB3"),
    MapObjectId("_pointB4"),
    MapObjectId("_pointB5"),
    MapObjectId("_pointB6"),
    MapObjectId("_pointB7"),
    MapObjectId("_pointB8"),
    MapObjectId("_pointB9"),
    MapObjectId("_pointB10"),
    MapObjectId("_pointB11"),
    MapObjectId("_pointB12")
  ];
  final MapObjectId myPlaceId = MapObjectId("_myPlace");

  bool showSingleAddress = false;
  bool showMultiAddress = false;

  void parseInitOpenData(dynamic mp) {
    ResourceCarTypes.res.clear();
    ResourceCarTypes.res
        .add(CarTypeStruct('images/car.png', 'Taxi', selected: true));

    //DELETE FROM HEAR
    ResourceCarTypes.res
        .add(CarTypeStruct('images/car.png', 'Տաքսի', selected: true));
    ResourceCarTypes.res
        .add(CarTypeStruct('images/car.png', 'Շարժական\r\nվուլկանացում', selected: true));
    ResourceCarTypes.res
        .add(CarTypeStruct('images/car.png', 'Ավտո\r\nտեխսպասարկում', selected: true));
    ResourceCarTypes.res
        .add(CarTypeStruct('images/car.png', 'Սթափ\r\nվարորդ', selected: true));
    ResourceCarTypes.res
        .add(CarTypeStruct('images/car.png', 'Կայֆարիկ\r\nվարորդ', selected: true));
    ResourceCarTypes.res
        .add(CarTypeStruct('images/car.png', 'Ավտոաշտարակ', selected: true));

    var first = true;
    for (final e in mp['data']['car_classes']) {
      ResourceCarTypes.res.first!.types.add(CarSubtypeStruct(
          e['class_id'],
          'images/car2.png',
          e['image'],
          e['name'],
          'No comment for now',
          double.tryParse(e['min_price'].toString()) ?? 0));

      first = false;
    }

    companies.clear();
    for (final e in mp['data']['companies']) {
      CompanyInfo ci = CompanyInfo.fromJson(e);
      companies.add(ci);
    }
    //TODO GET CAR CLASSES FROM HERE
    //model.setCarClasses(CarClasses.fromJson(mp['data']));
    rentTimes.clear();
    for (int rt in mp["data"]["rent_times"]) {
      rentTimes.add(rt);
    }

    paymentCards.clear();
    for (final e in mp['data']['payment_cards']) {
      if (e['payment_type_id'] == 1) {
        if (e['selected']) {
          paymentTypeId = 1;
        }
      } else if (e['payment_type_id'] == 3) {
        for (final ee in e['cards']) {
          if (e['selected']) {
            paymentTypeId = 3;
            paymentCardId = ee['id'];
          }
          CardInfo ci = CardInfo.fromJson(ee);
          paymentCards.add(ci);
        }
      }
    }
    cashbackInfo = CashbackInfo.fromJson(mp['data']['wallet']);
  }

  Future<void> enableTrackingPlace() async {
    if (tracking) {
      return;
    }
    tracking = true;
    // if (myPlace != null) {
    //   mapObjects.remove(myPlace);
    // }
    // myPlace = PlacemarkMapObject(
    //     mapId: myPlaceId,
    //     point: Point(latitude: 0, longitude: 0),
    //     icon: PlacemarkIcon.single(PlacemarkIconStyle(
    //         image: BitmapDescriptor.fromAssetImage('images/placemark.png'),
    //         rotationType: RotationType.rotate)),
    //     opacity: 1);
    // mapObjects.add(myPlace!);
  }

  Future<void> centerMeOnMap() async {
    Position p = await Geolocator.getCurrentPosition();
    mapController!.moveCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
            target: Point(latitude: p.latitude, longitude: p.longitude),
            zoom: rideZoom)),
        animation: MapAnimation(duration: 1));
  }

  void setAddressFromTo(AddressStruct as) {
    RouteHandler.routeHandler.directionStruct.from = as;
    switch (currentPage) {
      case pageSelectShortAddress:
        addressFrom.text = RouteHandler.routeHandler.addressFrom();
        break;
    }
  }

  void initCoin(BuildContext context, Function? f, Function? fail) {
    if (!init) {
      return;
    }
    if (Consts.getString("bearer").isEmpty) {
      Dlg.show(context, "Empty bearer");
      return;
    }
    //TODO THERE IS PREIVIOUSLY WAS USED CAR CLASS
    if (RouteHandler.routeHandler.sourceDefined()) {
      WebInitCoin initCoin = WebInitCoin(
          RouteHandler.routeHandler.directionStruct.from,
          currentCar,
          paymentTypeId,
          paymentTypeId == 2 ? getSelectedCompanyInfo().id : 0,
          Consts.getString("driverComment"),
          selectedCarOptions,
          isRent,
          int.tryParse(rentTime) == null ? 0 : int.parse(rentTime));
      initCoin.request((CarClasses cc) {
        if (f != null) {
          f();
        }
      }, (c, s) {
        Dlg.show(context, s);
        if (fail != null) {
          fail();
        }
      });
    } else {
      //Dlg.show("Точка отправления не определена");
      if (fail != null) {
        fail();
      }
    }
  }

  CompanyInfo getSelectedCompanyInfo() {
    for (final e in companies) {
      if (e.checked ?? false) {
        return e;
      }
    }
    return CompanyInfo(id: 0, name: '', car_classes: [], checked: false);
  }

  String currentStateName() {
    String text = "О БОЖЕ!";
    switch (currentState) {
      case state_driver_accept:
        text = "ЗАКАЗ ПРИНЯТ";
        break;
      case state_driver_onway:
        text = events["driver_accept"]["message"].toString();
        break;
      case state_driver_onplace:
        text = "ВАС ОЖИДАЕТ";
        break;
    }
    return text;
  }

  void animateWindow(int newWindow, Function? done) {
    currentPage = newWindow;
    if (done != null) {
      done();
    }
  }

  void searchOnMap(BuildContext context, bool from) async {
    var result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddressOnMap();
    }));
    print(result);
    if (result != null) {
      if (from) {
        RouteHandler.routeHandler.directionStruct.from = result;
      } else {
        if (RouteHandler.routeHandler.directionStruct.to.isEmpty) {
          RouteHandler.routeHandler.directionStruct.to.add(result);
        } else {
          RouteHandler.routeHandler.directionStruct.to.last = result;
        }
      }
    }
    addressFrom.text = RouteHandler.routeHandler.addressFrom();
    addressTo.text = RouteHandler.routeHandler.addressTo().join(", ");
  }

  Future<void> selectRoute(BuildContext context, bool from) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FindAddressScreen(focusFrom: from)));
    if (result != null) {
      if (from) {
        mapController!.moveCamera(
            CameraUpdate.newCameraPosition(CameraPosition(
                target: RouteHandler.routeHandler.directionStruct.from.point!,
                zoom: rideZoom)),
            animation: MapAnimation(duration: 1));
      }
      await paintRoute();
      addressFrom.text = RouteHandler.routeHandler.addressFrom();
      addressTo.text = RouteHandler.routeHandler.addressTo().join(", ");
    }
  }

  Future<void> paintRoute() async {
    await removePolyline(centerMe: false);
    if (RouteHandler.routeHandler.directionStruct.to.isEmpty) {
      return;
    }
    var resultWithSession = YandexDriving.requestRoutes(
        points: [
          RequestPoint(
              point: RouteHandler.routeHandler.directionStruct.from.point!,
              requestPointType: RequestPointType.wayPoint),
          for (int i = 0;
              i < RouteHandler.routeHandler.directionStruct.to.length - 1;
              i++) ...[
            RequestPoint(
                point: RouteHandler.routeHandler.directionStruct.to[i].point!,
                requestPointType: RequestPointType.viaPoint),
          ],
          RequestPoint(
              point: RouteHandler.routeHandler.directionStruct.to.last.point!,
              requestPointType: RequestPointType.wayPoint),
        ],
        drivingOptions: const DrivingOptions(
            initialAzimuth: 0, routesCount: 1, avoidTolls: true));

    if (RouteHandler.routeHandler.sourceDefined() &&
        RouteHandler.routeHandler.destinationDefined()) {
      tracking = false;

      final value = await resultWithSession.result;
      if (value.routes != null) {
        if (value.routes!.isNotEmpty) {
          DrivingRoute r = value.routes!.first;

          //Route
          mapObjects.add(PolylineMapObject(
            mapId: routePolylineId[0],
            polyline: Polyline(points: r.geometry),
            strokeColor: Colors.blue[700]!,
            strokeWidth: 5,
            // <- default value 5.0, this will be a little bold
            outlineColor: Colors.yellow[200]!,
            outlineWidth: 1.0,
          ));

          //Start point
          PlacemarkMapObject point1 = PlacemarkMapObject(
              mapId: MapObjectId('startpoint'),
              direction: 0,
              point: RouteHandler.routeHandler.directionStruct.from.point!,
              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                      'images/circle_bold_black.png'),
                  rotationType: RotationType.rotate)));
          mapObjects.add(point1);

          //Via point
          for (int i = 0;
              i < RouteHandler.routeHandler.directionStruct.to.length - 1;
              i++) {
            PlacemarkMapObject point = PlacemarkMapObject(
                mapId: MapObjectId('via${i}'),
                direction: 0,
                point: RouteHandler.routeHandler.directionStruct.to[i].point!,
                icon: PlacemarkIcon.single(PlacemarkIconStyle(
                    image: BitmapDescriptor.fromAssetImage(
                        'images/circle_bold_red.png'),
                    rotationType: RotationType.rotate)));
            mapObjects.add(point);
          }

          //End point
          PlacemarkMapObject point = PlacemarkMapObject(
              mapId: MapObjectId('endpoint'),
              direction: 0,
              point: RouteHandler.routeHandler.directionStruct.to.last.point!,
              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                      'images/circle_bold_black.png'),
                  rotationType: RotationType.rotate)));
          mapObjects.add(point);
        }
      }
    } else {
      await enableTrackingPlace();
    }
  }

  void drawPoint() {
    //removePolyline(centerMe: false);
    PlacemarkMapObject point = PlacemarkMapObject(
        mapId: pointBId.first,
        point: RouteHandler.routeHandler.lastPoint,
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image:
                BitmapDescriptor.fromAssetImage('images/circle_bold_black.png'),
            rotationType: RotationType.rotate)),
        opacity: 1);
    mapObjects.add(point);
  }

  Future<void> removePolyline({required bool centerMe}) async {
    if (centerMe) {
      await centerMeOnMap();
    }
    while (mapObjects.isNotEmpty) {
      mapObjects.removeLast();
    }
  }

  Future<void> getChatCount() async {
    var client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(client);
    ioClient.get(
        Uri.parse(
            'https://${Consts.host()}/app/mobile/get_unread_messages?clientDriverConversation="true"'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Consts.getString("bearer")}'
        }).then((value) {
      print(value.body.toString());
      Map<String, dynamic> m = jsonDecode(value.body.toString());
      ChatMessageList cml = ChatMessageList.fromJson({'list': m['messages']});
      unreadChatMessagesCount = cml.list.length;
    });
  }

  String getPaymentImage() {
    switch (paymentTypeId) {
      case 1:
        return 'images/wallet.png';
      case 2:
        return 'images/business.png';
      case 3:
        return 'images/card.png';
    }
    return 'images/heart.png';
  }
}
