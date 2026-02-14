import 'package:dio/dio.dart';
import 'package:flutter_experiment/core/validator/validators.dart';
import 'package:flutter_experiment/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/refresh_token_usecase.dart';

class DioSingleton {
  static final DioSingleton _instance = DioSingleton._internal();
  late final Dio dio;

  factory DioSingleton() => _instance;

  DioSingleton._internal() {
    dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
  }
}

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource localDataSource;
  final RefreshTokenUsecase refreshTokenUseCase;
  final Dio dio;

  AuthInterceptor({
    required this.localDataSource,
    required this.refreshTokenUseCase,
    required this.dio,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await localDataSource.getAccessToken();
    if (token != null && !isTokenExpired(token)) {
      options.headers["Authorization"] = "Bearer $token";
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 errors
    if (err.response?.statusCode == 401) {
      final refreshToken = await localDataSource.getRefreshToken();

      if (refreshToken != null && !isTokenExpired(refreshToken)) {
        try {
          final newTokens = await refreshTokenUseCase.call(
            refreshToken: refreshToken,
          );
          await localDataSource.saveTokens(
            accessToken: newTokens.accessToken,
            refreshToken: newTokens.refreshToken,
          );

          // Retry original request with new access token
          final opts = err.requestOptions;
          opts.headers["Authorization"] = "Bearer ${newTokens.accessToken}";

          final response = await dio.fetch(opts);
          return handler.resolve(response);
        } catch (_) {
          // Refresh failed → logout
          await localDataSource.clearTokens();
          return handler.reject(err);
        }
      } else {
        // Refresh token missing or expired → logout
        await localDataSource.clearTokens();
        return handler.reject(err);
      }
    }

    handler.next(err); // Pass other errors
  }
}
