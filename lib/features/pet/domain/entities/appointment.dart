class Appointment {
  final String id;
  final String petId;
  final String title;
  final String description;
  final DateTime scheduledDate;
  final String? veterinarian;
  final String? location;
  final String type; // vaccination, checkup, grooming, surgery, etc.
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.petId,
    required this.title,
    required this.description,
    required this.scheduledDate,
    this.veterinarian,
    this.location,
    required this.type,
    required this.createdAt,
  });

  bool get isUpcoming => DateTime.now().isBefore(scheduledDate);

  bool get isToday {
    final now = DateTime.now();
    return scheduledDate.year == now.year &&
        scheduledDate.month == now.month &&
        scheduledDate.day == now.day;
  }

  bool get isSoon {
    final daysUntil = scheduledDate.difference(DateTime.now()).inDays;
    return daysUntil >= 0 && daysUntil <= 7;
  }

  String getDaysUntil() {
    final daysUntil = scheduledDate.difference(DateTime.now()).inDays;
    if (isToday) return 'Today';
    if (daysUntil == 1) return 'Tomorrow';
    if (daysUntil < 0) return 'Past';
    return '$daysUntil days';
  }
}
