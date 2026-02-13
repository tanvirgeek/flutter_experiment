import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_experiment/core/error/exceptions.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_experiment/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_experiment/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUsecase registerUseCase;

  AuthBloc(this.registerUseCase) : super(AuthInitial()) {
    on<RegisterRequested>(_onRegister);
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
