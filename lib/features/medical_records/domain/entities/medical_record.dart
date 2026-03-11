import 'package:annivet/features/medical_records/data/dtos/medical_record_dto.dart';

class MedicalRecord {
  final String id;
  final String petId;
  final String
      type; // vaccination, checkup, treatment, surgery, medication, etc.
  final String title;
  final String description;
  final DateTime recordDate;
  final DateTime? dueDate;
  final String? veterinarian;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MedicalRecord({
    required this.id,
    required this.petId,
    required this.type,
    required this.title,
    required this.description,
    required this.recordDate,
    this.dueDate,
    this.veterinarian,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory MedicalRecord.fromDto(MedicalRecordDto dto) {
    return MedicalRecord(
      id: dto.id,
      petId: dto.petId,
      type: dto.type,
      title: dto.title,
      description: dto.description,
      recordDate: dto.recordDate,
      dueDate: dto.dueDate,
      veterinarian: dto.veterinarian,
      notes: dto.notes,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  bool get isOverdue =>
      dueDate != null && DateTime.now().isAfter(dueDate!) && !isDone;

  bool get isDueSoon {
    if (dueDate == null) return false;
    final daysUntilDue = dueDate!.difference(DateTime.now()).inDays;
    return daysUntilDue >= 0 && daysUntilDue <= 7 && !isDone;
  }

  bool get isDone => false; // Can be extended if status is added

  bool get needsAttention => isOverdue || isDueSoon;

  MedicalRecord copyWith({
    String? id,
    String? petId,
    String? type,
    String? title,
    String? description,
    DateTime? recordDate,
    DateTime? dueDate,
    String? veterinarian,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicalRecord(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      recordDate: recordDate ?? this.recordDate,
      dueDate: dueDate ?? this.dueDate,
      veterinarian: veterinarian ?? this.veterinarian,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
