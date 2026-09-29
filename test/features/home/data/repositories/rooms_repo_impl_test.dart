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

  setUp(() {
    provideDummy<BaseResponse<List<RoomModel>>>(
      SuccessResponse<List<RoomModel>>(data: []),
    );
    provideDummy<BaseResponse<RoomModel>>(
      SuccessResponse<RoomModel>(
        data: RoomModel(
          name: 'name1',
          description: 'description1',
          categoryId: 'categoryId1',
        ),
      ),
    );
    mockRoomsRemoteDataSourceImpl = MockRoomsRemoteDataSourceImpl();
    repoImpl = RoomsRepoImpl(mockRoomsRemoteDataSourceImpl);
  });

  group('getRooms test cases', () {
    test('success case with success response', () async {
      final dummyModels = [
        RoomModel(
          id: 'id1',
          name: 'name1',
          description: 'description1',
          categoryId: 'categoryId1',
          createdAt: DateTime(2026, 9, 9),
        ),
        RoomModel(
          id: 'id2',
          name: 'name2',
          description: 'description2',
          categoryId: 'categoryId2',
          createdAt: DateTime(2026, 9, 10),
        ),
      ];

      when(mockRoomsRemoteDataSourceImpl.getRooms())
          .thenAnswer((_) async => SuccessResponse<List<RoomModel>>(data: dummyModels));

      final result = await repoImpl.getRooms();

      expect(result, isA<SuccessResponse<List<RoomEntity>>>());
      final successResponse = result as SuccessResponse<List<RoomEntity>>;
      expect(successResponse.data.length, equals(dummyModels.length));
      expect(successResponse.data[0].id, equals(dummyModels[0].id));
      expect(successResponse.data[0].name, equals(dummyModels[0].name));
      expect(successResponse.data[0].description, equals(dummyModels[0].description));
      expect(successResponse.data[0].categoryId, equals(dummyModels[0].categoryId));
      expect(successResponse.data[0].createdAt, equals(dummyModels[0].createdAt));
      expect(successResponse.data[1].id, equals(dummyModels[1].id));
      expect(successResponse.data[1].name, equals(dummyModels[1].name));
      expect(successResponse.data[1].description, equals(dummyModels[1].description));
      expect(successResponse.data[1].categoryId, equals(dummyModels[1].categoryId));
      expect(successResponse.data[1].createdAt, equals(dummyModels[1].createdAt));
      verify(mockRoomsRemoteDataSourceImpl.getRooms()).called(1);
    });

    test('success case with success response with an empty list', () async {
      List<RoomModel> dummyModels = [];

      when(mockRoomsRemoteDataSourceImpl.getRooms())
          .thenAnswer((_) async => SuccessResponse<List<RoomModel>>(data: dummyModels));

      final result = await repoImpl.getRooms();

      expect(result, isA<SuccessResponse<List<RoomEntity>>>());
      final successResponse = result as SuccessResponse<List<RoomEntity>>;
      expect(successResponse.data.length, equals(dummyModels.length));
      verify(mockRoomsRemoteDataSourceImpl.getRooms()).called(1);
    });

    test('error case with Error response', () async {
      final dummyException = Exception('Firestore Error');

      when(mockRoomsRemoteDataSourceImpl.getRooms())
          .thenAnswer((_) async => ErrorResponse<List<RoomModel>>(error: dummyException));

      final result = await repoImpl.getRooms();

      expect(result, isA<ErrorResponse<List<RoomEntity>>>());
      final errorResponse = result as ErrorResponse<List<RoomEntity>>;
      expect(errorResponse.error.toString(), equals(dummyException.toString()));
      verify(mockRoomsRemoteDataSourceImpl.getRooms()).called(1);
    });
  });

  group('createRoom test cases', () {
    final room = RoomModel(
      name: 'name1',
      description: 'description1',
      categoryId: 'categoryId1',
    );

    test('success case with success response', () async {
      when(mockRoomsRemoteDataSourceImpl.createRoom(any))
          .thenAnswer((_) async => SuccessResponse<RoomModel>(data: room));

      final result = await repoImpl.createRoom(
        name: room.name,
        description: room.description,
        categoryId: room.categoryId,
      );

      expect(result, isA<SuccessResponse<RoomEntity>>());
      final successResponse = result as SuccessResponse<RoomEntity>;
      expect(successResponse.data.name, equals(room.name));
      expect(successResponse.data.description, equals(room.description));
      expect(successResponse.data.categoryId, equals(room.categoryId));
      verify(mockRoomsRemoteDataSourceImpl.createRoom(any)).called(1);
    });

    test('error case with error response', () async {
      final dummyException = Exception('Firestore Error');

      when(mockRoomsRemoteDataSourceImpl.createRoom(any))
          .thenAnswer((_) async => ErrorResponse<RoomModel>(error: dummyException));

      final result = await repoImpl.createRoom(
        name: room.name,
        description: room.description,
        categoryId: room.categoryId,
      );

      expect(result, isA<ErrorResponse<RoomEntity>>());
      final errorResponse = result as ErrorResponse<RoomEntity>;
      expect(errorResponse.error.toString(), equals(dummyException.toString()));
      verify(mockRoomsRemoteDataSourceImpl.createRoom(any)).called(1);
    });
  });
}