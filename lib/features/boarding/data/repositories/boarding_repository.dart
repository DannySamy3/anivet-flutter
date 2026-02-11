import '../../../../core/services/api_service.dart';
import '../dtos/boarding_dto.dart';
import '../../domain/entities/boarding.dart';

class BoardingRepository {
  final ApiService _apiService;

  BoardingRepository(this._apiService);

  // POST /api/boarding - Request boarding
  Future<Boarding> createBoardingRequest(Map<String, dynamic> data) async {
    final response = await _apiService.post('/boarding', data: data);
    return Boarding.fromDto(BoardingDto.fromJson(response.data));
  }

  // GET /api/boarding/me - My boardings
  Future<List<Boarding>> getMyBoardings() async {
    final response = await _apiService.get('/boarding/me');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => Boarding.fromDto(BoardingDto.fromJson(json)))
        .toList();
  }

  // GET /api/boarding/:id - Get boarding by ID
  Future<Boarding> getBoardingById(String boardingId) async {
    final response = await _apiService.get('/boarding/$boardingId');
    return Boarding.fromDto(BoardingDto.fromJson(response.data));
  }

  // GET /api/boarding - All boardings (admin)
  Future<List<Boarding>> getAllBoardings() async {
    final response = await _apiService.get('/boarding');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => Boarding.fromDto(BoardingDto.fromJson(json)))
        .toList();
  }

  // PATCH /api/boarding/:id/status - Update status (admin)
  Future<Boarding> updateBoardingStatus(
      String boardingId, String status) async {
    final response = await _apiService.patch(
      '/boarding/$boardingId/status',
      data: {'status': status},
    );
    return Boarding.fromDto(BoardingDto.fromJson(response.data));
  }

  // POST /api/boarding/:id/logs - Add boarding log (admin)
  Future<BoardingLog> addBoardingLog(
    String boardingId,
    Map<String, dynamic> logData,
  ) async {
    final response = await _apiService.post(
      '/boarding/$boardingId/logs',
      data: logData,
    );
    return BoardingLog.fromDto(BoardingLogDto.fromJson(response.data));
  }

  // GET boarding logs
  Future<List<BoardingLog>> getBoardingLogs(String boardingId) async {
    final response = await _apiService.get('/boarding/$boardingId/logs');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => BoardingLog.fromDto(BoardingLogDto.fromJson(json)))
        .toList();
  }
}
