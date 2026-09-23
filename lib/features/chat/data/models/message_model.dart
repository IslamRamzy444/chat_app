import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? id;
  final String content;
  final String senderId;
  final String senderName;
  final DateTime dateTime;
  final String roomId;
  MessageModel({this.id,required this.content,required this.senderId,required this.senderName,required this.dateTime,required this.roomId});
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      content: json['content'],
      id: json['id'],
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      dateTime: json['dateTime'] != null? (json['dateTime'] as Timestamp).toDate(): DateTime.now(),
      roomId: json['roomId'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'roomId': roomId,
      'content':content
    };
  }
  MessageEntity toEntity() {
    return MessageEntity(
      content: content,
      id: id,
      senderId: senderId,
      senderName: senderName,
      dateTime: dateTime,
      roomId: roomId,
    );
  }
}