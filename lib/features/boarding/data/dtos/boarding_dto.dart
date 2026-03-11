import 'package:annivet/core/models/billing_breakdown.dart';

class BoardingDto {
  final String id;
  final String petId;
  final String customerId;
  final DateTime checkIn;
  final DateTime? checkOut;
  final int numberOfDays;
  final String status; // REQUESTED, APPROVED, ACTIVE, COMPLETED, CANCELLED
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

  BoardingDto({
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

  factory BoardingDto.fromJson(Map<String, dynamic> json) {
    return BoardingDto(
      id: json['id'] as String,
      petId: json['petId'] as String,
      customerId: json['customerId'] as String,
      checkIn: DateTime.parse(json['checkIn'] as String),
      checkOut: json['checkOut'] != null
          ? DateTime.parse(json['checkOut'] as String)
          : null,
      numberOfDays: json['numberOfDays'] as int? ?? 1,
      status: json['status'] as String,
      dailyRate: (json['dailyRate'] as num).toDouble(),
      medicationAdminDays: json['medicationAdminDays'] as int? ?? 0,
      medicationAdminFee:
          (json['medicationAdminFee'] as num?)?.toDouble() ?? 5000,
      groomingRequired: json['groomingRequired'] as bool? ?? false,
      groomingFee: (json['groomingFee'] as num?)?.toDouble() ?? 30000,
      pickupDropoffRequired: json['pickupDropoffRequired'] as bool? ?? false,
      pickupDropoffFee: (json['pickupDropoffFee'] as num?)?.toDouble() ?? 20000,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      specialInstructions: json['specialInstructions'] as String?,
      billingBreakdown: json['billingBreakdown'] != null
          ? BillingBreakdown.fromJson(
              json['billingBreakdown'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'petId': petId,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut?.toIso8601String(),
      'numberOfDays': numberOfDays,
      'dailyRate': dailyRate,
      'medicationAdminDays': medicationAdminDays,
      'medicationAdminFee': medicationAdminFee,
      'groomingRequired': groomingRequired,
      'groomingFee': groomingFee,
      'pickupDropoffRequired': pickupDropoffRequired,
      'pickupDropoffFee': pickupDropoffFee,
      'specialInstructions': specialInstructions,
      // DO NOT include:
      // - status (backend auto-sets to 'REQUESTED')
      // - paidAmount (backend auto-sets to 0)
      // - totalAmount (backend calculated)
      // - billingBreakdown (backend calculated)
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
