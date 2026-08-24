
import 'package:chat_app/features/home/data/models/room_model.dart';
import 'package:test/test.dart';

void main() {
  group('room model test cases', () {
    test('fromJson should parse allfields',() {
      final json={
        'id':'id1',
        'name':'name1',
        'description':'description1',
        'categoryId':'categoryId1'
      };
      final dto=RoomModel.fromJson(json);
      expect(dto.id, equals(json['id']));
      expect(dto.name, equals(json['name']));
      expect(dto.description, equals(json['description']));
      expect(dto.categoryId, equals(json['categoryId']));
    },);
    test('toEntity should map relevant fields', () {
      final dto=RoomModel(
        id: 'id1',
        name: 'name1', 
        description: 'description1', 
        categoryId: 'categoryId1',
        createdAt: DateTime(2027,1,9)
      );
      final entity=dto.toEntity();
      expect(entity.id, equals(dto.id));
      expect(entity.name, equals(dto.name));
      expect(entity.description, equals(dto.description));
      expect(entity.categoryId, equals(dto.categoryId));
      expect(entity.createdAt, equals(dto.createdAt));
    },);
    test('toJson should serialize all fields', () {
      final dto=RoomModel(
        id: 'id1',
        name: 'name1', 
        description: 'description1', 
        categoryId: 'categoryId1'
      );
      final json=dto.toJson();
      expect(json['id'], equals(dto.id));
      expect(json['name'], equals(dto.name));
      expect(json['description'], equals(dto.description));
      expect(json['categoryId'], equals(dto.categoryId));
    },);
  },);
}