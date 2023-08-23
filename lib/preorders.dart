import 'package:json_annotation/json_annotation.dart';

part 'preorders.g.dart';

@JsonSerializable()
class OrderDate extends Object {
   String create;
   String start;

  OrderDate(
    this.start,
    this.create
  );

  factory OrderDate.fromJson(Map<String, dynamic> json) => _$OrderDateFromJson(json);
}

@JsonSerializable()
class Coordinate extends Object {
  @JsonKey(defaultValue: 0.0)
  double lat;
  @JsonKey(defaultValue: 0.0)
  double lon;

  Coordinate(
      this.lat,
      this.lon
      );

  factory Coordinate.fromJson(Map<String, dynamic> json) => _$CoordinateFromJson(json);
}

@JsonSerializable()
class Address extends Object {
  String from;
  String to;
  Coordinate from_cord;
  Coordinate to_cord;

  Address(
      this.from,
      this.to,
      this.from_cord,
      this.to_cord
      );

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}

@JsonSerializable()
class Preorder extends Object {
  int order_id;
  int accepted;

  @JsonKey(defaultValue: "")
  String car_class;

  double price;
  Address addresses;
  OrderDate time;

  Preorder(
      this.order_id,
      this.accepted,
      this.car_class,
      this.price,
      this.addresses,
      this.time
      );

  factory Preorder.fromJson(Map<String, dynamic> json) => _$PreorderFromJson(json);
}

@JsonSerializable()
class PreordersList extends Object {
  List<Preorder> list = [];

  PreordersList(
      this.list
      );

  factory PreordersList.fromJson(Map<String, dynamic> json) => _$PreordersListFromJson(json);
}