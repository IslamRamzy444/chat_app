import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/auth/register/data/data_sources/register_remote_data_source_contract.dart';
import 'package:chat_app/features/auth/register/domain/entities/register_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
@Injectable(as: RegisterRemoteDataSourceContract)
class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSourceContract{
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  RegisterRemoteDataSourceImpl(this._auth,this._firestore);

  @override
  Future<BaseResponse<RegisterEntity>> registerWithEmailAndPassword(String email, String name, String password) async{
    try{
      final credential=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
      final user=credential.user!;
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email ?? email,
        'displayName': user.displayName ?? name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      final entity = RegisterEntity(
        userId: user.uid,
        email: user.email ?? email,
        name: user.displayName ?? name,
      );
      return SuccessResponse<RegisterEntity>(data: entity);
    }on FirebaseAuthException catch(e){
      return ErrorResponse<RegisterEntity>(error: Exception(e.message ?? 'Registeration Failed'));
    }catch(e){
      return ErrorResponse<RegisterEntity>(error: Exception(e.toString()));
    }
  }
}