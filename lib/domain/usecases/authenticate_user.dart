import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

class AuthenticateUser {
  final AuthRepository repository;

  AuthenticateUser(this.repository);

  Future<Either<Failure, String>> call({
    required String apiKey,
    required String refreshToken,
  }) async {
    if (apiKey.trim().isEmpty) {
      return const Left(AuthFailure('API Key cannot be empty'));
    }
    if (refreshToken.trim().isEmpty) {
      return const Left(AuthFailure('Refresh Token cannot be empty'));
    }

    final saveResult = await repository.saveCredentials(
      apiKey: apiKey,
      refreshToken: refreshToken,
    );

    if (saveResult.isLeft()) {
      return Left(saveResult.fold((l) => l, (r) => const CacheFailure('Failed to save')));
    }

    return repository.authenticate(
      apiKey: apiKey,
      refreshToken: refreshToken,
    );
  }
}