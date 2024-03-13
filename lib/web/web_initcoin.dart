import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:wagon_client/cars.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/model/address_model.dart';

import 'web_parent.dart';

class WebInitCoin extends WebParent {

  final AddressStruct from;
  final List<AddressStruct> to;

  WebInitCoin(
      this.from,
      this.to,
      this.carClass,
      this.paymentType,
      this.paymentCompany,
      this.driverComment,
      this.carOptions,
      this.isRent,
      this.rentTime
      )
    : super("/app/mobile/init_coin", HttpMethod.POST);

  bool isRent;
  int rentTime;
  int carClass;
  int paymentType;
  int paymentCompany;
  String driverComment;
  List<int> carOptions;
  static bool _isbusy = false;

  @override
  Future<void> request(Function done, Function? fail) async {
    if (_isbusy) {
      if (fail != null) {
        fail();
      }
      return;
    }
    _isbusy = true;

    print(utf8.decode(getBody()));
    super.request((mp) {
      Map<String, dynamic> mc = Map();
      mc["data"] = Map<String, dynamic>();
      mc["data"]["car_classes"] = mp["data"];
      CarClasses cc = CarClasses.fromJson(mc["data"]);
      done(cc);
    }, (c, s) {
      if (fail != null) {
        fail(c, s);
      }
    });

    _isbusy = false;
  }

  @override
  dynamic getBody() {
    Map<String, dynamic> jcar = Map();
    jcar["class"] = carClass;
    List<int> jCarOptions = [];
    for (int i in carOptions) {
      jCarOptions.add(i);
    }
    jcar["options"] = jCarOptions;
    jcar["comments"] = driverComment;
    Map<String, dynamic> jpayment = Map();
    jpayment["type"] = paymentType;
    jpayment["company"] = paymentCompany;

    Map<String, dynamic> jr = Map();
    List<double> jFromCoordinates = [];
    jFromCoordinates.add(from.point!.latitude);
    jFromCoordinates.add(from.point!.longitude);
    jr["from"] = jFromCoordinates;
    List<double> jToCoordinates = [];
    if (to.isNotEmpty) {
      jToCoordinates.add(to.first.point!.latitude);
      jToCoordinates.add(to.first.point!.longitude);
    }
    jr["from_address"] = from.address;
    jr["to"] = jToCoordinates;
    jr["to_address"] = to.isEmpty ? "" : to.first.address;

    if (to.length > 1) {
      List<Map<String, dynamic>> ma = [];
      List<List<double>> mc = [];
      for (int i = 0; i < to.length; i++) {
        final as = to[i];
        Map<String, dynamic> a = {};
        a['wait_minut'] = 0;
        a['displayFrom'] = as.title;
        a['address'] = as.address;
        a['coordinates'] = [as.point!.latitude, as.point!.longitude];
        ma.add(a);
        final c = <double>[as.point!.latitude, as.point!.longitude];
        mc.add(c);
      }
      jr["multiAddresses"] = ma;
      mc.removeAt(0);
      jr["multi_cords"] = mc;
    }

    DateTime time = DateTime.now();
    Map<String, dynamic> jtime = Map();
    DateFormat df = DateFormat("yyyy-MM-dd  HH:mm:ss");
    jtime["create_time"] = df.format(time);
    jtime["time"] = df.format(time);

    jtime["zone"] = "Asia/Yerevan"; //time.timeZoneName;

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

    jo["is_rent"] = isRent;
    jo["rent_time"] = rentTime;

    String s = jsonEncode(jo);
    print(s);
    return utf8.encode(jsonEncode(jo));
  }

  @override
  dynamic getHeader() {
    return {
      'content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + Consts.getString("bearer")
    };
  }
}
