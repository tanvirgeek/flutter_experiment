import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_experiment/core/error/exceptions.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_experiment/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_experiment/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUsecase registerUseCase;
  final LoginUsecase loginUsecase;
  final CheckAuthUseCase checkAuthUseCase;

  AuthBloc({
    required this.loginUsecase,
    required this.registerUseCase,
    required this.checkAuthUseCase,
  }) : super(AuthInitial()) {
    on<RegisterRequested>(_onRegister);
    on<LoginRequested>(_onLogin);

    on<CheckAuthStatusEvent>(_onCheckAuthenticated);
  }

  Future<void> _onCheckAuthenticated(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final isLoggedIn = await checkAuthUseCase.call();

    if (isLoggedIn) {
      emit(AuthenticatedState());
    } else {
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
}
