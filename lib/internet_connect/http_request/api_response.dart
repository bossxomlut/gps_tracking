sealed class ApiResponse {}

class SuccessApiResponse extends ResponseData implements ApiResponse {
  SuccessApiResponse({required super.message, required super.data});
}

class FailureApiResponse<T> extends ResponseData implements ApiResponse {
  FailureApiResponse({required super.message, required super.data});
}

abstract class ResponseData<T> {
  final String message;
  final T data;

  ResponseData({required this.message, required this.data});
}
