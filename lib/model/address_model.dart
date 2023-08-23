import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:wagon_client/consts.dart';

part 'address_model.freezed.dart';

@freezed
class AddressStruct with _$AddressStruct {
  const factory AddressStruct({required String address, required String title, required Point? point}) = _AddressStruct;
}

class DirectionStruct {
  AddressStruct from = AddressStruct(address: '', title: '', point: null);
  List<AddressStruct> to = [];
}

class RouteHandler {
  DirectionStruct directionStruct = DirectionStruct();
  DirectionStruct? tempDirectionStruct;
  late Point lastPoint;

  RouteHandler() {
      lastPoint = Point(latitude: Consts.getDouble('last_point_lat'), longitude: Consts.getDouble('last_point_lon'));
  }

  static RouteHandler routeHandler = RouteHandler();

  String addressFrom() {
    return directionStruct.from.address;
  }

  bool multiDestination() {
    return directionStruct.to.length > 1;
  }

  List<String> addressTo() {
    if (directionStruct.to.isEmpty) {
      return [''];
    }
    if (multiDestination()) {
      return [
        for (final e in directionStruct.to)...[
          e.title
        ]
      ];
    }
    return [directionStruct.to.first.address];
  }

  fromPoint() {
    return directionStruct.from.point;
  }

  void setPointFrom(Position event) {
    directionStruct.from = directionStruct.from.copyWith(point: Point(latitude: event.latitude ?? 0, longitude: event.longitude ?? 0));
  }

  bool sourceDefined() {
    return directionStruct.from.point != null;
  }

  bool destinationDefined() {
    return directionStruct.to.isNotEmpty;
  }

  bool routeNotDefined() {
    return !sourceDefined() || !destinationDefined();
  }

  void makeCopyOfRoute() {
    tempDirectionStruct = DirectionStruct();
    tempDirectionStruct!.from = AddressStruct(address: directionStruct.from.address, title: directionStruct.from.title, point: directionStruct.from.point);
  }
}


// model.addresses["subtitle_from"] = "";
// model.addresses["title_from"] = "";
// model.addresses["searchtext_from"] = "";
// model.addresses["lat_from"] = 0.0;
// model.addresses["lon_from"] = 0.0;
// model.addresses["subtitle_to"] = "";
// model.addresses["title_to"] = "";
// model.addresses["searchtext_to"] = "";
// model.addresses["lat_to"] = 0.0;
// model.addresses["lon_to"] = 0.0;