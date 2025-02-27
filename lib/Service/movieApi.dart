import 'package:auraflixx/Support/dio_helper.dart';

import '../Networking/constant.dart';

class MovieApi {
static Future getTrendingMovie()async{
  var dio=await DioHelper.getInstance();
  var response=await dio.get('$trendingMovie+api_key=$apiKey');
  print(response);
  return response.data;
}
static Future getRelatedMovie({required int id})async{
  var dio=await DioHelper.getInstance();
  var response=await dio.get('$relatedMovie/$id/similar?api_key=$apiKey');
  print(response);
  return response.data;
}
}