import 'package:chat_app/config/base_state/base_state.dart';
import 'package:chat_app/features/home/domain/entities/category_entity.dart';
import 'package:chat_app/features/home/domain/entities/room_entity.dart';

class RoomsStates {
  BaseState<List<RoomEntity>>? roomsState;
  BaseState<RoomEntity>? createRoomState;
  CategoryEntity? selectedCategory;
  RoomsStates({this.roomsState,this.createRoomState,this.selectedCategory}); 
  RoomsStates copyWith({
    BaseState<List<RoomEntity>>? roomsState,
    BaseState<RoomEntity>? createRoomState,
    CategoryEntity? selectedCategory
  }){
    return RoomsStates(
      roomsState: roomsState ?? this.roomsState,
      createRoomState: createRoomState ?? this.createRoomState,
      selectedCategory: selectedCategory ?? this.selectedCategory
    );
  }
}