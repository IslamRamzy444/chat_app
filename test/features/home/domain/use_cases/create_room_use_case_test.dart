import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/home/data/repositories/rooms_repo_impl.dart';
import 'package:chat_app/features/home/domain/entities/room_entity.dart';
import 'package:chat_app/features/home/domain/use_cases/create_room_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'create_room_use_case_test.mocks.dart';

@GenerateMocks([RoomsRepoImpl])
void main() {
  late CreateRoomUseCase createRoomUseCase;
  late MockRoomsRepoImpl mockRoomsRepoImpl;
  String userId='uId1';
  setUp(() {
    provideDummy<BaseResponse<RoomEntity>>(SuccessResponse<RoomEntity>(data: RoomEntity(name: 'name1', description: 'description1', categoryId: 'categoryId1')));
    mockRoomsRepoImpl=MockRoomsRepoImpl();
    createRoomUseCase=CreateRoomUseCase(mockRoomsRepoImpl);
  },);
  group('create room use case test cases', () {
    final room=RoomEntity(
      id: 'id1',
      name: 'name1', 
      description: 'description1', 
      categoryId: 'categoryId1',
      createdAt: DateTime(2026,9,9)
    );
    test('success case with success response', () async{
      when(mockRoomsRepoImpl.createRoom(name: room.name, description: room.description, categoryId: room.categoryId, userId: userId)).thenAnswer(
        (_) async=> SuccessResponse<RoomEntity>(data: room),
      );
      final result=await createRoomUseCase.call(name: room.name, description: room.description, categoryId: room.categoryId, userId: userId);
      expect(result, isA<SuccessResponse<RoomEntity>>());
      expect((result as SuccessResponse<RoomEntity>).data.id, equals(room.id));
      expect(result.data.name, equals(room.name));
      expect(result.data.description, equals(room.description));
      expect(result.data.categoryId, equals(room.categoryId));
      expect(result.data.createdAt, equals(room.createdAt));
      verify(mockRoomsRepoImpl.createRoom(name: room.name, description: room.description, categoryId: room.categoryId, userId: userId)).called(1);
    },);
    test('error case with error response', () async{
      final dummyException=Exception('firestore error');
      when(mockRoomsRepoImpl.createRoom(name: room.name, description: room.description, categoryId: room.categoryId, userId: userId)).thenAnswer(
        (_) async=> ErrorResponse<RoomEntity>(error: dummyException),
      );
      final result=await createRoomUseCase.call(name: room.name, description: room.description, categoryId: room.categoryId, userId: userId);
      expect(result, isA<ErrorResponse<RoomEntity>>());
      expect((result as ErrorResponse<RoomEntity>).error.toString(), equals(dummyException.toString()));
      verify(mockRoomsRepoImpl.createRoom(name: room.name, description: room.description, categoryId: room.categoryId, userId: userId)).called(1);
    },);
  },);
}