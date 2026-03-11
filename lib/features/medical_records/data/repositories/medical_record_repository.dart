import '../../../../core/services/api_service.dart';
import '../dtos/medical_record_dto.dart';
import '../../domain/entities/medical_record.dart';

class MedicalRecordRepository {
  final ApiService _apiService;

  MedicalRecordRepository(this._apiService);

  // GET /api/medical-records/pet/:petId - Get all records for a pet
  Future<List<MedicalRecord>> getMedicalRecordsByPet(String petId) async {
    final response = await _apiService.get('/medical-records/pet/$petId');
    final List<dynamic> data = response.data['data'] as List<dynamic>? ?? [];
    return data
        .map((json) => MedicalRecord.fromDto(
            MedicalRecordDto.fromJson(json as Map<String, dynamic>)))
        .toList();
  }

  // GET /api/medical-records/:recordId - Get single record
  Future<MedicalRecord> getMedicalRecordById(String recordId) async {
    final response = await _apiService.get('/medical-records/$recordId');
    final recordData = response.data['data'] as Map<String, dynamic>;
    return MedicalRecord.fromDto(MedicalRecordDto.fromJson(recordData));
  }

  // POST /api/medical-records/pet/:petId - Create new record
  Future<MedicalRecord> createMedicalRecord(
    String petId,
    MedicalRecordDto recordDto,
  ) async {
    final response = await _apiService.post(
      '/medical-records/pet/$petId',
      data: recordDto.toJson(),
    );
    final recordData = response.data['data'] as Map<String, dynamic>;
    return MedicalRecord.fromDto(MedicalRecordDto.fromJson(recordData));
  }

  // PATCH /api/medical-records/:recordId - Update record
  Future<MedicalRecord> updateMedicalRecord(
    String recordId,
    Map<String, dynamic> updates,
  ) async {
    final response = await _apiService.patch(
      '/medical-records/$recordId',
      data: updates,
    );
    final recordData = response.data['data'] as Map<String, dynamic>;
    return MedicalRecord.fromDto(MedicalRecordDto.fromJson(recordData));
  }

  // DELETE /api/medical-records/:recordId - Delete record
  Future<void> deleteMedicalRecord(String recordId) async {
    await _apiService.delete('/medical-records/$recordId');
  }

  // GET /api/medical-records/pet/:petId/overdue - Get overdue records
  Future<List<MedicalRecord>> getOverdueRecords(String petId) async {
    final response =
        await _apiService.get('/medical-records/pet/$petId/overdue');
    final List<dynamic> data = response.data['data'] as List<dynamic>? ?? [];
    return data
        .map((json) => MedicalRecord.fromDto(
            MedicalRecordDto.fromJson(json as Map<String, dynamic>)))
        .toList();
  }

  // GET /api/medical-records/pet/:petId/upcoming - Get upcoming records (7 days)
  Future<List<MedicalRecord>> getUpcomingRecords(String petId) async {
    final response =
        await _apiService.get('/medical-records/pet/$petId/upcoming');
    final List<dynamic> data = response.data['data'] as List<dynamic>? ?? [];
    return data
        .map((json) => MedicalRecord.fromDto(
            MedicalRecordDto.fromJson(json as Map<String, dynamic>)))
        .toList();
  }

  // GET /api/medical-records/pet/:petId/attention - Get records needing attention
  Future<List<MedicalRecord>> getRecordsNeedingAttention(String petId) async {
    final response =
        await _apiService.get('/medical-records/pet/$petId/attention');
    final List<dynamic> data = response.data['data'] as List<dynamic>? ?? [];
    return data
        .map((json) => MedicalRecord.fromDto(
            MedicalRecordDto.fromJson(json as Map<String, dynamic>)))
        .toList();
  }

  // GET /api/medical-records/owner?type=&isOverdue= - Get all user's records with filters
  Future<List<MedicalRecord>> getUserMedicalRecords({
    String? type,
    bool? isOverdue,
  }) async {
    final queryParams = <String, dynamic>{};
    if (type != null) queryParams['type'] = type;
    if (isOverdue != null) queryParams['isOverdue'] = isOverdue;

    final response = await _apiService.get(
      '/medical-records/owner',
      queryParameters: queryParams,
    );
    final List<dynamic> data = response.data['data'] as List<dynamic>? ?? [];
    return data
        .map((json) => MedicalRecord.fromDto(
            MedicalRecordDto.fromJson(json as Map<String, dynamic>)))
        .toList();
  }
}
