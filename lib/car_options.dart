import 'package:json_annotation/json_annotation.dart';

part 'car_options.g.dart';

@JsonSerializable()
class CarOptions extends Object {
  int id;
  String option;
  String price;
  bool selected;

  CarOptions(
      this.id,
      this.option,
      this.price,
      this.selected
      ) {

  }

  factory CarOptions.fromJson(Map<String, dynamic> json) => _$CarOptionsFromJson(json);
}

@JsonSerializable()
class CarOptionsList {
  List<CarOptions> car_options;

  CarOptionsList(this.car_options);

  List<int> selectedOptions() {
    List<int> result = [];
    for (CarOptions co in car_options) {
      if (co.selected) {
        result.add(co.id);
      }
    }
    return result;
  }

  void clearSelection() {
    for (CarOptions co in car_options) {
      co.selected = false;
    }
  }

  factory CarOptionsList.fromJson(Map<String, dynamic> json) => _$CarOptionsListFromJson(json);
}
