import 'package:annivet/features/boarding/data/dtos/boarding_dto.dart';

class Boarding {
  final String id;
  final String petId;
  final DateTime checkIn;
  final DateTime? checkOut;
  final String status;
  final double dailyRate;
  final String? instructions;
  final DateTime createdAt;

  Boarding({
    required this.id,
    required this.petId,
    required this.checkIn,
    this.checkOut,
    required this.status,
    required this.dailyRate,
    this.instructions,
    required this.createdAt,
  });

  factory Boarding.fromDto(BoardingDto dto) {
    return Boarding(
      id: dto.id,
      petId: dto.petId,
      checkIn: dto.checkIn,
      checkOut: dto.checkOut,
      status: dto.status,
      dailyRate: dto.dailyRate,
      instructions: dto.instructions,
      createdAt: dto.createdAt,
    );
  }

  bool get isPending => status == 'pending';
  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';

  int get daysBooked {
    final end = checkOut ?? DateTime.now();
    return end.difference(checkIn).inDays;
  }

  double get totalCost => daysBooked * dailyRate;
}

class BoardingLog {
  final String id;
  final String boardingId;
  final DateTime date;
  final String notes;
  final List<String>? photos;

  BoardingLog({
    required this.id,
    required this.boardingId,
    required this.date,
    required this.notes,
    this.photos,
  });

  factory BoardingLog.fromDto(BoardingLogDto dto) {
    return BoardingLog(
      id: dto.id,
      boardingId: dto.boardingId,
      date: dto.date,
      notes: dto.notes,
      photos: dto.photos,
    );
  }
}
