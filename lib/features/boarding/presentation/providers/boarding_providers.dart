import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annivet/features/boarding/data/repositories/boarding_repository.dart';
import 'package:annivet/features/boarding/domain/entities/boarding.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';
import 'package:annivet/core/services/mock_data_service.dart';

final boardingRepositoryProvider = Provider<BoardingRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return BoardingRepository(apiService);
});

// ============ QUERIES ============

/// Get my boardings (customer)
final myBoardingsProvider = FutureProvider<List<Boarding>>((ref) async {
  // Using mock data for development
  final mockBoardings = MockDataService.getMockBoardings();
  return mockBoardings.map((dto) => Boarding.fromDto(dto)).toList();
});

/// Get all boardings (admin)
final allBoardingsProvider = FutureProvider<List<Boarding>>((ref) async {
  // Using mock data for development
  final mockBoardings = MockDataService.getMockBoardings();
  return mockBoardings.map((dto) => Boarding.fromDto(dto)).toList();
});

/// Get boarding by ID
final boardingDetailProvider = FutureProvider.family<Boarding, String>(
  (ref, boardingId) async {
    // Using mock data for development
    final mockBoarding = MockDataService.getMockBoardingDetail(boardingId);
    if (mockBoarding == null) {
      throw Exception('Boarding not found');
    }
    return Boarding.fromDto(mockBoarding);
  },
);

/// Get billing information for a boarding
final boardingBillingProvider =
    FutureProvider.family<Map<String, dynamic>, String>(
  (ref, boardingId) async {
    // Using mock data for development
    return MockDataService.getMockBillingInfo(boardingId);
  },
);

/// Get boarding logs
final boardingLogsProvider = FutureProvider.family<List<BoardingLog>, String>(
  (ref, boardingId) async {
    // Using mock data for development
    final mockLogs = MockDataService.getMockBoardingLogDtos(boardingId);
    return mockLogs.map((dto) => BoardingLog.fromDto(dto)).toList();
  },
);

// ============ MUTATIONS ============

/// Create boarding request
final createBoardingProvider =
    FutureProvider.family<Boarding, Map<String, dynamic>>(
  (ref, data) async {
    final repository = ref.watch(boardingRepositoryProvider);
    final boarding = await repository.createBoardingRequest(data);
    // Refresh cache on success
    await ref.refresh(myBoardingsProvider);
    await ref.refresh(allBoardingsProvider);
    return boarding;
  },
);

/// Update boarding status
final updateBoardingStatusProvider =
    FutureProvider.family<Boarding, ({String boardingId, String status})>(
  (ref, params) async {
    final repository = ref.watch(boardingRepositoryProvider);
    final boarding = await repository.updateBoardingStatus(
      params.boardingId,
      params.status,
    );
    // Refresh related cache on success
    await ref.refresh(boardingDetailProvider(params.boardingId));
    await ref.refresh(boardingBillingProvider(params.boardingId));
    await ref.refresh(allBoardingsProvider);
    await ref.refresh(myBoardingsProvider);
    return boarding;
  },
);

/// Add boarding log
final addBoardingLogProvider = FutureProvider.family<BoardingLog,
    ({String boardingId, Map<String, dynamic> logData})>(
  (ref, params) async {
    final repository = ref.watch(boardingRepositoryProvider);
    final log = await repository.addBoardingLog(
      params.boardingId,
      params.logData,
    );
    // Refresh related cache on success
    await ref.refresh(boardingLogsProvider(params.boardingId));
    await ref.refresh(boardingDetailProvider(params.boardingId));
    return log;
  },
);
