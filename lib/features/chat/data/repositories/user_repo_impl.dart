import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/chat/domain/entities/user_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/user_repo_contract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
@Injectable(as: UserRepoContract)
class UserRepoImpl implements UserRepoContract{
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  UserRepoImpl(this._auth,this._firestore);
  @override
  Future<BaseResponse<UserEntity>> getCurrentUser() async{
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        return ErrorResponse<UserEntity>(
          error: Exception('User not authenticated'),
        );
      }
      final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      final data = doc.data();
      if (data == null) {
        final entity = UserEntity(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? 'User',
        );
        return SuccessResponse<UserEntity>(data: entity);
      }
      final entity = UserEntity(
        id: firebaseUser.uid,
        email: data['email'] ?? firebaseUser.email ?? '',
        name: data['displayName'] ?? firebaseUser.displayName ?? 'User',
      );
      return SuccessResponse<UserEntity>(data: entity);
    } catch (e) {
      return ErrorResponse<UserEntity>(error: Exception(e.toString()));
    }
  }
}