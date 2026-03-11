import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annivet/features/boarding/data/repositories/boarding_repository.dart';
import 'package:annivet/features/boarding/domain/entities/boarding.dart';
import 'package:annivet/core/services/api_service.dart';
import 'package:annivet/core/services/storage_service.dart';

final boardingRepositoryProvider = Provider<BoardingRepository>((ref) {
  final apiService = ApiService(StorageService());
  return BoardingRepository(apiService);
});

// ============ QUERIES ============

/// Get my boardings (customer)
final myBoardingsProvider = FutureProvider<List<Boarding>>((ref) async {
  final repository = ref.watch(boardingRepositoryProvider);
  return repository.getMyBoardings();
});

/// Get all boardings (admin)
final allBoardingsProvider = FutureProvider<List<Boarding>>((ref) async {
  final repository = ref.watch(boardingRepositoryProvider);
  return repository.getAllBoardings();
});

/// Get boarding by ID
final boardingDetailProvider = FutureProvider.family<Boarding, String>(
  (ref, boardingId) async {
    final repository = ref.watch(boardingRepositoryProvider);
    return repository.getBoardingById(boardingId);
  },
);

/// Get billing information for a boarding
final boardingBillingProvider =
    FutureProvider.family<Map<String, dynamic>, String>(
  (ref, boardingId) async {
    final repository = ref.watch(boardingRepositoryProvider);
    return repository.getBillingInfo(boardingId);
  },
);

/// Get boarding logs
final boardingLogsProvider = FutureProvider.family<List<BoardingLog>, String>(
  (ref, boardingId) async {
    final repository = ref.watch(boardingRepositoryProvider);
    return repository.getBoardingLogs(boardingId);
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
