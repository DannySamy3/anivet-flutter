import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annivet/core/services/api_service.dart';
import 'package:annivet/core/services/storage_service.dart';
import 'package:annivet/features/auth/data/repositories/auth_repository.dart';
import 'package:annivet/features/auth/domain/entities/user.dart';
import 'package:annivet/features/auth/data/models/auth_request.dart';

// Providers for services
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ApiService(storageService);
});

// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  return AuthRepository(apiService, storageService);
});

// Auth state provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

// Current user provider (convenience)
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.user;
});

// Is authenticated provider (convenience)
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.user != null;
});

// Auth state class
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isAuthenticated => user != null;
}

// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState()) {
    _checkAuth();
  }

  // Check authentication on init
  Future<void> _checkAuth() async {
    try {
      final user = await _repository.getCurrentUserFromStorage();
      if (user != null) {
        state = state.copyWith(user: user);

        // Validate token by fetching fresh user data
        try {
          final freshUser = await _repository.getCurrentUser();
          state = state.copyWith(user: freshUser);
        } catch (e) {
          // Token expired or invalid, logout
          await logout();
        }
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _repository.login(
        LoginRequest(email: email, password: password),
      );
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      rethrow;
    }
  }

  // Register
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _repository.register(
        RegisterRequest(
          name: name,
          email: email,
          password: password,
          phone: phone,
          role: role,
        ),
      );
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState();
  }

  // Refresh user data
  Future<void> refreshUser() async {
    try {
      final user = await _repository.getCurrentUser();
      state = state.copyWith(user: user);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
