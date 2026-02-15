import 'package:dio/dio.dart';
import 'package:flutter_experiment/core/error/exceptions.dart';

abstract interface class ApiClient {
  Future<Response> post(String path, {dynamic data});
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters});
}

class DioApiClient implements ApiClient {
  final Dio dio;

  DioApiClient(this.dio);

  @override
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await dio.post(path, data: data);
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Never _handleError(DioException e) {
    if (e.response != null &&
        e.response!.data != null &&
        e.response!.data["error"] != null) {
      throw ServerException(e.response!.data["error"]);
    }
    throw ServerException("Something went wrong!");
  }
}
