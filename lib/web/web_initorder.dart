import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:wagon_client/model/address_model.dart';

import '../consts.dart';
import 'web_parent.dart';

class WebInitOrder extends WebParent {
  final AddressStruct from;
  final List<AddressStruct> to;
  int carClass;
  int paymentType;
  int paymentCompany;
  String driverComment;
  List<int> carOptions;
  DateTime orderDateTime;
  String commentFrom;
  final String cardId;
  final int using_cashback;
  final double using_cashback_balance;

  WebInitOrder(
      this.from,
      this.to,
      this.carClass,
      this.paymentType,
      this.paymentCompany,
      this.driverComment,
      this.carOptions,
      this.orderDateTime,
      this.commentFrom,
  {
    required this.cardId,
    required this.using_cashback,
    required this.using_cashback_balance
  }
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
    jpayment['card_id'] = cardId;
    Map<String, dynamic> jr = Map();
    List<double> jFromCoordinates =[];
    jFromCoordinates.add(from.point!.latitude);
    jFromCoordinates.add(from.point!.longitude);
    jr["from"] = jFromCoordinates;
    List<double> jToCoordinates = [];

    jr["to_address"] = null;
    if (to.isNotEmpty) {
      jToCoordinates.add(
          to.first.point!.latitude);
      jToCoordinates.add(
          to.first.point!.longitude);
      jr["to_address"] = to.first.address;
    }

    jr["to"] = null;
    if (to.isEmpty) {
    } else {
      jr["to"] = jToCoordinates;
    }
    jr["from_address"] = from.address;

    orderDateTime = orderDateTime.isBefore(DateTime.now()) ? DateTime.now() : orderDateTime;
    Map<String, dynamic> jtime = Map();
    DateFormat df = DateFormat("yyyy-MM-dd HH:mm");
    jtime["create_time"] = df.format(DateTime.now());
    jtime["time"] = df.format(orderDateTime);

    jtime["zone"] = "Asia/Yerevan"; //time.timeZoneName;
    //jtime["zone"] = "Europe/Moscow"; //time.timeZoneName;

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

    if (to.length > 1) {
      List<Map<String, dynamic>> ma = [];
      for (int i = 1; i < to.length; i++) {
        final as = to[i];
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

    jo['using_cashback'] = using_cashback;
    jo['using_cashback_balance'] = using_cashback_balance;

    String s = jsonEncode(jo);
    print(s);
    return utf8.encode(jsonEncode(jo));
  }

}