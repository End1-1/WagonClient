import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

@JsonSerializable()
class Company {
  int id;
  String name;
  List<int> car_classes;

  @JsonKey(defaultValue: false)
  bool checked;

  Company(
      this.id,
      this.name,
      this.car_classes,
      this.checked
      ) {
  }

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
}

@JsonSerializable()
class Companies {

  List<Company> companies;

  Companies(
      this.companies
      );

  void setChecked(int index) {
    for (Company c in companies) {
      c.checked = false;
    }
    companies[index].checked = true;
  }

  Company? getSelected() {
    for (Company c in companies) {
      if (c.checked) {
        return c;
      }
    }
    return null;
  }

  factory Companies.fromJson(Map<String, dynamic> json) => _$CompaniesFromJson(json);
}