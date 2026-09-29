import 'package:chat_app/config/base_response/base_response.dart';
import 'package:chat_app/features/chat/data/repositories/user_repo_impl.dart';
import 'package:chat_app/features/chat/domain/entities/user_entity.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_current_user_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'get_current_user_use_case_test.mocks.dart';

@GenerateMocks([UserRepoImpl])
void main() {
  late GetCurrentUserUseCase getCurrentUserUseCase;
  late MockUserRepoImpl mockUserRepoImpl;
  setUp(() {
    provideDummy<BaseResponse<UserEntity>>(SuccessResponse<UserEntity>(data: UserEntity(id: 'id1', email: 'email1', name: 'name1')));
    mockUserRepoImpl=MockUserRepoImpl();
    getCurrentUserUseCase=GetCurrentUserUseCase(mockUserRepoImpl);
  },);
  group('getCurrentUseCase test cases', () {
    test('success case with success response', () async{
      final dummyCurrentUser=UserEntity(id: 'id1', email: 'email1', name: 'name1');
      when(mockUserRepoImpl.getCurrentUser()).thenAnswer(
        (_) async=> SuccessResponse<UserEntity>(data: dummyCurrentUser),
      );
      final result=await getCurrentUserUseCase.call();
      expect(result, isA<BaseResponse<UserEntity>>());
      expect((result as SuccessResponse<UserEntity>).data.id, equals(dummyCurrentUser.id));
      expect(result.data.email, equals(dummyCurrentUser.email));
      expect(result.data.name, equals(dummyCurrentUser.name));
    },);
    test('failure case with error response', () async{
      final dummyException=Exception('Network Error');
      when(mockUserRepoImpl.getCurrentUser()).thenAnswer(
        (_) async=> ErrorResponse<UserEntity>(error: dummyException),
      );
      final result=await getCurrentUserUseCase.call();
      expect(result, isA<BaseResponse<UserEntity>>());
      expect((result as ErrorResponse<UserEntity>).error.toString(), equals(dummyException.toString()));
    },);
  },);
}