import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annivet/features/pet/data/repositories/pet_repository.dart';
import 'package:annivet/features/pet/domain/entities/pet.dart';
import 'package:annivet/core/constants/app_enums.dart';
import 'package:annivet/core/services/api_service.dart';
import 'package:annivet/core/services/storage_service.dart';

// Repository provider
final petRepositoryProvider = Provider<PetRepository>((ref) {
  final apiService = ApiService(StorageService());
  return PetRepository(apiService);
});

// ============ QUERIES ============

/// Fetch my pets (for customers)
final myPetsProvider = FutureProvider<List<Pet>>((ref) async {
  final repository = ref.watch(petRepositoryProvider);
  return repository.getPets();
});

/// Fetch all pets (for admin)
final allPetsProvider = FutureProvider<List<Pet>>((ref) async {
  final repository = ref.watch(petRepositoryProvider);
  return repository.getPets();
});

/// Fetch pet by ID
final petDetailProvider =
    FutureProvider.family<Pet, String>((ref, petId) async {
  final repository = ref.watch(petRepositoryProvider);
  return repository.getPetById(petId);
});

// ============ MUTATIONS ============

/// Create pet mutation handler
final createPetProvider = FutureProvider.family<Pet, Pet>((ref, pet) async {
  final repository = ref.watch(petRepositoryProvider);
  final newPet = await repository.createPet(pet);
  ref.invalidate(myPetsProvider);
  return newPet;
});

/// Update pet mutation handler
final updatePetProvider =
    FutureProvider.family<Pet, Map<String, dynamic>>((ref, variables) async {
  final repository = ref.watch(petRepositoryProvider);
  final petId = variables['id'] as String;
  final updatedPet = await repository.updatePet(
      petId,
      Pet(
        id: petId,
        name: variables['name'] as String,
        species: variables['species'] as PetSpecies,
        breed: variables['breed'] as String,
        age: variables['age'] as int,
        ownerId: variables['ownerId'] as String,
        gender: variables['gender'] as String?,
        color: variables['color'] as String?,
        weight: variables['weight'] as double?,
        createdAt: variables['createdAt'] as DateTime,
      ));
  ref.invalidate(myPetsProvider);
  ref.invalidate(petDetailProvider(petId));
  return updatedPet;
});

/// Delete pet mutation handler
final deletePetProvider =
    FutureProvider.family<void, String>((ref, petId) async {
  final repository = ref.watch(petRepositoryProvider);
  await repository.deletePet(petId);
  // Invalidate queries
  ref.invalidate(myPetsProvider);
  ref.invalidate(allPetsProvider);
});

/// Upload pet photo mutation handler
final uploadPetPhotoProvider =
    FutureProvider.family<String, Map<String, dynamic>>((ref, variables) async {
  final repository = ref.watch(petRepositoryProvider);
  final petId = variables['petId'] as String;
  final filePath = variables['filePath'] as String;
  final imageUrl = await repository.uploadPhoto(petId, filePath);
  ref.invalidate(myPetsProvider);
  ref.invalidate(petDetailProvider(petId));
  return imageUrl;
});
