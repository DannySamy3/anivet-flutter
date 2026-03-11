import 'package:annivet/features/boarding/data/dtos/boarding_dto.dart';
import 'package:annivet/core/models/billing_breakdown.dart';

class Boarding {
  final String id;
  final String petId;
  final String customerId;
  final DateTime checkIn;
  final DateTime? checkOut;
  final int numberOfDays;
  final String status;
  final double dailyRate;
  final int medicationAdminDays;
  final double medicationAdminFee;
  final bool groomingRequired;
  final double groomingFee;
  final bool pickupDropoffRequired;
  final double pickupDropoffFee;
  final double totalAmount;
  final double paidAmount;
  final String? specialInstructions;
  final BillingBreakdown? billingBreakdown;
  final DateTime createdAt;
  final DateTime updatedAt;

  Boarding({
    required this.id,
    required this.petId,
    required this.customerId,
    required this.checkIn,
    this.checkOut,
    required this.numberOfDays,
    required this.status,
    required this.dailyRate,
    required this.medicationAdminDays,
    required this.medicationAdminFee,
    required this.groomingRequired,
    required this.groomingFee,
    required this.pickupDropoffRequired,
    required this.pickupDropoffFee,
    required this.totalAmount,
    required this.paidAmount,
    this.specialInstructions,
    this.billingBreakdown,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Boarding.fromDto(BoardingDto dto) {
    return Boarding(
      id: dto.id,
      petId: dto.petId,
      customerId: dto.customerId,
      checkIn: dto.checkIn,
      checkOut: dto.checkOut,
      numberOfDays: dto.numberOfDays,
      status: dto.status,
      dailyRate: dto.dailyRate,
      medicationAdminDays: dto.medicationAdminDays,
      medicationAdminFee: dto.medicationAdminFee,
      groomingRequired: dto.groomingRequired,
      groomingFee: dto.groomingFee,
      pickupDropoffRequired: dto.pickupDropoffRequired,
      pickupDropoffFee: dto.pickupDropoffFee,
      totalAmount: dto.totalAmount,
      paidAmount: dto.paidAmount,
      specialInstructions: dto.specialInstructions,
      billingBreakdown: dto.billingBreakdown,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  // Status checks
  bool get isRequested => status == 'REQUESTED';
  bool get isApproved => status == 'APPROVED';
  bool get isActive => status == 'ACTIVE';
  bool get isCompleted => status == 'COMPLETED';
  bool get isCancelled => status == 'CANCELLED';

  // Payment status
  bool get isFullyPaid => paidAmount >= totalAmount;
  bool get isPartiallyPaid => paidAmount > 0 && paidAmount < totalAmount;
  bool get isUnpaid => paidAmount == 0;

  double get remainingBalance => totalAmount - paidAmount;

  int get daysBooked {
    final end = checkOut ?? DateTime.now();
    return end.difference(checkIn).inDays;
  }

  // Additional services helpers
  List<String> get additionalServices {
    final services = <String>[];
    if (medicationAdminDays > 0) services.add('Medication Administration');
    if (groomingRequired) services.add('Grooming');
    if (pickupDropoffRequired) services.add('Pickup/Dropoff');
    return services;
  }

  Boarding copyWith({
    String? id,
    String? petId,
    String? customerId,
    DateTime? checkIn,
    DateTime? checkOut,
    int? numberOfDays,
    String? status,
    double? dailyRate,
    int? medicationAdminDays,
    double? medicationAdminFee,
    bool? groomingRequired,
    double? groomingFee,
    bool? pickupDropoffRequired,
    double? pickupDropoffFee,
    double? totalAmount,
    double? paidAmount,
    String? specialInstructions,
    BillingBreakdown? billingBreakdown,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Boarding(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      customerId: customerId ?? this.customerId,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      status: status ?? this.status,
      dailyRate: dailyRate ?? this.dailyRate,
      medicationAdminDays: medicationAdminDays ?? this.medicationAdminDays,
      medicationAdminFee: medicationAdminFee ?? this.medicationAdminFee,
      groomingRequired: groomingRequired ?? this.groomingRequired,
      groomingFee: groomingFee ?? this.groomingFee,
      pickupDropoffRequired:
          pickupDropoffRequired ?? this.pickupDropoffRequired,
      pickupDropoffFee: pickupDropoffFee ?? this.pickupDropoffFee,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      billingBreakdown: billingBreakdown ?? this.billingBreakdown,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
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
