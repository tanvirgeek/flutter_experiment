import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_experiment/core/error/exceptions.dart';
import 'package:flutter_experiment/core/validator/validators.dart';
import 'package:flutter_experiment/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUsecase registerUseCase;
  final LoginUsecase loginUsecase;
  final CheckAuthUseCase checkAuthUseCase;
  final RefreshTokenUsecase refreshTokenUsecase;
  final AuthLocalDataSource localDataSource;
  final LogoutUsecase logoutUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.registerUseCase,
    required this.checkAuthUseCase,
    required this.refreshTokenUsecase,
    required this.localDataSource,
    required this.logoutUsecase,
  }) : super(AuthInitial()) {
    on<RegisterRequested>(_onRegister);
    on<LoginRequested>(_onLogin);
    on<CheckAuthStatusEvent>(_onCheckAuthenticated);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final refreshToken = await localDataSource.getRefreshToken();
    await logoutUsecase.call(refreshToken: refreshToken);
    await localDataSource.clearTokens();
    emit(OnLogoutSuccess());
  }

  Future<void> _onCheckAuthenticated(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final accessToken = await localDataSource.getAccessToken();
      final refreshToken = await localDataSource.getRefreshToken();

      if (accessToken != null && !isTokenExpired(accessToken)) {
        // ✅ Access token valid
        emit(AuthenticatedState());
        return;
      }

      if (refreshToken != null && !isTokenExpired(refreshToken)) {
        // 🔄 Access token expired but refresh token valid → refresh
        try {
          final newTokens = await refreshTokenUsecase.call(
            refreshToken: refreshToken,
          );
          await localDataSource.saveTokens(
            accessToken: newTokens.accessToken,
            refreshToken: newTokens.refreshToken,
          );
          emit(AuthenticatedState());
          return;
        } catch (_) {
          // Refresh failed
          await localDataSource.clearTokens();
          emit(UnauthenticatedState());
          return;
        }
      }

      // ❌ Both tokens missing or expired
      await localDataSource.clearTokens();
      emit(UnauthenticatedState());
    } catch (_) {
      emit(UnauthenticatedState());
    }
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final _ = await loginUsecase.call(
        email: event.email,
        password: event.password,
      );
      emit(LoginSuccess());
    } on ServerException catch (e) {
      emit(AuthFailure(e.message));
    } catch (_) {
      emit(AuthFailure("Something went wrong!"));
    }
  }

  Future<void> _onRegister(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await registerUseCase(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      emit(AuthSuccess(response.message));
    } on ServerException catch (e) {
      emit(AuthFailure(e.message));
    } catch (_) {
      emit(AuthFailure("Something went wrong!"));
    }
  }

  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final tokens = await refreshTokenUsecase.call(
        refreshToken: event.refreshToken,
      );
      emit(
        TokenRefreshedState(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
        ),
      );
    } on ServerException catch (e) {
      emit(AuthFailure(e.message));
    } catch (_) {
      emit(AuthFailure("Unable to refresh token"));
    }
  }
}
