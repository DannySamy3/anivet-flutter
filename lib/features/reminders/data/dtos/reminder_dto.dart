class ReminderDto {
  final String id;
  final String petId;
  final String type; // vaccination, checkup, medication, grooming, other
  final DateTime dueDate;
  final String message;
  final bool sent;
  final DateTime createdAt;

  ReminderDto({
    required this.id,
    required this.petId,
    required this.type,
    required this.dueDate,
    required this.message,
    required this.sent,
    required this.createdAt,
  });

  factory ReminderDto.fromJson(Map<String, dynamic> json) {
    return ReminderDto(
      id: json['id'] as String,
      petId: json['petId'] as String,
      type: json['type'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      message: json['message'] as String,
      sent: json['sent'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'petId': petId,
      'type': type,
      'dueDate': dueDate.toIso8601String(),
      'message': message,
    };
  }
}
