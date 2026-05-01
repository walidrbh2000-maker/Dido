import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyageur/core/network/api_client.dart';
import 'package:voyageur/core/storage/secure_storage.dart';
import 'package:voyageur/data/datasources/remote/auth_remote_datasource.dart';
import 'package:voyageur/data/repositories/auth_repository.dart';
import 'package:voyageur/domain/entities/user_entity.dart';
import 'package:voyageur/domain/usecases/auth/login_usecase.dart';
import 'package:voyageur/domain/usecases/auth/logout_usecase.dart';
import 'package:voyageur/domain/usecases/auth/register_usecase.dart';
import 'package:voyageur/providers/auth/auth_state.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(secureStorage: ref.watch(secureStorageProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    remoteDatasource: AuthRemoteDatasource(
      apiClient: ref.watch(apiClientProvider),
    ),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUsecase>((ref) {
  return LoginUsecase(repository: ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUsecase>((ref) {
  return RegisterUsecase(repository: ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUsecase>((ref) {
  return LogoutUsecase(repository: ref.watch(authRepositoryProvider));
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUsecase: ref.watch(loginUseCaseProvider),
    registerUsecase: ref.watch(registerUseCaseProvider),
    logoutUsecase: ref.watch(logoutUseCaseProvider),
    authRepository: ref.watch(authRepositoryProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUsecase _loginUsecase;
  final RegisterUsecase _registerUsecase;
  final LogoutUsecase _logoutUsecase;
  final AuthRepository _authRepository;

  AuthNotifier({
    required LoginUsecase loginUsecase,
    required RegisterUsecase registerUsecase,
    required LogoutUsecase logoutUsecase,
    required AuthRepository authRepository,
  })  : _loginUsecase = loginUsecase,
        _registerUsecase = registerUsecase,
        _logoutUsecase = logoutUsecase,
        _authRepository = authRepository,
        super(const AuthState.initial());

  Future<void> checkAuth() async {
    final isAuth = await _authRepository.isAuthenticated();
    if (isAuth) {
      final result = await _authRepository.getMe();
      result.fold(
        (l) => state = const AuthState.unauthenticated(),
        (user) => state = AuthState.authenticated(_mapUser(user)),
      );
    } else {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    final result = await _loginUsecase(email: email, password: password);
    result.fold(
      (error) => state = AuthState.error(_mapError(error)),
      (user) => state = AuthState.authenticated(user),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    state = const AuthState.loading();
    final result = await _registerUsecase(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    result.fold(
      (error) => state = AuthState.error(_mapError(error)),
      (user) => state = AuthState.authenticated(user),
    );
  }

  Future<void> logout() async {
    await _logoutUsecase();
    state = const AuthState.unauthenticated();
  }

  UserEntity _mapUser(dynamic user) {
    return UserEntity(
      id: user.id as int,
      name: user.name as String,
      email: user.email as String,
      phone: user.phone as String?,
      role: user.role as String,
    );
  }

  String _mapError(dynamic error) {
    return error.when(
      network: (msg) => msg,
      unauthorized: () => 'Non autorisé',
      notFound: (r) => 'Ressource introuvable',
      serverError: (msg) => msg,
      validation: (errors) => errors.values.first.first,
      unknown: (_) => 'Une erreur est survenue',
    );
  }
}
