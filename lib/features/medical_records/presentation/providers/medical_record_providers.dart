import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annivet/features/medical_records/data/repositories/medical_record_repository.dart';
import 'package:annivet/features/medical_records/domain/entities/medical_record.dart';
import 'package:annivet/features/medical_records/data/dtos/medical_record_dto.dart';
import 'package:annivet/core/services/api_service.dart';
import 'package:annivet/core/services/storage_service.dart';

// Repository provider
final medicalRecordRepositoryProvider =
    Provider<MedicalRecordRepository>((ref) {
  final apiService = ApiService(StorageService());
  return MedicalRecordRepository(apiService);
});

// ============ QUERIES ============

/// Fetch all medical records for a specific pet
final medicalRecordsByPetProvider =
    FutureProvider.family<List<MedicalRecord>, String>((ref, petId) async {
  final repository = ref.watch(medicalRecordRepositoryProvider);
  return repository.getMedicalRecordsByPet(petId);
});

/// Fetch single medical record
final medicalRecordDetailProvider =
    FutureProvider.family<MedicalRecord, String>((ref, recordId) async {
  final repository = ref.watch(medicalRecordRepositoryProvider);
  return repository.getMedicalRecordById(recordId);
});

/// Get overdue medical records for a pet
final overdueRecordsProvider =
    FutureProvider.family<List<MedicalRecord>, String>((ref, petId) async {
  final repository = ref.watch(medicalRecordRepositoryProvider);
  return repository.getOverdueRecords(petId);
});

/// Get upcoming records (due within 7 days) for a pet
final upcomingRecordsProvider =
    FutureProvider.family<List<MedicalRecord>, String>((ref, petId) async {
  final repository = ref.watch(medicalRecordRepositoryProvider);
  return repository.getUpcomingRecords(petId);
});

/// Get records needing attention (overdue or due soon)
final recordsNeedingAttentionProvider =
    FutureProvider.family<List<MedicalRecord>, String>((ref, petId) async {
  final repository = ref.watch(medicalRecordRepositoryProvider);
  return repository.getRecordsNeedingAttention(petId);
});

/// Get all user's medical records across all pets with optional filters
final userMedicalRecordsProvider =
    FutureProvider<List<MedicalRecord>>((ref) async {
  final repository = ref.watch(medicalRecordRepositoryProvider);
  return repository.getUserMedicalRecords();
});

/// Filtered medical records provider
final filteredMedicalRecordsProvider = FutureProvider.family<
    List<MedicalRecord>,
    ({String? type, bool? isOverdue})>((ref, filters) async {
  final repository = ref.watch(medicalRecordRepositoryProvider);
  return repository.getUserMedicalRecords(
    type: filters.type,
    isOverdue: filters.isOverdue,
  );
});

// ============ MUTATIONS ============

/// Create medical record
final createMedicalRecordProvider = FutureProvider.family<MedicalRecord,
    ({String petId, MedicalRecordDto dto})>((ref, params) async {
  final repository = ref.watch(medicalRecordRepositoryProvider);
  final record = await repository.createMedicalRecord(params.petId, params.dto);
  // Refresh the pet's records after creation
  await ref.refresh(medicalRecordsByPetProvider(params.petId));
  await ref.refresh(userMedicalRecordsProvider);
  return record;
});

/// Update medical record
final updateMedicalRecordProvider = FutureProvider.family<MedicalRecord,
    ({String recordId, Map<String, dynamic> updates})>((ref, params) async {
  final repository = ref.watch(medicalRecordRepositoryProvider);
  final record = await repository.updateMedicalRecord(
    params.recordId,
    params.updates,
  );
  // Refresh related providers
  await ref.refresh(medicalRecordDetailProvider(params.recordId));
  await ref.refresh(userMedicalRecordsProvider);
  return record;
});

/// Delete medical record
final deleteMedicalRecordProvider =
    FutureProvider.family<void, String>((ref, recordId) async {
  final repository = ref.watch(medicalRecordRepositoryProvider);
  await repository.deleteMedicalRecord(recordId);
  // Refresh related providers
  await ref.refresh(userMedicalRecordsProvider);
});
