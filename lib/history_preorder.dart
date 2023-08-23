import 'package:json_annotation/json_annotation.dart';

part 'history_preorder.g.dart';

@JsonSerializable()
class Coord extends Object {
  double? lat;
  double? lut;
  Coord(this.lat, this.lut){
    if (this.lat == null) {
      this.lat = 0;
    }
    if (this.lut == null) {
      this.lut = 0;
    }
  }
  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
}
@JsonSerializable()
class Addresses extends Object {
  String? from;
  Coord? from_cord;
  String? to;
  Coord? to_cord;
  Addresses(this.from,this.from_cord,this.to, this.to_cord);
  factory Addresses.fromJson(Map<String, dynamic> json) => _$AddressesFromJson(json);
}

@JsonSerializable()
class PreorderTime extends Object {
  String? create;
  String? start;
  PreorderTime(this.create,this.start);
  factory PreorderTime.fromJson(Map<String, dynamic> json) => _$PreorderTimeFromJson(json);
}

@JsonSerializable()
class Preorder extends Object {
  int? order_id;
  bool? accepted;
  Addresses? addresses;
  PreorderTime? time;
  Preorder(
      this.order_id,
      this.accepted,
      this.addresses,
      this.time
      ) {
  }
  factory Preorder.fromJson(Map<String, dynamic> json) => _$PreorderFromJson(json);
}

@JsonSerializable()
class PreordersList {
  late List<Preorder> list;
  PreordersList(this.list);
  factory PreordersList.fromJson(Map<String, dynamic> json) => _$PreordersListFromJson(json);
}