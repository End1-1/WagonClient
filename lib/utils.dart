import 'dart:math';

import 'package:vector_math/vector_math.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as ya;

class Utils {
  static ya.Point midPoint(double lat1, double lon1, double lat2, double lon2){
    double dLon = radians(lon2 - lon1);

    //convert to radians
    lat1 = radians(lat1);
    lat2 = radians(lat2);
    lon1 = radians(lon1);

    double Bx = cos(lat2) * cos(dLon);
    double By = cos(lat2) * sin(dLon);
    double lat3 = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + Bx) * (cos(lat1) + Bx) + By * By));
    double lon3 = lon1 + atan2(By, cos(lat1) + Bx);

    lat3 = degrees(lat3);
    lon3 = degrees(lon3);

    return ya.Point(latitude: lat3, longitude: lon3);
  }
}