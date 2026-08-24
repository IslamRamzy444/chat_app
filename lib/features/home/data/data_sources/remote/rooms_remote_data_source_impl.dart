import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/home/data/data_sources/remote/rooms_remote_data_source_contract.dart';
import 'package:chat_app/features/home/data/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
@Injectable(as: RoomsRemoteDataSourceContract)
class RoomsRemoteDataSourceImpl implements RoomsRemoteDataSourceContract{
  final FirebaseFirestore _firestore;
  RoomsRemoteDataSourceImpl(this._firestore);
  @override
  Future<BaseResponse<RoomModel>> createRoom(RoomModel room,String userId) async{
    try{
      final docRef = _firestore.collection('users').doc(userId).collection('rooms').doc();
      final roomData = room.toJson();
      roomData['id'] = docRef.id;
      roomData['createdAt'] = FieldValue.serverTimestamp();
      await docRef.set(roomData);
      final snapshot = await docRef.get();
      final data = snapshot.data()!;
      data['id'] = snapshot.id;
      final createdRoom = RoomModel.fromJson(data);
      return SuccessResponse<RoomModel>(data: createdRoom);
    }catch(e){
      return ErrorResponse<RoomModel>(error: Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponse<List<RoomModel>>> getRooms(String userId) async{
    try{
      final snapshot = await _firestore.collection('users').doc(userId).collection('rooms').orderBy('createdAt', descending: false) .get();
      final rooms=snapshot.docs.map((doc) {
        final data=doc.data();
        data['id']=doc.id;
        return RoomModel.fromJson(data);
      },).toList();
      return SuccessResponse<List<RoomModel>>(data: rooms);
    }catch(e){
      return ErrorResponse<List<RoomModel>>(error: Exception(e.toString()));
    }
  }

}