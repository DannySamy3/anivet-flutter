class BoardingDto {
  final String id;
  final String petId;
  final DateTime checkIn;
  final DateTime? checkOut;
  final String status; // pending, confirmed, active, completed, cancelled
  final double dailyRate;
  final String? instructions;
  final DateTime createdAt;

  BoardingDto({
    required this.id,
    required this.petId,
    required this.checkIn,
    this.checkOut,
    required this.status,
    required this.dailyRate,
    this.instructions,
    required this.createdAt,
  });

  factory BoardingDto.fromJson(Map<String, dynamic> json) {
    return BoardingDto(
      id: json['id'] as String,
      petId: json['petId'] as String,
      checkIn: DateTime.parse(json['checkIn'] as String),
      checkOut: json['checkOut'] != null
          ? DateTime.parse(json['checkOut'] as String)
          : null,
      status: json['status'] as String,
      dailyRate: (json['dailyRate'] as num).toDouble(),
      instructions: json['instructions'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'petId': petId,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut?.toIso8601String(),
      'dailyRate': dailyRate,
      'instructions': instructions,
    };
  }
}

class BoardingLogDto {
  final String id;
  final String boardingId;
  final DateTime date;
  final String notes;
  final List<String>? photos;

  BoardingLogDto({
    required this.id,
    required this.boardingId,
    required this.date,
    required this.notes,
    this.photos,
  });

  factory BoardingLogDto.fromJson(Map<String, dynamic> json) {
    return BoardingLogDto(
      id: json['id'] as String,
      boardingId: json['boardingId'] as String,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String,
      photos: json['photos'] != null
          ? List<String>.from(json['photos'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'notes': notes,
      'photos': photos,
    };
  }
}
