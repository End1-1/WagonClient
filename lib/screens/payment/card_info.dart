import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_info.freezed.dart';
part 'card_info.g.dart';

@freezed
class CardInfo with _$CardInfo {
  const factory CardInfo({
    required String id,
    required String name,
    required String number,
    required int selected
}) = _CardInfo;
  factory CardInfo.fromJson(Map<String, dynamic> json) => _$CardInfoFromJson(json);
}