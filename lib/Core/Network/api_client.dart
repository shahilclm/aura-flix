import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  String? _token; // Store token manually

  // Constructor to accept an existing token
  ApiClient({String? token}) {
    _token = token;
  }

  // Update Token Manually
  void setToken(String token) {
    _token = token;
  }

  // Attach Token to Headers
  Options _getOptions() {
    return Options(
      headers: {
        "Authorization": _token != null ? "Bearer $_token" : "",
        "Content-Type": "application/json",
      },
    );
  }

  // GET request
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      Response response = await _dio.get(endpoint, queryParameters: queryParams, options: _getOptions());
      return response.data;
    } catch (e) {
      throw Exception("GET request failed: $e");
    }
  }



}
