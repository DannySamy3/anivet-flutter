import 'package:annivet/core/constants/app_enums.dart';
import 'package:annivet/features/auth/domain/entities/user.dart';

class UserDto {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String role;
  final String? clinicId;
  final String createdAt;
  final String? updatedAt;

  const UserDto({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.role,
    this.clinicId,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      clinicId: json['clinicId'] as String?,
      createdAt:
          json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      'clinicId': clinicId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      phone: phone,
      role: UserRoleExtension.fromString(role),
      clinicId: clinicId,
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }
}
