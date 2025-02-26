import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logger.dart';

class DioHelper {
  static Future<Dio> getInstance() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = (prefs.getString('token') ?? "");
    // log.i(token);
    Dio dio = new Dio();
    const String token =
        "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwYWVmYWJmM2JiMDEzN2MyMDYyMzgzNzY0MTE4MWVkZCIsIm5iZiI6MTc0MDU1NTczNC4zNzEsInN1YiI6IjY3YmVjNWQ2NDFiYjE0ZjMwOTU2MTYzNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.IfxB_E1B-ZUZPdb9N2TK7QsiuhWx9p_cgO0DP5TusMg";
    dio.options.headers["Authorization"] = 'Bearer ${token}';
    dio.options.headers["Accept"] = "application/json";
    // dio.options.headers[''];
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log.d(
              'API call - ' + options.method + ' - ' + options.uri.toString());
          return handler.next(options);
        },
        onError: (e, handler) {
          if (e.response != null) {
            log.d(
                'API Error - ${e.response!.statusCode} - ${e.response!.statusMessage}');
            log.d(e.response!.data);
          }
          return handler.next(e);
        },
      ),
    );
    return dio;
  }
}
