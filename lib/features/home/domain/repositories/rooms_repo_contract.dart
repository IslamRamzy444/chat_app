import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/home/domain/entities/room_entity.dart';

abstract class RoomsRepoContract {
  Future<BaseResponse<List<RoomEntity>>> getRooms(String userId);
  Future<BaseResponse<RoomEntity>> createRoom({
    required String name,
    required String description,
    required String categoryId,
    required String userId
  });
}