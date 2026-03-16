import 'package:annivet/core/constants/app_enums.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final UserRole role;
  final String? clinicId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.role,
    this.clinicId,
    required this.createdAt,
    this.updatedAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    UserRole? role,
    String? clinicId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      clinicId: clinicId ?? this.clinicId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role.value,
      'clinicId': clinicId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
