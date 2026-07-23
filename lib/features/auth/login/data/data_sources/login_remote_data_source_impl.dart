import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/auth/login/data/data_sources/login_remote_data_source_contract.dart';
import 'package:chat_app/features/auth/login/domain/entities/login_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
@Injectable(as: LoginRemoteDataSourceContract)
class LoginRemoteDataSourceImpl implements LoginRemoteDataSourceContract{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  @override
  Future<BaseResponse<LoginEntity>> loginWithEmailAndPassword(String email, String password) async{
   try{
    final credential=await _auth.signInWithEmailAndPassword(email: email, password: password);
    final user=credential.user!;
    final entity=LoginEntity(
      userId: user.uid,
      email: user.email??email,
      name: user.displayName
    );
    return SuccessResonse<LoginEntity>(data: entity);
   }on FirebaseAuthException catch(e){
    return ErrorResponse<LoginEntity>(error: Exception(e.message));
   }catch(e){
    return ErrorResponse<LoginEntity>(error: Exception(e.toString()));
   }
  }

}