import 'package:json_annotation/json_annotation.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'order_detail.g.dart';

@JsonSerializable()
class OrderCar extends Object {
  String mark;
  String model;
  String color;
  String? car_class;
  String state_license;

  OrderCar(this.mark, this.model, this.color, this.state_license);

  String? carClass() {
    return car_class == null ? "" : car_class;
  }

  factory OrderCar.fromJson(Map<String, dynamic> json) => _$OrderCarFromJson(json);
}

@JsonSerializable()
class OrderDriver extends Object {
  String name;
  String surname;
  String phone;

  OrderDriver(this.name, this.surname, this.phone);
  String fullName() {
    String fullname = surname + " " + name;
    return fullname;
  }

  String getSurname() {
    return surname ;
  }

  factory OrderDriver.fromJson(Map<String, dynamic> json) => _$OrderDriverFromJson(json);
}

@JsonSerializable()
class TPoint extends Object {
  double lat;
  double lut;

  TPoint(this.lat, this.lut);

  factory TPoint.fromJson(Map<String, dynamic> json) => _$TPointFromJson(json);
}

@JsonSerializable()
class OrderDateTime extends Object{
  String start_time;
  String end_time;
  String start_date;
  String end_date;

  OrderDateTime(this.start_date, this.end_date, this.start_time, this.end_time);

  factory OrderDateTime.fromJson(Map<String, dynamic> json) => _$OrderDateTimeFromJson(json);
}

@JsonSerializable()
class OrderDetail extends Object {
  int order_id;
  String from;
  String to;
  double price;
  String payment_type;
  OrderDateTime datetime;
  List<TPoint> trajectory;
  OrderDriver driver;
  OrderCar car;

  OrderDetail(
      this.order_id,
      this.from,
      this.to,
      this.price,
      this.payment_type,
      this.datetime,
      this.trajectory,
      this.driver,
      this.car
      );

  Point? firstPoint() {
    if (trajectory.length > 0) {
      return Point(latitude: trajectory[0].lat, longitude: trajectory[0].lut);
    }
    return null;
  }

  Point? lastPoint() {
    if (trajectory.length > 1) {
      int index = trajectory.length - 1;
      return Point(latitude: trajectory[index].lat, longitude: trajectory[index].lut);
    }
    return null;
  }

  List<Point> coordinates() {
    List<Point> points = [];
    for (int i = 0; i < trajectory.length; i++) {
      points.add(Point(latitude: trajectory[i].lat, longitude: trajectory[i].lut));
    }
    return points;
  }

  factory OrderDetail.fromJson(Map<String, dynamic> json) => _$OrderDetailFromJson(json);

}