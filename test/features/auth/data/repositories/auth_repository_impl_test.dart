import 'package:flutter_experiment/core/error/exceptions.dart';
import 'package:flutter_experiment/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_experiment/features/auth/data/models/register_response_model.dart';
import 'package:flutter_experiment/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockRemoteDataSource();
    repository = AuthRepositoryImpl(remoteDataSource: mockDataSource);
  });

  const email = "test@gmail.com";
  const password = "123456";
  const name = "John";

  final model = RegisterResponseModel(message: "Success");

  test("returns RegisterResponse when datasource succeeds", () async {
    when(
      () => mockDataSource.register(
        data: RegisterRequestModel(
          email: email,
          password: password,
          name: name,
        ),
      ),
    ).thenAnswer((_) async => model);

    final result = await repository.register(
      data: RegisterRequestModel(email: email, password: password, name: name),
    );

    expect(result.message, "Success");
    verify(
      () => mockDataSource.register(
        data: RegisterRequestModel(
          email: email,
          password: password,
          name: name,
        ),
      ),
    ).called(1);
  });

  test("throws exception when datasource fails", () async {
    when(
      () => mockDataSource.register(
        data: RegisterRequestModel(
          email: email,
          password: password,
          name: name,
        ),
      ),
    ).thenThrow(ServerException("Something went wrong!"));

    expect(
      () => repository.register(
        data: RegisterRequestModel(
          email: email,
          password: password,
          name: name,
        ),
      ),
      throwsA(isA<ServerException>()),
    );
  });
}
