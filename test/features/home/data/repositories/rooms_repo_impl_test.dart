import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/home/data/data_sources/remote/rooms_remote_data_source_impl.dart';
import 'package:chat_app/features/home/data/models/room_model.dart';
import 'package:chat_app/features/home/data/repositories/rooms_repo_impl.dart';
import 'package:chat_app/features/home/domain/entities/room_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'rooms_repo_impl_test.mocks.dart';

@GenerateMocks([RoomsRemoteDataSourceImpl])
void main() {
  late RoomsRepoImpl repoImpl;
  late MockRoomsRemoteDataSourceImpl mockRoomsRemoteDataSourceImpl;
  String userId='uId1';
  setUp(() {
    provideDummy<BaseResponse<List<RoomModel>>>(SuccessResponse<List<RoomModel>>(data: []));
    provideDummy<BaseResponse<RoomModel>>(SuccessResponse<RoomModel>(data: RoomModel(name: 'name1', description: 'description1', categoryId: 'categoryId1')));
    mockRoomsRemoteDataSourceImpl=MockRoomsRemoteDataSourceImpl();
    repoImpl=RoomsRepoImpl(mockRoomsRemoteDataSourceImpl);
  },);
  group('getRooms test cases', () {
    test('success case with success response', () async{
      final dummyModels=[
        RoomModel( id: 'id1',name: 'name1', description: 'description1', categoryId: 'categoryId1',createdAt: DateTime(2026,9,9)),
        RoomModel( id: 'id2',name: 'name2', description: 'description2', categoryId: 'categoryId2',createdAt: DateTime(2026,9,10))
      ];
      when(mockRoomsRemoteDataSourceImpl.getRooms(userId)).thenAnswer(
        (_) async=> SuccessResponse<List<RoomModel>>(data: dummyModels),
      );
      final result=await repoImpl.getRooms(userId);
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
      verify(mockRoomsRemoteDataSourceImpl.getRooms(userId)).called(1);
    },);
    test('success case with success response with an empty list',() async{
      List<RoomModel> dummyModels=[];
      when(mockRoomsRemoteDataSourceImpl.getRooms(userId)).thenAnswer(
        (_) async=> SuccessResponse<List<RoomModel>>(data: dummyModels),
      );
      final result=await repoImpl.getRooms(userId);
      expect(result, isA<SuccessResponse<List<RoomEntity>>>());
      expect((result as SuccessResponse<List<RoomEntity>>).data.length, equals(dummyModels.length));
      verify(mockRoomsRemoteDataSourceImpl.getRooms(userId)).called(1);
    },);
    test('error case with Error response', () async{
      final dummyException=Exception('Firestore Error');
      when(mockRoomsRemoteDataSourceImpl.getRooms(userId)).thenAnswer(
        (_) async=> ErrorResponse<List<RoomModel>>(error: dummyException),
      );
      final result=await repoImpl.getRooms(userId);
      expect(result, isA<ErrorResponse<List<RoomEntity>>>());
      expect((result as ErrorResponse<List<RoomEntity>>).error.toString(), equals(dummyException.toString())); 
      verify(mockRoomsRemoteDataSourceImpl.getRooms(userId)).called(1);     
    },);
  },);
  group('createRoom test cases', () {
      final room=RoomModel(name: 'name1', description: 'description1', categoryId: 'categoryId1');
      test('success case with success response', () async{
        when(mockRoomsRemoteDataSourceImpl.createRoom(any, userId)).thenAnswer(
          (_) async=> SuccessResponse<RoomModel>(data: room),
        );
        final result=await repoImpl.createRoom(name: room.name, description: room.description, categoryId: room.categoryId, userId: userId);
        expect(result, isA<SuccessResponse<RoomEntity>>());
        expect((result as SuccessResponse<RoomEntity>).data.name, equals(room.name));
        expect(result.data.description, equals(room.description));
        expect(result.data.categoryId, equals(room.categoryId));
        verify(mockRoomsRemoteDataSourceImpl.createRoom(any, userId)).called(1);
      },);
      test('error case with error response', () async{
        final dummyException=Exception('Firestore Error');
        when(mockRoomsRemoteDataSourceImpl.createRoom(any, userId)).thenAnswer(
          (_) async=> ErrorResponse<RoomModel>(error: dummyException),
        );
        final result=await repoImpl.createRoom(name: room.name, description: room.description, categoryId: room.categoryId, userId: userId);
        expect(result, isA<ErrorResponse<RoomEntity>>());
        expect((result as ErrorResponse<RoomEntity>).error.toString(), equals(dummyException.toString()));
        verify(mockRoomsRemoteDataSourceImpl.createRoom(any, userId)).called(1);
      },);
    },);
}