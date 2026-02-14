import 'package:flutter_experiment/features/auth/data/models/register_response_model.dart';
import 'package:flutter_experiment/features/auth/domain/entities/register_response.dart';
import 'package:flutter_experiment/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_experiment/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RegisterUsecaseImpl useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterUsecaseImpl(authRepo: mockRepository);
  });

  const email = "test@gmail.com";
  const password = "123456";
  const name = "John";

  final entity = RegisterResponse(message: "Success");
  final data = RegisterRequestModel(
    email: email,
    password: password,
    name: name,
  );

  test("calls repository and returns entity", () async {
    when(
      () => mockRepository.register(data: data),
    ).thenAnswer((_) async => entity);

    final result = await useCase(email: email, password: password, name: name);

    expect(result.message, "Success");
    verify(() => mockRepository.register(data: data)).called(1);
  });
}
