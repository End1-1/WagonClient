import 'package:json_annotation/json_annotation.dart';

part 'car.g.dart';

@JsonSerializable()
class CarCoordinate  extends Object{
  double lat;
  double lut;

  CarCoordinate(
      this.lat,
      this.lut
      );

  double getLat() {
    return lat;
  }

  double getLon() {
    return lut;
  }

  factory CarCoordinate.fromJson(Map<String, dynamic> json) => _$CarCoordinateFromJson(json);
}

@JsonSerializable()
class CarPos {
  int driver_id;
  int current_franchise_id;
  CarCoordinate current_coordinate;
  int azimuth;
  String phone;
  String name;
  String surname;
  String photo;

  CarPos (
      this.driver_id,
      this.current_franchise_id,
      this.current_coordinate,
      this.azimuth,
      this.phone,
      this.name,
      this.surname,
      this.photo
      );

  factory CarPos.fromJson(Map<String, dynamic> json) => _$CarPosFromJson(json);
}

@JsonSerializable()
class ListenRadiusTaxiEvent {
  String status;
  List<CarPos> taxis;
  String? a;

  ListenRadiusTaxiEvent(
      this.status,
      this.taxis
      );

  factory ListenRadiusTaxiEvent.fromJson(Map<String, dynamic> json) => _$ListenRadiusTaxiEventFromJson(json);
}
