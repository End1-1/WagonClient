import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_info.freezed.dart';
part 'company_info.g.dart';

@freezed
class CompanyInfo with _$CompanyInfo {
  const CompanyInfo._();
  const factory CompanyInfo({
  required int id,
    required String name,
    required List<int> car_classes,
    required bool? checked
}) = _CompanyInfo;
  factory CompanyInfo.fromJson(Map<String, dynamic> json) => _$CompanyInfoFromJson(json);

  bool isChecked() {
    return this.checked ?? false;
  }
}