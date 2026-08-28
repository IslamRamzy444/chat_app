
import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/home/domain/entities/category_entity.dart';
import 'package:chat_app/features/home/domain/entities/room_entity.dart';
import 'package:chat_app/features/home/domain/use_cases/create_room_use_case.dart';
import 'package:chat_app/features/home/domain/use_cases/get_rooms_use_case.dart';
import 'package:chat_app/features/home/presentation/view_model/rooms_events.dart';
import 'package:chat_app/features/home/presentation/view_model/rooms_states.dart';
import 'package:chat_app/features/home/presentation/view_model/rooms_view_model.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'rooms_view_model_test.mocks.dart';
@GenerateMocks([CreateRoomUseCase, GetRoomsUseCase])
void main() {
  late RoomsViewModel viewModel;
  late MockGetRoomsUseCase mockGetRoomsUseCase;
  late MockCreateRoomUseCase mockCreateRoomUseCase;

  const name = 'test_name';
  const description = 'test_description';
  const categoryId = 'test_category_id';

  setUp(() {
    provideDummy<BaseResponse<List<RoomEntity>>>(
      SuccessResponse<List<RoomEntity>>(data: []),
    );
    provideDummy<BaseResponse<RoomEntity>>(
      SuccessResponse<RoomEntity>(
        data: RoomEntity(name: name, description: description, categoryId: categoryId),
      ),
    );

    mockGetRoomsUseCase = MockGetRoomsUseCase();
    mockCreateRoomUseCase = MockCreateRoomUseCase();

    viewModel = RoomsViewModel(mockGetRoomsUseCase, mockCreateRoomUseCase);
  });

  tearDown(() {
    viewModel.close();
  });

  group('room view model test cases', () {
    group('get rooms event test cases', () {
      test('success case with success response', () {
        final dummyModels = [
          RoomEntity(
            id: 'id1',
            name: 'name1',
            description: 'description1',
            categoryId: 'categoryId1',
            createdAt: DateTime(2026, 8, 23),
          ),
          RoomEntity(
            id: 'id2',
            name: 'name2',
            description: 'description2',
            categoryId: 'categoryId2',
            createdAt: DateTime(2026, 8, 26),
          ),
        ];

        when(mockGetRoomsUseCase.call())
            .thenAnswer((_) async => SuccessResponse<List<RoomEntity>>(data: dummyModels));

        expectLater(
          viewModel.stream,
          emitsInOrder([
            predicate<RoomsStates>(
              (p0) => p0.roomsState?.isLoading == true,
            ),
            predicate<RoomsStates>(
              (p0) =>
                  p0.roomsState?.isLoading == false &&
                  p0.roomsState?.data?.length == dummyModels.length,
            ),
          ]),
        );

        viewModel.doIntent(GetRoomsEvent());
      });

      test('error case with error response', () {
        final dummyException = Exception('Failed to fetch rooms');

        when(mockGetRoomsUseCase.call())
            .thenAnswer((_) async => ErrorResponse<List<RoomEntity>>(error: dummyException));

        expectLater(
          viewModel.stream,
          emitsInOrder([
            predicate<RoomsStates>(
              (p0) => p0.roomsState?.isLoading == true,
            ),
            predicate<RoomsStates>(
              (p0) =>
                  p0.roomsState?.isLoading == false &&
                  p0.roomsState?.errorMessage == dummyException.toString(),
            ),
          ]),
        );

        viewModel.doIntent(GetRoomsEvent());
      });
    });

    group('create room event test cases', () {
      final room = RoomEntity(
        id: 'id1',
        name: name,
        description: description,
        categoryId: categoryId,
      );

      test('success case with success response', () {
        when(mockCreateRoomUseCase.call(
          name: name,
          description: description,
          categoryId: categoryId,
        )).thenAnswer((_) async => SuccessResponse<RoomEntity>(data: room));

        expectLater(
          viewModel.stream,
          emitsInOrder([
            predicate<RoomsStates>(
              (p0) => p0.createRoomState?.isLoading == true,
            ),
            predicate<RoomsStates>(
              (p0) =>
                  p0.createRoomState?.isLoading == false &&
                  p0.createRoomState?.data != null &&
                  p0.createRoomState?.data?.id == room.id,
            ),
          ]),
        );

        viewModel.doIntent(
          CreateRoomEvent(
            name: name,
            description: description,
            categoryId: categoryId,
          ),
        );
      });

      test('error case with error response', () {
        final dummyException = Exception('Failed to create room');

        when(mockCreateRoomUseCase.call(
          name: name,
          description: description,
          categoryId: categoryId,
        )).thenAnswer((_) async => ErrorResponse<RoomEntity>(error: dummyException));

        expectLater(
          viewModel.stream,
          emitsInOrder([
            predicate<RoomsStates>(
              (p0) => p0.createRoomState?.isLoading == true,
            ),
            predicate<RoomsStates>(
              (p0) =>
                  p0.createRoomState?.isLoading == false &&
                  p0.createRoomState?.errorMessage == dummyException.toString(),
            ),
          ]),
        );

        viewModel.doIntent(
          CreateRoomEvent(
            name: name,
            description: description,
            categoryId: categoryId,
          ),
        );
      });
    });

    group('SelectCategoryEvent test cases', () {
      test('should update selectedCategory in state', () {
        final testCategory = CategoryEntity(
          id: 'sports',
          nameKey: 'sports',
          iconData: Icons.sports_soccer_sharp,
        );

        viewModel.doIntent(SelectCategoryEvent(testCategory));

        expect(viewModel.state.selectedCategory, isNotNull);
        expect(viewModel.state.selectedCategory?.id, 'sports');
        expect(viewModel.state.selectedCategory?.nameKey, 'sports');
      });

      test('should replace previously selected category with new one', () {
        final firstCategory = CategoryEntity(
          id: 'sports',
          nameKey: 'sports',
          iconData: Icons.sports_soccer_sharp,
        );
        final secondCategory = CategoryEntity(
          id: 'music',
          nameKey: 'music',
          iconData: Icons.music_note,
        );

        viewModel.doIntent(SelectCategoryEvent(firstCategory));
        viewModel.doIntent(SelectCategoryEvent(secondCategory));

        expect(viewModel.state.selectedCategory?.id, 'music');
        expect(viewModel.state.selectedCategory?.nameKey, 'music');
      });
    });
  });
}