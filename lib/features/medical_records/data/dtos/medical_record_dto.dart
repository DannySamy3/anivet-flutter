class MedicalRecordDto {
  final String id;
  final String petId;
  final String type;
  final String title;
  final String description;
  final DateTime recordDate;
  final DateTime? dueDate;
  final String? veterinarian;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MedicalRecordDto({
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

  factory MedicalRecordDto.fromJson(Map<String, dynamic> json) {
    return MedicalRecordDto(
      id: json['id'] as String,
      petId: json['petId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      recordDate: DateTime.parse(json['recordDate'] as String),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      veterinarian: json['veterinarian'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'petId': petId,
      'type': type,
      'title': title,
      'description': description,
      'recordDate': recordDate.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'veterinarian': veterinarian,
      'notes': notes,
    };
  }

  static MedicalRecordDto create({
    required String petId,
    required String type,
    required String title,
    required String description,
    required DateTime recordDate,
    DateTime? dueDate,
    String? veterinarian,
    String? notes,
  }) {
    return MedicalRecordDto(
      id: '', // Will be set by backend
      petId: petId,
      type: type,
      title: title,
      description: description,
      recordDate: recordDate,
      dueDate: dueDate,
      veterinarian: veterinarian,
      notes: notes,
      createdAt: DateTime.now(),
    );
  }
}
