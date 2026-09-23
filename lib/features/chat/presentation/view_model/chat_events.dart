sealed class ChatEvents {}
class LoadCurrentUserEvent extends ChatEvents {}
class LoadMessagesEvent extends ChatEvents {
  final String roomId;
  LoadMessagesEvent(this.roomId);
}
class SendMessageEvent extends ChatEvents {
  final String content;
  final String roomId;
  SendMessageEvent({
    required this.content,
    required this.roomId,
  });
}
class UpdateMessageTextEvent extends ChatEvents {
  final String text;
  UpdateMessageTextEvent(this.text);
}