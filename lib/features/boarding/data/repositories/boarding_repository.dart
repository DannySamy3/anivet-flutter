import '../../../../core/services/api_service.dart';
import '../dtos/boarding_dto.dart';
import '../../domain/entities/boarding.dart';

class BoardingRepository {
  final ApiService _apiService;

  BoardingRepository(this._apiService);

  // POST /api/boardings - Create boarding request
  // DO NOT send status or paidAmount - backend will set them
  Future<Boarding> createBoardingRequest(Map<String, dynamic> data) async {
    final response = await _apiService.post('/boardings', data: data);
    final boardingData = response.data['data'] as Map<String, dynamic>;
    return Boarding.fromDto(BoardingDto.fromJson(boardingData));
  }

  // GET /api/boardings/me - Get user's boardings
  Future<List<Boarding>> getMyBoardings() async {
    final response = await _apiService.get('/boardings/me');
    final List<dynamic> data = response.data['data'] as List<dynamic>? ?? [];
    return data
        .map((json) => Boarding.fromDto(
            BoardingDto.fromJson(json as Map<String, dynamic>)))
        .toList();
  }

  // GET /api/boardings/:id - Get boarding by ID
  Future<Boarding> getBoardingById(String boardingId) async {
    final response = await _apiService.get('/boardings/$boardingId');
    final boardingData = response.data['data'] as Map<String, dynamic>;
    return Boarding.fromDto(BoardingDto.fromJson(boardingData));
  }

  // GET /api/boardings - Get all boardings (admin)
  Future<List<Boarding>> getAllBoardings() async {
    final response = await _apiService.get('/boardings');
    final List<dynamic> data = response.data['data'] as List<dynamic>? ?? [];
    return data
        .map((json) => Boarding.fromDto(
            BoardingDto.fromJson(json as Map<String, dynamic>)))
        .toList();
  }

  // PATCH /api/boardings/:id/status - Update boarding status
  Future<Boarding> updateBoardingStatus(
    String boardingId,
    String status,
  ) async {
    final response = await _apiService.patch(
      '/boardings/$boardingId/status',
      data: {'status': status},
    );
    final boardingData = response.data['data'] as Map<String, dynamic>;
    return Boarding.fromDto(BoardingDto.fromJson(boardingData));
  }

  // GET /api/boardings/:id/billing - Get billing information
  Future<Map<String, dynamic>> getBillingInfo(String boardingId) async {
    final response = await _apiService.get('/boardings/$boardingId/billing');
    return response.data['data'] as Map<String, dynamic>;
  }

  // POST /api/boardings/:id/logs - Add boarding log
  Future<BoardingLog> addBoardingLog(
    String boardingId,
    Map<String, dynamic> logData,
  ) async {
    final response = await _apiService.post(
      '/boardings/$boardingId/logs',
      data: logData,
    );
    return BoardingLog.fromDto(
        BoardingLogDto.fromJson(response.data['data'] as Map<String, dynamic>));
  }

  // GET /api/boardings/:id/logs - Get boarding logs
  Future<List<BoardingLog>> getBoardingLogs(String boardingId) async {
    final response = await _apiService.get('/boardings/$boardingId/logs');
    final List<dynamic> data = response.data['data'] as List<dynamic>? ?? [];
    return data
        .map((json) => BoardingLog.fromDto(
            BoardingLogDto.fromJson(json as Map<String, dynamic>)))
        .toList();
  }
}
