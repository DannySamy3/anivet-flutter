import 'package:annivet/core/services/api_service.dart';
import 'package:annivet/features/pet/domain/entities/pet.dart';
import '../models/pet_dto.dart';

class PetRepository {
  final ApiService _apiService;

  PetRepository(this._apiService);

  // Get all pets (user's own or all for owners)
  Future<List<Pet>> getPets() async {
    final response = await _apiService.get('pets');
    final dynamic data = response.data;
    final List<dynamic> petsJson =
        (data is Map && data.containsKey('data')) ? data['data'] : data;
    return petsJson
        .map((json) => PetDto.fromJson(json as Map<String, dynamic>).toEntity())
        .toList();
  }

  // Get single pet by ID
  Future<Pet> getPetById(String id) async {
    final response = await _apiService.get('pets/$id');
    final dynamic data = response.data;
    final Map<String, dynamic> petJson =
        (data is Map && data.containsKey('data')) ? data['data'] : data;
    return PetDto.fromJson(petJson).toEntity();
  }

  // Create pet
  Future<Pet> createPet(Pet pet) async {
    final dto = PetDto.fromEntity(pet);
    final response = await _apiService.post('pets', data: dto.toJson());
    final dynamic data = response.data;
    final Map<String, dynamic> petJson =
        (data is Map && data.containsKey('data')) ? data['data'] : data;
    return PetDto.fromJson(petJson).toEntity();
  }

  // Update pet
  Future<Pet> updatePet(String id, Pet pet) async {
    final dto = PetDto.fromEntity(pet);
    final response = await _apiService.put('pets/$id', data: dto.toJson());
    final dynamic data = response.data;
    final Map<String, dynamic> petJson =
        (data is Map && data.containsKey('data')) ? data['data'] : data;
    return PetDto.fromJson(petJson).toEntity();
  }

  // Delete pet
  Future<void> deletePet(String id) async {
    await _apiService.delete('pets/$id');
  }

  // Upload pet photo
  Future<String> uploadPhoto(String petId, String filePath) async {
    final response = await _apiService.upload(
      '/pets/$petId/photo',
      filePath,
      'photo',
    );
    return response.data['photoUrl'] as String;
  }

  // Get pet history
  Future<List<PetHistory>> getPetHistory(String petId) async {
    final response = await _apiService.get('/pets/$petId/history');
    // TODO: Create PetHistoryDto and parse
    return [];
  }
}
