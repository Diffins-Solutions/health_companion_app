class ApiResponse<T> {
  final int statusCode;
  final T? data;
  final String? error;

  ApiResponse({required this.statusCode, this.data, this.error});
}