import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/home/data/models/room_model.dart';

abstract class RoomsRemoteDataSourceContract {
  Future<BaseResponse<List<RoomModel>>> getRooms();
  Future<BaseResponse<RoomModel>> createRoom(RoomModel room);
}