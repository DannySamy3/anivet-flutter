import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annivet/features/boarding/data/repositories/boarding_repository.dart';
import 'package:annivet/features/boarding/domain/entities/boarding.dart';
import 'package:annivet/core/services/api_service.dart';
import 'package:annivet/core/services/storage_service.dart';

final boardingRepositoryProvider = Provider<BoardingRepository>((ref) {
  final apiService = ApiService(StorageService());
  return BoardingRepository(apiService);
});

// FutureProvider: Get my boardings (customer)
final myBoardingsProvider = FutureProvider<List<Boarding>>((ref) async {
  final repository = ref.watch(boardingRepositoryProvider);
  return repository.getMyBoardings();
});

// FutureProvider: Get all boardings (admin)
final allBoardingsProvider = FutureProvider<List<Boarding>>((ref) async {
  final repository = ref.watch(boardingRepositoryProvider);
  return repository.getAllBoardings();
});

// FutureProvider: Get boarding by ID
final boardingDetailProvider = FutureProvider.family<Boarding, String>(
  (ref, boardingId) async {
    final repository = ref.watch(boardingRepositoryProvider);
    return repository.getBoardingById(boardingId);
  },
);

// FutureProvider: Get boarding logs
final boardingLogsProvider = FutureProvider.family<List<BoardingLog>, String>(
  (ref, boardingId) async {
    final repository = ref.watch(boardingRepositoryProvider);
    return repository.getBoardingLogs(boardingId);
  },
);

// FutureProvider: Create boarding request
final createBoardingProvider =
    FutureProvider.family<Boarding, Map<String, dynamic>>(
  (ref, variables) async {
    final repository = ref.watch(boardingRepositoryProvider);
    final boarding = await repository.createBoardingRequest(variables);
    // Invalidate cache on success
    ref.invalidate(myBoardingsProvider);
    return boarding;
  },
);

// FutureProvider: Update boarding status (admin)
final updateBoardingStatusProvider =
    FutureProvider.family<Boarding, Map<String, dynamic>>(
  (ref, variables) async {
    final repository = ref.watch(boardingRepositoryProvider);
    final boardingId = variables['boardingId'] as String;
    final status = variables['status'] as String;
    final boarding = await repository.updateBoardingStatus(boardingId, status);
    // Invalidate related cache on success
    ref.invalidate(boardingDetailProvider(boardingId));
    ref.invalidate(allBoardingsProvider);
    ref.invalidate(myBoardingsProvider);
    return boarding;
  },
);

// FutureProvider: Add boarding log (admin)
final addBoardingLogProvider =
    FutureProvider.family<BoardingLog, Map<String, dynamic>>(
  (ref, variables) async {
    final repository = ref.watch(boardingRepositoryProvider);
    final boardingId = variables['boardingId'] as String;
    final logData = Map<String, dynamic>.from(variables);
    logData.remove('boardingId');
    final log = await repository.addBoardingLog(boardingId, logData);
    // Invalidate related cache on success
    ref.invalidate(boardingLogsProvider(boardingId));
    ref.invalidate(boardingDetailProvider(boardingId));
    return log;
  },
);
