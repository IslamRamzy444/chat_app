import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/home/data/data_sources/remote/rooms_remote_data_source_contract.dart';
import 'package:chat_app/features/home/data/models/room_model.dart';
import 'package:chat_app/features/home/domain/entities/room_entity.dart';
import 'package:chat_app/features/home/domain/repositories/rooms_repo_contract.dart';
import 'package:injectable/injectable.dart';
@Injectable(as: RoomsRepoContract)
class RoomsRepoImpl implements RoomsRepoContract{
  final RoomsRemoteDataSourceContract _dataSourceContract;
  RoomsRepoImpl(this._dataSourceContract);
  @override
  Future<BaseResponse<RoomEntity>> createRoom({required String name, required String description, required String categoryId,required String userId}) async{
    final room = RoomModel(
      name: name,
      description: description,
      categoryId: categoryId,
    );
    final response = await _dataSourceContract.createRoom(room,userId);
    switch(response){
      
      case SuccessResponse<RoomModel>():
        return SuccessResponse<RoomEntity>(data: response.data.toEntity());
      case ErrorResponse<RoomModel>():
        return ErrorResponse<RoomEntity>(error: response.error);
    }
  }

  @override
  Future<BaseResponse<List<RoomEntity>>> getRooms(String userId) async{
    final response=await _dataSourceContract.getRooms(userId);
    switch(response){
      
      case SuccessResponse<List<RoomModel>>():
        final rooms=response.data.map((e) => e.toEntity(),).toList();
        return SuccessResponse<List<RoomEntity>>(data: rooms);
      case ErrorResponse<List<RoomModel>>():
        return ErrorResponse<List<RoomEntity>>(error: response.error);
    }
  }

}