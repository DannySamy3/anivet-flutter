import 'package:annivet/features/reminders/data/dtos/reminder_dto.dart';

class Reminder {
  final String id;
  final String petId;
  final String type;
  final DateTime dueDate;
  final String message;
  final bool sent;
  final DateTime createdAt;

  Reminder({
    required this.id,
    required this.petId,
    required this.type,
    required this.dueDate,
    required this.message,
    required this.sent,
    required this.createdAt,
  });

  factory Reminder.fromDto(ReminderDto dto) {
    return Reminder(
      id: dto.id,
      petId: dto.petId,
      type: dto.type,
      dueDate: dto.dueDate,
      message: dto.message,
      sent: dto.sent,
      createdAt: dto.createdAt,
    );
  }

  bool get isOverdue => DateTime.now().isAfter(dueDate) && !sent;
  bool get isDueSoon {
    final daysUntilDue = dueDate.difference(DateTime.now()).inDays;
    return daysUntilDue >= 0 && daysUntilDue <= 7 && !sent;
  }
}
