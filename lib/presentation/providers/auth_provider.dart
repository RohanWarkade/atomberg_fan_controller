import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/errors/failure.dart';
import '../../domain/usecases/authenticate_user.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'repository_providers.dart';

// Auth State
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthenticateUser authenticateUser;
  final AuthRepositoryImpl authRepository;

  AuthNotifier({
    required this.authenticateUser,
    required this.authRepository,
  }) : super(const AuthState());

  Future<bool> authenticate({
    required String apiKey,
    required String refreshToken,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await authenticateUser(
      apiKey: apiKey,
      refreshToken: refreshToken,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          error: _mapFailureToMessage(failure),
        );
        return false;
      },
      (accessToken) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          error: null,
        );
        return true;
      },
    );
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    final result = await authRepository.hasValidCredentials();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
        );
      },
      (hasCredentials) async {
        if (hasCredentials) {
          // Try to get valid access token
          final tokenResult = await authRepository.getValidAccessToken();
          state = state.copyWith(
            isLoading: false,
            isAuthenticated: tokenResult.isRight(),
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            isAuthenticated: false,
          );
        }
      },
    );
  }

  Future<void> logout() async {
    await authRepository.clearCredentials();
    state = const AuthState();
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Network error. Please check your connection.';
    } else if (failure is AuthFailure) {
      return 'Authentication failed. Please check your credentials.';
    } else if (failure is ServerFailure) {
      return 'Server error. Please try again later.';
    } else {
      return 'An unexpected error occurred.';
    }
  }
}

// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    authenticateUser: ref.read(authenticateUserProvider),
    authRepository: ref.read(authRepositoryProvider) as AuthRepositoryImpl,
  );
});
