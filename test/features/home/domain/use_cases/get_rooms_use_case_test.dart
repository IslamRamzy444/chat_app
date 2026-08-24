import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/home/data/repositories/rooms_repo_impl.dart';
import 'package:chat_app/features/home/domain/entities/room_entity.dart';
import 'package:chat_app/features/home/domain/use_cases/get_rooms_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'get_rooms_use_case_test.mocks.dart';

@GenerateMocks([RoomsRepoImpl])
void main() {
  late GetRoomsUseCase getRoomsUseCase;
  late MockRoomsRepoImpl mockRoomsRepoImpl;
  String userId='uId1';
  setUp(() {
    provideDummy<BaseResponse<List<RoomEntity>>>(SuccessResponse<List<RoomEntity>>(data: []));
    mockRoomsRepoImpl=MockRoomsRepoImpl();
    getRoomsUseCase=GetRoomsUseCase(mockRoomsRepoImpl);
  },);
  group('get rooms use case test cases', () {
    test('success case with success response', () async{
      final dummyModels=[
        RoomEntity(id: 'id1',name: 'name1', description: 'description1', categoryId: 'categoryId1',createdAt: DateTime(2026,8,23)),
        RoomEntity(id: 'id2',name: 'name2', description: 'description2', categoryId: 'categoryId2',createdAt: DateTime(2026,8,26)),
      ];
      when(mockRoomsRepoImpl.getRooms(userId)).thenAnswer(
        (_) async=> SuccessResponse<List<RoomEntity>>(data: dummyModels),
      );
      final result=await getRoomsUseCase.call(userId);
      expect(result, isA<SuccessResponse<List<RoomEntity>>>());
      expect((result as SuccessResponse<List<RoomEntity>>).data.length, equals(dummyModels.length));
      expect(result.data[0].id, equals(dummyModels[0].id));
      expect(result.data[0].name, equals(dummyModels[0].name));
      expect(result.data[0].description, equals(dummyModels[0].description));
      expect(result.data[0].categoryId, equals(dummyModels[0].categoryId));
      expect(result.data[0].createdAt, equals(dummyModels[0].createdAt));
      expect(result.data[1].id, equals(dummyModels[1].id));
      expect(result.data[1].name, equals(dummyModels[1].name));
      expect(result.data[1].description, equals(dummyModels[1].description));
      expect(result.data[1].categoryId, equals(dummyModels[1].categoryId));
      expect(result.data[1].createdAt, equals(dummyModels[1].createdAt));
      verify(mockRoomsRepoImpl.getRooms(userId)).called(1);
    },);
    test('success case with success response with empty list',() async{
      List<RoomEntity> dummyModels=[];
      when(mockRoomsRepoImpl.getRooms(userId)).thenAnswer(
        (_) async=> SuccessResponse<List<RoomEntity>>(data: dummyModels),
      );
      final result=await getRoomsUseCase.call(userId);
      expect(result, isA<SuccessResponse<List<RoomEntity>>>());
      expect((result as SuccessResponse<List<RoomEntity>>).data, equals(isEmpty));
      verify(mockRoomsRepoImpl.getRooms(userId)).called(1);
    },);
    test('error case with error response', () async{
      final dummyException=Exception('firestore error');
      when(mockRoomsRepoImpl.getRooms(userId)).thenAnswer(
        (_) async=> ErrorResponse<List<RoomEntity>>(error: dummyException),
      );
      final result=await getRoomsUseCase.call(userId);
      expect(result, isA<ErrorResponse<List<RoomEntity>>>());
      expect((result as ErrorResponse<List<RoomEntity>>).error.toString(), equals(dummyException.toString()));
      verify(mockRoomsRepoImpl.getRooms(userId)).called(1);
    },);
  },);
}