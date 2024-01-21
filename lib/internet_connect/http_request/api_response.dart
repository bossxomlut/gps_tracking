sealed class ApiResponse extends ResponseData {
  ApiResponse({required super.message, required super.data});
}

class SuccessApiResponse extends ApiResponse {
  SuccessApiResponse({required super.message, required super.data});
}

class FailureApiResponse<T> extends ApiResponse {
  FailureApiResponse({required super.message, required super.data});
}

class InternetErrorResponse extends ApiResponse {
  InternetErrorResponse({required super.message, required super.data});
}

abstract class ResponseData<T> {
  final String message;
  final dynamic data;

  ResponseData({required this.message, required this.data});
}
