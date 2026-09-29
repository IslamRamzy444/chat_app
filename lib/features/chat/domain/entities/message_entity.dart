class MessageEntity {
  final String content;
  final String? id;
  final String senderId;
  final String senderName;
  final DateTime dateTime;
  final String roomId;

  MessageEntity({
    required this.content,
    this.id,
    required this.senderId,
    required this.senderName,
    required this.dateTime,
    required this.roomId,
  });
}