import 'package:auraflixx/Support/dio_helper.dart';
import 'package:auraflixx/Support/logger.dart';

import '../Networking/constant.dart';

class MovieApi {
  static Future getTrendingMovie() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$trendingMovie+api_key=$apiKey');
    print(response);
    return response.data;
  }

  static Future getRelatedMovie({required int id}) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$relatedMovie/$id/similar?api_key=$apiKey');
    log.i(response);
    return response.data;
  }

  static Future searchMovie({required String search}) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get(
      '$searchMovieName',
      queryParameters: {
        "api_key": apiKey,
        "query": search,
      },
    );
    log.i(response);
    return response.data;
  }

  static Future detailsMovie({required int id}) async {
    var dio = await DioHelper.getInstance();
    var response = await dio
        .get('$detailsMovies/$id', queryParameters: {"api_key": apiKey});

    log.i(response);
    return response.data;
  }

  static Future getCast({required int id}) async {
    var dio = await DioHelper.getInstance();
    var response =
        await dio.get('$baseUrl/$id/credits', queryParameters: {"api_key": apiKey});
    print(response);
    return response.data;
  }
}
