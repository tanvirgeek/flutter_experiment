import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_experiment/core/error/exceptions.dart';

abstract interface class ApiClient {
  Future<Response> post(String path, {dynamic data});
}

class DioApiClient implements ApiClient {
  final Dio dio;

  DioApiClient(this.dio);

  @override
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await dio.post(path, data: data);
    } on DioException catch (e) {
      debugPrint(e.response.toString());
      if (e.response != null &&
          e.response!.data != null &&
          e.response!.data["message"] != null) {
        throw ServerException(e.response!.data["message"]);
      }

      throw ServerException("Something went wrong!");
    } catch (_) {
      debugPrint("Here");
      throw ServerException("Something went wrong!");
    }
  }
}
