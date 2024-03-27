import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class Consts {
  static RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  static doubleToString(double d) {
    return d.toString().replaceAll(regex, '');
  }

  static final navigatorKey = GlobalKey<NavigatorState>();

  static double sizeofPaymentWidget = 0.8;
  static double defaultSizeofPaymentWidget = 0.8;

  static const Color colorOrange = Color(0xfff2a649);
  static const Color colorRed =Color(0xffBF2A61);
  //static const Color colorWagonRed = Color(0xff)
  static const Color colorGreen = Color(0xff6ea868);
  static final Color colorBlue = Color(0xff3547b1);
  static final Color colorWhite = Color(0xffffffff);
  static final Color colorWhite2 = Color(0x88ffffff);
  static final Color colorBlack = Color(0xff000000);
  static final Color colorFiolet = Color(0xff29008b);
  static final Color colorGray = Color(0xffB3B3B3);
  static final Color colorButtonGray = Color(0xff777777);
  static final Color colorTaxiBlue = Color(0xff001b95);
  static final TextStyle textStyle1 = TextStyle(fontSize: 30, color: colorOrange);
  static final TextStyle textStyle2 = TextStyle(fontSize: 15, color: colorOrange);
  static final TextStyle textStyle22 = TextStyle(fontSize: 15, color: colorOrange, fontWeight: FontWeight.w700);
  static final TextStyle textStyle3 = TextStyle(fontSize: 15, color: colorWhite);
  static final TextStyle textStyle4 = TextStyle(fontSize: 30, color: colorFiolet, fontWeight: FontWeight.w700);
  static final TextStyle textStyle5 = TextStyle(fontSize: 15, color: colorGray, fontWeight: FontWeight.w700);
  static final TextStyle textStyle6 = TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w400);
  static final TextStyle textStyle7 = TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w300);
  static final TextStyle textStyle8 = TextStyle(fontSize: 20, color: colorFiolet, fontWeight: FontWeight.w700);
  static final TextStyle textStyleMenu = TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w300);
  static final TextStyle textStylePhoneHeader = TextStyle(fontSize: 18, color: Colors.black38, fontWeight: FontWeight.w600);
  static final TextStyle textStyle9 = TextStyle(fontSize: 20, color: colorWhite, fontWeight: FontWeight.w700);
  static final TextStyle textStyle10 = TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.w300);
  static final TextStyle textStyle11 = TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w300);
  static final TextStyle textStyle12 = TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700);
  static final TextStyle textStyleButton = TextStyle(fontSize: 20, color: Colors.black54);
  static final UnderlineInputBorder underlineInputBorder1 = UnderlineInputBorder(borderSide: BorderSide(color: Consts.colorOrange, width: 3.0));
  static final UnderlineInputBorder underlineInputBorder2 = UnderlineInputBorder(borderSide: BorderSide(color: Consts.colorBlack, width: 1.0));
  static final BoxDecoration boxDecoration = BoxDecoration(color: Colors.white,border: Border.all(color: Consts.colorGray) ,borderRadius: BorderRadius.all(Radius.circular(5)));

  static List<String> hosts = [
    "wagon.am",
    "192.168.0.25",
    "192.168.0.5",
  ];


  static String host () {
    String r = getString("host");
    if (r.isEmpty) {
      r = hosts.elementAt(0);
    }
    return r;
  }

  static final car_class_images = <int, Map<int, Image> > {

  };

  static final String webHost = "https://" + host();
  static String yandexAPIkey = "06495363-2976-4cbb-a0b7-f09387554b9d";
  static String yandexGeocodeKey = "5d1fc909-59a6-43a1-b38f-d712285a68ba";
  static String app_version = "Not defined";

  static final DateFormat dateFormat = DateFormat("E, MMM, d");
  static final DateFormat timeFormat = DateFormat("HH:mm");

  static Point userPosition() {
    return Point(latitude: getDouble("last_lat"), longitude: getDouble("last_lon"));
  }
  
  static late SharedPreferences _prefs;
  static setString(String key, String value) {
    _prefs.setString(key, value);
  }

  static String getString(String key)  {
    String? s = _prefs.getString(key);
    return s ?? "";
  }

  static void setInt(String key, int value) {
    _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }
  static void setDouble(String key, double value) {
    _prefs.setDouble(key, value);
  }
  static double getDouble(String key) {
    return _prefs.getDouble(key) ?? 0;
  }

  static bool getBoolean(String key) {
    return _prefs.getInt(key) != 0;
  }

  static void setBoolean(String key, bool value) {
    _prefs.setInt(key, value ? 1 : 0);
  }

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    app_version = version + "." + buildNumber;
  }

  static String dateToStr(DateTime dt) {
    return dateFormat.format(dt);
  }

  static String timeToStr(DateTime dt) {
    return timeFormat.format(dt);
  }

  static String channelName() {
    return sprintf("private-client-api-base.%d.%s", [Consts.getInt("client_id"),  Consts.getString("phone").replaceAll("+", "")]);
  }

  static String socketId() {
    final _random = new Random();
    int min = 10000000, max = 99999999;
    int  n1 = min + _random.nextInt(max - min);
    min = 100000000;
    max = 999999999;
    int  n2 = min + _random.nextInt(max - min);
    return sprintf("%d.%d", [n1, n2]);
  }
}
