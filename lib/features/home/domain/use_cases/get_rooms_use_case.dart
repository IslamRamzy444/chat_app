import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/home/domain/entities/room_entity.dart';
import 'package:chat_app/features/home/domain/repositories/rooms_repo_contract.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetRoomsUseCase {
  final RoomsRepoContract _repoContract;
  GetRoomsUseCase(this._repoContract);
  Future<BaseResponse<List<RoomEntity>>> call(String userId) async{
    return _repoContract.getRooms(userId);
  }
}