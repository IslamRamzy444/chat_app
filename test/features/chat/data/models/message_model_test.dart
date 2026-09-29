
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/test.dart';

void main() {
  final tDateTime = DateTime(2024, 1, 15, 10, 30);
  final tTimestamp = Timestamp.fromDate(tDateTime);

  final tJson = <String, dynamic>{
    'id': 'msg_1',
    'content': 'Hello World',
    'senderId': 'user_1',
    'senderName': 'Alice',
    'dateTime': tTimestamp,
    'roomId': 'room_123',
  };

  final tModel = MessageModel(
    id: 'msg_1',
    content: 'Hello World',
    senderId: 'user_1',
    senderName: 'Alice',
    dateTime: tDateTime,
    roomId: 'room_123',
  );

  group('fromJson', () {
    test('should return a valid MessageModel when all fields are present', () {
      final result = MessageModel.fromJson(tJson);
      expect(result.id, 'msg_1');
      expect(result.content, 'Hello World');
      expect(result.senderId, 'user_1');
      expect(result.senderName, 'Alice');
      expect(result.roomId, 'room_123');
      expect(result.dateTime, tDateTime);
    });

    test('should fall back to default values when optional fields are missing',
        () {
      
      final partialJson = <String, dynamic>{
        'content': 'Hi',
      };
      final before = DateTime.now();
      final result = MessageModel.fromJson(partialJson);
      final after = DateTime.now();
      expect(result.id, isNull);
      expect(result.content, 'Hi');
      expect(result.senderId, '');
      expect(result.senderName, '');
      expect(result.roomId, '');
      expect(
        result.dateTime.isAfter(before.subtract(const Duration(seconds: 1))),
        isTrue,
      );
      expect(
        result.dateTime.isBefore(after.add(const Duration(seconds: 1))),
        isTrue,
      );
    });

    test('should parse dateTime from a Timestamp', () {
      final result = MessageModel.fromJson(tJson);
      expect(result.dateTime, isA<DateTime>());
      expect(result.dateTime, tTimestamp.toDate());
    });
  });

  group('toJson', () {
    test('should return a map containing all model fields except dateTime',
        () {
      final result = tModel.toJson();
      expect(result['id'], 'msg_1');
      expect(result['content'], 'Hello World');
      expect(result['senderId'], 'user_1');
      expect(result['senderName'], 'Alice');
      expect(result['roomId'], 'room_123');
      expect(result.containsKey('dateTime'), isFalse);
    });

    test('should produce a map that fromJson can partially round-trip', () {
      final json = tModel.toJson();
      final roundTripped = MessageModel.fromJson(json);
      expect(roundTripped.id, tModel.id);
      expect(roundTripped.content, tModel.content);
      expect(roundTripped.senderId, tModel.senderId);
      expect(roundTripped.senderName, tModel.senderName);
      expect(roundTripped.roomId, tModel.roomId);
      expect(roundTripped.dateTime, isA<DateTime>());
    });
  });

  group('toEntity', () {
    test('should map every field to a MessageEntity', () {
      // Act
      final result = tModel.toEntity();

      // Assert
      expect(result, isA<MessageEntity>());
      expect(result.id, tModel.id);
      expect(result.content, tModel.content);
      expect(result.senderId, tModel.senderId);
      expect(result.senderName, tModel.senderName);
      expect(result.roomId, tModel.roomId);
      expect(result.dateTime, tModel.dateTime);
    });
  });
}