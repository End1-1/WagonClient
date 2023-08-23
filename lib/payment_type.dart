import 'package:json_annotation/json_annotation.dart';

part 'payment_type.g.dart';

@JsonSerializable()
class PaymentType extends Object {
  int id;
  int type;
  String name;

  @JsonKey(defaultValue: false)
  bool selected;

  PaymentType(this.id, this.type, this.name, this.selected) {}

  factory PaymentType.fromJson(Map<String, dynamic> json) =>
      _$PaymentTypeFromJson(json);
}

@JsonSerializable()
class PaymentTypes {
  List<PaymentType> payment_types;

  PaymentTypes(this.payment_types);

  PaymentType? getSelected() {
    for (PaymentType pt in payment_types) {
      if (pt.selected) {
        return pt;
      }
    }
    return null;
  }

  void uncheckAll() {
    for (PaymentType pt in payment_types) {
      pt.selected = false;
    }
  }

  factory PaymentTypes.fromJson(Map<String, dynamic> json) =>
      _$PaymentTypesFromJson(json);
}
