import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/home/domain/entities/room_entity.dart';
import 'package:chat_app/features/home/domain/repositories/rooms_repo_contract.dart';
import 'package:injectable/injectable.dart';
@injectable
class CreateRoomUseCase {
  final RoomsRepoContract _repoContract;

  CreateRoomUseCase(this._repoContract);

  Future<BaseResponse<RoomEntity>> call({
    required String name,
    required String description,
    required String categoryId,
  }) async {
    return _repoContract.createRoom(
      name: name,
      description: description,
      categoryId: categoryId,
    );
  }
}