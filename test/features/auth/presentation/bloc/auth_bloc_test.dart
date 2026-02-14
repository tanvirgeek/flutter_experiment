import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_experiment/core/error/exceptions.dart';
import 'package:flutter_experiment/features/auth/domain/entities/register_response.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_experiment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_experiment/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_experiment/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUseCase extends Mock implements RegisterUsecase {}

class MockLoginUseCase extends Mock implements LoginUsecase {}

class MockCheckAuthUsecase extends Mock implements CheckAuthUseCase {}

void main() {
  late AuthBloc bloc;
  late MockRegisterUseCase mockUseCase;
  late MockLoginUseCase mockLoginUseCase;
  late MockCheckAuthUsecase mockCheckAuthUseCase;

  setUp(() {
    mockUseCase = MockRegisterUseCase();
    mockLoginUseCase = MockLoginUseCase();
    mockCheckAuthUseCase = MockCheckAuthUsecase();
    bloc = AuthBloc(
      loginUsecase: mockLoginUseCase,
      registerUseCase: mockUseCase,
      checkAuthUseCase: mockCheckAuthUseCase,
    );
  });

  const email = "test@gmail.com";
  const password = "123456";
  const name = "John";

  final entity = RegisterResponse(message: "Success");

  blocTest<AuthBloc, AuthState>(
    "emits [Loading, Success] when registration succeeds",
    build: () {
      when(
        () => mockUseCase(email: email, password: password, name: name),
      ).thenAnswer((_) async => entity);
      return bloc;
    },
    act: (bloc) => bloc.add(
      RegisterRequested(email: email, password: password, name: name),
    ),
    expect: () => [isA<AuthLoading>(), isA<AuthSuccess>()],
  );

  blocTest<AuthBloc, AuthState>(
    "emits [Loading, Failure] when registration fails",
    build: () {
      when(
        () => mockUseCase(email: email, password: password, name: name),
      ).thenThrow(ServerException("Something went wrong!"));
      return bloc;
    },
    act: (bloc) => bloc.add(
      RegisterRequested(email: email, password: password, name: name),
    ),
    expect: () => [isA<AuthLoading>(), isA<AuthFailure>()],
  );
}
