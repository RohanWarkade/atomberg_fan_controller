import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> authenticate({
    required String apiKey,
    required String refreshToken,
  });

  Future<Either<Failure, String>> getValidAccessToken();

  Future<Either<Failure, void>> saveCredentials({
    required String apiKey,
    required String refreshToken,
  });

  Future<Either<Failure, bool>> hasValidCredentials();

  Future<Either<Failure, void>> clearCredentials();
}
