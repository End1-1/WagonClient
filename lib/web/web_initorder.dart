import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:wagon_client/model/address_model.dart';

import '../consts.dart';
import '../model/address_model.dart';
import 'web_parent.dart';

class WebInitOrder extends WebParent {
  final AddressStruct from;
  int carClass;
  int paymentType;
  int paymentCompany;
  String driverComment;
  List<int> carOptions;
  DateTime orderDateTime;
  String commentFrom;

  WebInitOrder(
      this.from,
      this.carClass,
      this.paymentType,
      this.paymentCompany,
      this.driverComment,
      this.carOptions,
      this.orderDateTime,
      this.commentFrom
      )
  : super("/app/mobile/init_order", HttpMethod.POST);

  @override
  dynamic getHeader() {
    return
      {
        'content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + Consts.getString("bearer")
    };
  }

  @override
  dynamic getBody() {
    Map<String, dynamic> jcar = Map();
    jcar["class"] = carClass;
    List<int> jCarOptions =[];
    for (int i in carOptions) {
      jCarOptions.add(i);
    }
    jcar["options"] = jCarOptions;
    jcar["comments"] = driverComment;
    Map<String, dynamic> jpayment = Map();
    jpayment["type"] = paymentType;
    jpayment["company"] = paymentCompany;
    Map<String, dynamic> jr = Map();
    List<double> jFromCoordinates =[];
    jFromCoordinates.add(from.point!.latitude);
    jFromCoordinates.add(from.point!.longitude);
    jr["from"] = jFromCoordinates;
    List<double> jToCoordinates = [];

    jToCoordinates.add(RouteHandler.routeHandler.directionStruct.to.first.point!.latitude);
    jToCoordinates.add(RouteHandler.routeHandler.directionStruct.to.first.point!.longitude);

    if (RouteHandler.routeHandler.directionStruct.to.isEmpty) {
      jr["to"] = null;
    } else {
      jr["to"] = jToCoordinates;
    }
    jr["to_address"] = RouteHandler.routeHandler.directionStruct.to.first.address;
    jr["from_address"] = from.address;


    orderDateTime = orderDateTime.isBefore(DateTime.now()) ? DateTime.now() : orderDateTime;
    Map<String, dynamic> jtime = Map();
    DateFormat df = DateFormat("yyyy-MM-dd HH:mm");
    jtime["create_time"] = df.format(DateTime.now());
    jtime["time"] = df.format(orderDateTime);

    //jtime["zone"] = "Asia/Yerevan"; //time.timeZoneName;
    jtime["zone"] = "Europe/Moscow"; //time.timeZoneName;

    Map<String, dynamic> jphone = Map();
    jphone["client"] = Consts.getString("phone");
    jphone["passenger"] = "";

    Map<String, dynamic> jmeet = Map();
    jmeet["is_meet"] = false;
    jmeet["place_id"] = "";
    jmeet["place_type"] = "";
    jmeet["number"] = "";
    jmeet["text"] = "";

    Map<String, dynamic> jo = Map();
    jo["route"] = jr;
    jo["car"] = jcar;
    jo["payment"] = jpayment;
    jo["time"] = jtime;
    jo["phone"] = jphone;
    jo["meet"] = jmeet;
    jo["is_rent"] = false;
    jo["rent_time"] = "";

    Map<String, dynamic> jfaf = Map();
    jfaf["frame"] = null;
    jfaf["house"] = null;
    jfaf["comment"] = commentFrom;
    jfaf["entrance"] = null;
    jfaf["structure"] = null;
    jo["full_address_from"] = jfaf;

    Map<String, dynamic> jfat = Map();
    jfat["frame"] = null;
    jfat["house"] = null;
    jfat["comment"] = null;
    jfat["entrance"] = null;
    jfat["structure"] = null;
    jo["full_address_to"] = jfat;

    if (RouteHandler.routeHandler.directionStruct.to.length > 1) {
      List<Map<String, dynamic>> ma = [];
      for (int i = 1; i < RouteHandler.routeHandler.directionStruct.to.length; i++) {
        final as = RouteHandler.routeHandler.directionStruct.to[i];
        Map<String, dynamic> a = {};
        a['house'] = null;
        a['frame'] = null;
        a['structure'] = null;
        a['entrance'] = null;
        a['comment'] =  null;
        a['wait_minute'] = 0;
        a['displayFrom'] = as.title;
        a['address'] = as.address;
        a['coordinates'] = {'lat': as.point!.latitude, 'lut': as.point!.longitude};
        ma.add(a);
      }
      jo["multi_addresses"] = ma;
    }

    String s = jsonEncode(jo);
    print(s);
    return utf8.encode(jsonEncode(jo));
  }

}