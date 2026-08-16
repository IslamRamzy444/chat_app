import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/config/base_state/base_state.dart';
import 'package:chat_app/features/home/domain/entities/room_entity.dart';
import 'package:chat_app/features/home/domain/use_cases/create_room_use_case.dart';
import 'package:chat_app/features/home/domain/use_cases/get_rooms_use_case.dart';
import 'package:chat_app/features/home/presentation/view_model/rooms_events.dart';
import 'package:chat_app/features/home/presentation/view_model/rooms_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
@injectable
class RoomsViewModel extends Cubit<RoomsStates>{
  final GetRoomsUseCase _getRoomsUseCase;
  final CreateRoomUseCase _createRoomUseCase;
  final FirebaseAuth _auth;
  String? get _currentUserId => _auth.currentUser?.uid;
  RoomsViewModel(this._getRoomsUseCase,this._createRoomUseCase,this._auth):super(RoomsStates());
  void doIntent(RoomsEvents event){
    switch(event){
      
      case GetRoomsEvent():
        _getRooms();
      case CreateRoomEvent():
        _createRoom(event);
      case SelectCategoryEvent():
        _selectCategoryEvent(event);
    }
  }
  Future<void> _getRooms()async{
    final userId = _currentUserId;
    if (userId == null) {
      emit(state.copyWith(
        roomsState: BaseState<List<RoomEntity>>(
          isLoading: false,
          errorMessage: 'User not authenticated',
        ),
      ));
      return;
    }
    emit(state.copyWith(
      roomsState: BaseState<List<RoomEntity>>(
        isLoading: true
      )
    ));
    final res=await _getRoomsUseCase.call(userId);
    switch(res){
      
      case SuccessResponse<List<RoomEntity>>():
        emit(state.copyWith(
          roomsState: BaseState<List<RoomEntity>>(
            isLoading: false,
            data: res.data
          )
        ));
      case ErrorResponse<List<RoomEntity>>():
        emit(state.copyWith(
          roomsState: BaseState<List<RoomEntity>>(
            isLoading: false,
            errorMessage: res.error.toString()
          )
        ));
    }
  }
  Future<void> _createRoom(CreateRoomEvent event) async{
    final userId = _currentUserId;
    if (userId == null) {
      emit(state.copyWith(
        roomsState: BaseState<List<RoomEntity>>(
          isLoading: false,
          errorMessage: 'User not authenticated',
        ),
      ));
      return;
    }
    emit(state.copyWith(
      createRoomState: BaseState<RoomEntity>(
        isLoading: true
      )
    ));
    final res=await _createRoomUseCase.call(
      name: event.name, 
      description: event.description, 
      categoryId: event.categoryId,
      userId: userId
    );
    switch(res){
      
      case SuccessResponse<RoomEntity>():
        emit(state.copyWith(
          createRoomState: BaseState<RoomEntity>(
            isLoading: false,
            data: res.data
          )
        ));
      case ErrorResponse<RoomEntity>():
        emit(state.copyWith(
          createRoomState: BaseState<RoomEntity>(
            isLoading: false,
            errorMessage: res.error.toString()
          )
        ));
    }
  }
  void _selectCategoryEvent(SelectCategoryEvent event){
    emit(state.copyWith(
      selectedCategory: event.category
    ));
  }
}