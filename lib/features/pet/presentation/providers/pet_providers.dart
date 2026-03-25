import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annivet/features/pet/data/repositories/pet_repository.dart';
import 'package:annivet/features/pet/domain/entities/pet.dart';
import 'package:annivet/features/pet/domain/entities/appointment.dart';
import 'package:annivet/core/constants/app_enums.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';
import 'package:annivet/core/services/mock_data_service.dart';

// Repository provider
final petRepositoryProvider = Provider<PetRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PetRepository(apiService);
});

// ============ QUERIES ============

/// Fetch my pets (for customers)
final myPetsProvider = FutureProvider<List<Pet>>((ref) async {
  // Using mock data for development
  final mockPets = MockDataService.getMockPets();
  return mockPets.map((dto) => dto.toEntity()).toList();
});

/// Fetch all pets (for admin)
final allPetsProvider = FutureProvider<List<Pet>>((ref) async {
  // Using mock data for development
  final mockPets = MockDataService.getMockPets();
  return mockPets.map((dto) => dto.toEntity()).toList();
});

/// Fetch pet by ID
final petDetailProvider =
    FutureProvider.family<Pet, String>((ref, petId) async {
  // Using mock data for development
  final mockPet = MockDataService.getMockPetDetail(petId);
  if (mockPet == null) {
    throw Exception('Pet not found');
  }
  return mockPet.toEntity();
});

/// Create pet mutation handler
final createPetProvider = FutureProvider.family<Pet, Pet>((ref, pet) async {
  final repository = ref.watch(petRepositoryProvider);
  final createdPet = await repository.createPet(pet);
  ref.invalidate(myPetsProvider);
  return createdPet;
});

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

/// Fetch upcoming appointments for a specific pet
/// Only some pets have scheduled appointments (mock data)
final upcomingAppointmentsProvider =
    FutureProvider.family<List<Appointment>, String>((ref, petId) async {
  // Mock data: simulate some pets having appointments and others not
  final mockAppointments = <String, List<Appointment>>{
    'pet-uuid-001': [
      Appointment(
        id: 'apt-1',
        petId: 'pet-uuid-001',
        title: 'Annual Checkup',
        description: 'Routine health examination',
        scheduledDate: DateTime.now().add(const Duration(days: 5)),
        veterinarian: 'Dr. Sarah Smith',
        location: 'Happy Paws Clinic',
        type: 'checkup',
        createdAt: DateTime.now(),
      ),
      Appointment(
        id: 'apt-2',
        petId: 'pet-uuid-001',
        title: 'Vaccination Booster',
        description: 'Rabies and DHPP booster shots',
        scheduledDate: DateTime.now().add(const Duration(days: 12)),
        veterinarian: 'Dr. Sarah Smith',
        location: 'Happy Paws Clinic',
        type: 'vaccination',
        createdAt: DateTime.now(),
      ),
    ],
    'pet-uuid-003': [
      Appointment(
        id: 'apt-3',
        petId: 'pet-uuid-003',
        title: 'Teeth Cleaning',
        description: 'Professional dental cleaning and examination',
        scheduledDate: DateTime.now().add(const Duration(days: 3)),
        veterinarian: 'Dr. Mike Johnson',
        location: 'Dental Pet Care',
        type: 'checkup',
        createdAt: DateTime.now(),
      ),
    ],
  };

  return mockAppointments[petId] ?? [];
});
