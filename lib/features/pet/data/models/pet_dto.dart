import 'package:annivet/core/constants/app_enums.dart';
import 'package:annivet/features/pet/domain/entities/pet.dart';

class PetDto {
  final String id;
  final String name;
  final String species;
  final String breed;
  final int age;
  final String ownerId;
  final String? photoUrl;
  final String createdAt;
  final String? updatedAt;

  const PetDto({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.ownerId,
    this.photoUrl,
    required this.createdAt,
    this.updatedAt,
  });

  factory PetDto.fromJson(Map<String, dynamic> json) {
    return PetDto(
      id: json['id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      breed: json['breed'] as String,
      age: json['age'] as int,
      ownerId: json['ownerId'] as String,
      photoUrl: json['photoUrl'] as String?,
      createdAt:
          json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'species': species,
      'breed': breed,
      'age': age,
      'photoUrl': photoUrl,
    };
  }

  Pet toEntity() {
    return Pet(
      id: id,
      name: name,
      species: PetSpeciesExtension.fromString(species),
      breed: breed,
      age: age,
      ownerId: ownerId,
      photoUrl: photoUrl,
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  static PetDto fromEntity(Pet pet) {
    return PetDto(
      id: pet.id,
      name: pet.name,
      species: pet.species.value,
      breed: pet.breed,
      age: pet.age,
      ownerId: pet.ownerId,
      photoUrl: pet.photoUrl,
      createdAt: pet.createdAt.toIso8601String(),
      updatedAt: pet.updatedAt?.toIso8601String(),
    );
  }
}
