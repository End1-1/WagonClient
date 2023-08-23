import 'package:json_annotation/json_annotation.dart';

part 'order_cancel_options.g.dart';

@JsonSerializable()
class CancelOrderOption extends Object {
  int option;
  String name;

  @JsonKey(defaultValue: false)
  bool selected;

  CancelOrderOption(
      this.option,
      this.name,
      this.selected
      );

  factory CancelOrderOption.fromJson(Map<String, dynamic> json) => _$CancelOrderOptionFromJson(json);
}

@JsonSerializable()
class CancelOrderOptionList {
  @JsonKey(defaultValue: 0)
  int aborted_id = 0;
  List<CancelOrderOption> options = [];

  CancelOrderOptionList(
      this.aborted_id,
      this.options);

  CancelOrderOption? getSelected() {
    for (CancelOrderOption oo in options) {
      if (oo.selected) {
        return oo;
      }
    }
    return null;
  }

  void setSelected(int index, bool v) {
    for (CancelOrderOption oo in options) {
      oo.selected = false;
    }
    options[index].selected = v;
  }

  factory CancelOrderOptionList.fromJson(Map<String, dynamic> json) => _$CancelOrderOptionListFromJson(json);
}