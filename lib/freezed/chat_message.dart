import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required int order_conversation_talk_id,
    required int order_conversation_id,
    required String created_at,
    required String message,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

@freezed
class ChatMessageList with _$ChatMessageList {
  const factory ChatMessageList({required List<ChatMessage> list}) =
      _ChatMessageList;

  factory ChatMessageList.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageListFromJson(json);
}
