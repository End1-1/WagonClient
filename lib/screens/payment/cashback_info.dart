import 'package:freezed_annotation/freezed_annotation.dart';

part 'cashback_info.freezed.dart';
part 'cashback_info.g.dart';

@freezed
class CashbackInfo with _$CashbackInfo {
  const factory CashbackInfo({
    required int client_id,
    required String balance,
    required int client_wallet_id
}) = _CashbackInfo;
  factory CashbackInfo.fromJson(Map<String, dynamic> json) => _$CashbackInfoFromJson(json);
}