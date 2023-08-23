import 'package:json_annotation/json_annotation.dart';

part 'history_list.g.dart';

@JsonSerializable()
class History extends Object {
  int order_id;

  @JsonKey(defaultValue: "")
  String ordered_from;

  @JsonKey(defaultValue: "")
  String ordered_to;

  double cost;
  String started;

  History(
      this.order_id,
      this.ordered_from,
      this.ordered_to,
      this.cost,
      this.started
      ) ;

  factory History.fromJson(Map<String, dynamic> json) => _$HistoryFromJson(json);
}

@JsonSerializable()
class HistoryList {
  late List<History> list;

  @JsonKey(defaultValue: 0)
  late int mode;

  HistoryList(this.list);

  factory HistoryList.fromJson(Map<String, dynamic> json) => _$HistoryListFromJson(json);
}