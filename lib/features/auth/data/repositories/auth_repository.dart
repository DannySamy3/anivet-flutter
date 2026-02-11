import 'package:annivet/core/services/api_service.dart';
import 'package:annivet/core/services/storage_service.dart';
import 'package:annivet/features/auth/domain/entities/user.dart';
import '../models/auth_request.dart';
import '../models/user_dto.dart';

class AuthRepository {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthRepository(this._apiService, this._storageService);

  // Login
  Future<User> login(LoginRequest request) async {
    final response = await _apiService.post(
      '/auth/login',
      data: request.toJson(),
    );

    final authResponse = AuthResponse.fromJson(response.data);

    // Save token and user data
    await _storageService.saveToken(authResponse.token);
    await _storageService.saveUser(authResponse.user);

    // Convert to User entity
    final userDto = UserDto.fromJson(authResponse.user);
    return userDto.toEntity();
  }

  // Register
  Future<User> register(RegisterRequest request) async {
    final response = await _apiService.post(
      '/auth/register',
      data: request.toJson(),
    );

    final authResponse = AuthResponse.fromJson(response.data);

    // Save token and user data
    await _storageService.saveToken(authResponse.token);
    await _storageService.saveUser(authResponse.user);

    // Convert to User entity
    final userDto = UserDto.fromJson(authResponse.user);
    return userDto.toEntity();
  }

  // Get current user from API
  Future<User> getCurrentUser() async {
    final response = await _apiService.get('/auth/me');

    final userDto = UserDto.fromJson(response.data);

    // Update stored user data
    await _storageService.saveUser(response.data);

    return userDto.toEntity();
  }

  // Get current user from storage
  Future<User?> getCurrentUserFromStorage() async {
    final userData = await _storageService.getUser();
    if (userData == null) return null;

    final userDto = UserDto.fromJson(userData);
    return userDto.toEntity();
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _storageService.getToken();
    return token != null;
  }

  // Logout
  Future<void> logout() async {
    await _storageService.clearAll();
  }
}
