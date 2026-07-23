sealed class BaseResponse<T> {}
class SuccessResonse<T> extends BaseResponse<T>{
  final T data;
  SuccessResonse({required this.data});
}
class ErrorResponse<T> extends BaseResponse<T>{
  final Exception error;
  ErrorResponse({required this.error});
}