import 'package:dio/dio.dart';
import 'package:flutter_experiment/core/error/exceptions.dart';
import 'package:flutter_experiment/core/network/api_client.dart';
import 'package:flutter_experiment/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_experiment/features/auth/data/models/register_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late AuthRemoteDatasourceImpl datasource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = AuthRemoteDatasourceImpl(apiClient: mockApiClient);
  });

  const email = "test@gmail.com";
  const password = "123456";
  const name = "John";

  final responseData = {"message": "Registered successfully"};

  test("returns RegisterResponseModel on success", () async {
    when(() => mockApiClient.post(any(), data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ''),
        data: responseData,
        statusCode: 200,
      ),
    );

    final result = await datasource.register(
      data: RegisterRequestModel(email: email, password: password, name: name),
    );

    expect(result, isA<RegisterResponseModel>());
    expect(result.message, "Registered successfully");
  });

  test("throws ServerException on failure", () async {
    when(
      () => mockApiClient.post(any(), data: any(named: 'data')),
    ).thenThrow(ServerException("Something went wrong!"));

    expect(
      () => datasource.register(
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
