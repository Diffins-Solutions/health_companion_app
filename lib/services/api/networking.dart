import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_response.dart';

class NetworkHelper{

  NetworkHelper (this.uri);

  final Uri uri ;

  Future<ApiResponse<T>> getData<T>() async {
    http.Response response = await http.get(uri);

    final statusCode = response.statusCode;
    final body = response.body;

    if (statusCode == 200) {
      try {
        final decodedData = jsonDecode(body) as T;
        return ApiResponse<T>(statusCode: statusCode, data: decodedData);
      } on FormatException catch (e) {
        // Handle JSON decoding error
        print('Error decoding JSON: $e');
        return ApiResponse<T>(statusCode: statusCode, error: e.toString());
      } catch (e) {
        // Handle other unexpected errors
        print('Unexpected error: $e');
        return ApiResponse<T>(statusCode: statusCode, error: e.toString());
      }
    } else {
      return ApiResponse<T>(statusCode: statusCode, error: 'Request failed with status code: $statusCode');
    }
  }
}