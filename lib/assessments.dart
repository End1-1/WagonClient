import 'package:json_annotation/json_annotation.dart';

part 'assessments.g.dart';

@JsonSerializable()
class Assessment extends Object {
  String name;
  int option_id;
  String assessment;

  @JsonKey(defaultValue: false)
  bool selected;

  Assessment(
      this.name,
      this.option_id,
      this.assessment,
      this.selected
      ) ;

  factory Assessment.fromJson(Map<String, dynamic> json) => _$AssessmentFromJson(json);
}

@JsonSerializable()
class AssessmentList {
  List<Assessment> list;

  AssessmentList(this.list);

  void setSelected(int index, bool v) {
    for (int i = 0; i < list.length; i++) {
      list[i].selected = false;
    }
    if (index < 0) {
      return;
    }
    list[index].selected = v;
  }

  Assessment? getSelected() {
    for (Assessment a in list) {
      if (a.selected) {
        return a;
      }
    }
    return null;
  }

  factory AssessmentList.fromJson(Map<String, dynamic> json) => _$AssessmentListFromJson(json);
}