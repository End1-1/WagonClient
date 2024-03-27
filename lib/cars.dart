import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cars.g.dart';

@JsonSerializable()
class CarOption extends Object {
  int id;
  String option;
  String name;
  String value;
  double price;

  @JsonKey(defaultValue: false)
  bool selected;

  CarOption(
      this.id,
      this.option,
      this.name,
      this.value,
      this.price,
      this.selected
      ){
  }

  factory CarOption.fromJson(Map<String, dynamic> json) => _$CarOptionFromJson(json);
}

@JsonSerializable()
class Car extends Object {
  int class_id;
  String name;
  double? min_price;
  double? coin;
  int closest_driver_duration;
  //String? image;

  @JsonKey(defaultValue: 0)
  int selected;

  Image? _image ;
  List<CarOption> car_options = [];
  List<int> rent_times = [];

  Car(this.class_id,
      this.name,
      this.min_price,
      this.coin,
      this.closest_driver_duration,
      //this.image,
      this.selected,
      this.car_options,
      this.rent_times) {
    if (coin == null) {
      coin = 0;
    }
    selected = 0;
  }

  // Image? getImage() {
  //   if (_image == null) {
  //     Uint8List raw = Base64Decoder().convert(image);
  //     _image = new Image.memory(raw);
  //   }
  //   return _image;
  // }

  double? getPrice() {
    return coin;
  }

  factory Car.fromJson(Map<String, dynamic> json) => _$CarFromJson(json);
}

@JsonSerializable()
class CarClasses {
  List<Car> car_classes = [];

  CarClasses(this.car_classes);
  Car? getSelected() {
    for (Car c in car_classes) {
      if (c.selected == 1) {
        return c;
      }
    }
    if (car_classes.length > 0) {
      car_classes[0].selected = 1;
      return car_classes[0];
    }
    return null;
  }

  void setSelected(int class_id) {
    for (Car c in car_classes) {
      c.selected = c.class_id == class_id ? 1 : 0;
    }
  }

  factory CarClasses.fromJson(Map<String, dynamic> json) => _$CarClassesFromJson(json);
}