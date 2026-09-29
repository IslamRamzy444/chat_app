import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/chat/data/data_sources/remote/messages_remote_data_source_contract.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
@Injectable(as: MessagesRemoteDataSourceContract)
class MessagesRemoteDataSourceImpl implements MessagesRemoteDataSourceContract{
  final FirebaseFirestore _firestore;
  MessagesRemoteDataSourceImpl(this._firestore);
  @override
  BaseResponse<Stream<List<MessageModel>>> getMessages(String roomId) {
    try {
      final stream = _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .orderBy('dateTime', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return MessageModel.fromJson(data);
            }).toList();
          });

      return SuccessResponse<Stream<List<MessageModel>>>(data: stream);
    } catch (e) {
      return ErrorResponse<Stream<List<MessageModel>>>(
        error: Exception(e.toString()),
      );
    }
  }

  @override
  Future<BaseResponse<MessageModel>> sendMessage(MessageModel message) async{
    try {
      final docRef = _firestore
          .collection('rooms')
          .doc(message.roomId)
          .collection('messages')
          .doc();

      final messageData = message.toJson();
      messageData['id'] = docRef.id;
      messageData['dateTime'] = FieldValue.serverTimestamp();

      await docRef.set(messageData);

      final snapshot = await docRef.get();
      final data = snapshot.data()!;
      data['id'] = snapshot.id;

      final createdMessage = MessageModel.fromJson(data);
      return SuccessResponse<MessageModel>(data: createdMessage);
    } catch (e) {
      return ErrorResponse<MessageModel>(error: Exception(e.toString()));
    }
  }

}