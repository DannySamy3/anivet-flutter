import 'package:annivet/core/constants/app_enums.dart';

class Pet {
  final String id;
  final String name;
  final PetSpecies species;
  final String breed;
  final int age;
  final String ownerId;
  final String? photoUrl;
  final String? gender;
  final String? color;
  final double? weight;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.ownerId,
    this.photoUrl,
    this.gender,
    this.color,
    this.weight,
    required this.createdAt,
    this.updatedAt,
  });

  Pet copyWith({
    String? id,
    String? name,
    PetSpecies? species,
    String? breed,
    int? age,
    String? ownerId,
    String? photoUrl,
    String? gender,
    String? color,
    double? weight,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      ownerId: ownerId ?? this.ownerId,
      photoUrl: photoUrl ?? this.photoUrl,
      gender: gender ?? this.gender,
      color: color ?? this.color,
      weight: weight ?? this.weight,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PetHistory {
  final String id;
  final String petId;
  final HistoryType type;
  final String description;
  final DateTime date;
  final DateTime createdAt;

  const PetHistory({
    required this.id,
    required this.petId,
    required this.type,
    required this.description,
    required this.date,
    required this.createdAt,
  });
}
