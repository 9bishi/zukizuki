import 'package:dio/dio.dart';


class ApiService {
  final Dio _dio;

  ApiService(String baseUrl)
      : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<Response> get(String path, {Map<String, dynamic>? params}) async {
    return _dio.get(path, queryParameters: params);
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    return _dio.post(path, data: data);
  }
}
