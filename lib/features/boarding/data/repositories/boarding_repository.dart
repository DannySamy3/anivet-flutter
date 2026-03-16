import '../../../../core/services/api_service.dart';
import '../dtos/boarding_dto.dart';
import '../../domain/entities/boarding.dart';

class BoardingRepository {
  final ApiService _apiService;

  BoardingRepository(this._apiService);

  // POST /api/boardings - Create boarding request
  // DO NOT send status or paidAmount - backend will set them
  Future<Boarding> createBoardingRequest(Map<String, dynamic> data) async {
    final response = await _apiService.post('boardings', data: data);
    final dynamic respData = response.data;
    final boardingData =
        (respData is Map && respData.containsKey('data')) ? respData['data'] : respData;
    return Boarding.fromDto(BoardingDto.fromJson(boardingData as Map<String, dynamic>));
  }

  // GET /api/boardings/me - Get user's boardings
  Future<List<Boarding>> getMyBoardings() async {
    final response = await _apiService.get('boardings/me');
    final dynamic respData = response.data;
    final List<dynamic> data =
        (respData is Map && respData.containsKey('data')) ? respData['data'] : respData;
    return data
        .map((json) => Boarding.fromDto(
            BoardingDto.fromJson(json as Map<String, dynamic>)))
        .toList();
  }

  // GET /api/boardings/:id - Get boarding by ID
  Future<Boarding> getBoardingById(String boardingId) async {
    final response = await _apiService.get('boardings/$boardingId');
    final dynamic respData = response.data;
    final boardingData =
        (respData is Map && respData.containsKey('data')) ? respData['data'] : respData;
    return Boarding.fromDto(BoardingDto.fromJson(boardingData as Map<String, dynamic>));
  }

  // GET /api/boardings - Get all boardings (admin)
  Future<List<Boarding>> getAllBoardings() async {
    final response = await _apiService.get('boardings');
    final dynamic respData = response.data;
    final List<dynamic> data =
        (respData is Map && respData.containsKey('data')) ? respData['data'] : respData;
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
      'boardings/$boardingId/status',
      data: {'status': status},
    );
    final dynamic respData = response.data;
    final boardingData =
        (respData is Map && respData.containsKey('data')) ? respData['data'] : respData;
    return Boarding.fromDto(BoardingDto.fromJson(boardingData as Map<String, dynamic>));
  }

  // GET /api/boardings/:id/billing - Get billing information
  Future<Map<String, dynamic>> getBillingInfo(String boardingId) async {
    final response = await _apiService.get('boardings/$boardingId/billing');
    final dynamic respData = response.data;
    return (respData is Map && respData.containsKey('data')) ? respData['data'] : respData;
  }

  // POST /api/boardings/:id/logs - Add boarding log
  Future<BoardingLog> addBoardingLog(
    String boardingId,
    Map<String, dynamic> logData,
  ) async {
    final response = await _apiService.post(
      'boardings/$boardingId/logs',
      data: logData,
    );
    final dynamic respData = response.data;
    final logJson =
        (respData is Map && respData.containsKey('data')) ? respData['data'] : respData;
    return BoardingLog.fromDto(
        BoardingLogDto.fromJson(logJson as Map<String, dynamic>));
  }

  // GET /api/boardings/:id/logs - Get boarding logs
  Future<List<BoardingLog>> getBoardingLogs(String boardingId) async {
    final response = await _apiService.get('boardings/$boardingId/logs');
    final dynamic respData = response.data;
    final List<dynamic> data =
        (respData is Map && respData.containsKey('data')) ? respData['data'] : respData;
    return data
        .map((json) => BoardingLog.fromDto(
            BoardingLogDto.fromJson(json as Map<String, dynamic>)))
        .toList();
  }
}
