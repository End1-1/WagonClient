import 'package:json_annotation/json_annotation.dart';
import 'package:wagon_client/preorders.dart';

part 'airports_metro.g.dart';

enum TP {TP_NONE, TP_ADDRESS, TP_METRO, TP_RAILWAY, TP_AIRPORT, TP_FAVORITE}

@JsonSerializable()
class City {
  int city_id;
  String name;

  City(
      this.city_id,
      this.name
      );

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}

@JsonSerializable()
class TransportPoint {
  @JsonKey(ignore: true)
  TP? tp;

  int? airport_id;
  int? metro_id;
  int? railway_id;
  String? name;
  String? terminal;
  String? input;
  Coordinate cord;
  String? address;

  @JsonKey(ignore: true)
  String? short_address;

  TransportPoint(
      this.airport_id,
      this.metro_id,
      this.railway_id,
      this.name,
      this.terminal,
      this.input,
      this.cord,
      this.address
      ) {
    if (name == null) {
      name = "No name";
    }
    if (address == null) {
      address = "No address";
    }
    if (airport_id == null) {
      airport_id = 0;
    }
    if (metro_id == null) {
      metro_id = 0;
    }
    if (railway_id == null) {
      railway_id = 0;
    }
    if (airport_id! > 0) {
      tp = TP.TP_AIRPORT;
    }
    if (metro_id! > 0) {
      tp = TP.TP_METRO;
    }
    if (railway_id! > 0) {
      tp = TP.TP_RAILWAY;
    }
    if (tp == null) {
      tp = TP.TP_FAVORITE;
    }
  }

  factory TransportPoint.fromJson(Map<String, dynamic> json) => _$TransportPointFromJson(json);
}

@JsonSerializable()
class TransportPoints {
  @JsonKey(ignore: true)
  List<TransportPoint> favorites = [];

  List<TransportPoint> airports = [];
  List<TransportPoint> metros = [];
  List<TransportPoint> railways = [];

  TransportPoints(
      this.airports,
      this.metros,
      this.railways
      ) {
    favorites = [];
  }

  factory TransportPoints.fromJson(Map<String, dynamic> json) => _$TransportPointsFromJson(json);
}