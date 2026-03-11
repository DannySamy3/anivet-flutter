/// Billing breakdown structure matching backend implementation
class BillingBreakdown {
  final DailyCharge dailyCharge;
  final MedicationAdmin? medicationAdmin;
  final Grooming? grooming;
  final PickupDropoff? pickupDropoff;
  final double total;
  final String currency;

  BillingBreakdown({
    required this.dailyCharge,
    this.medicationAdmin,
    this.grooming,
    this.pickupDropoff,
    required this.total,
    required this.currency,
  });

  factory BillingBreakdown.fromJson(Map<String, dynamic> json) {
    return BillingBreakdown(
      dailyCharge:
          DailyCharge.fromJson(json['dailyCharge'] as Map<String, dynamic>),
      medicationAdmin: json['medicationAdmin'] != null
          ? MedicationAdmin.fromJson(
              json['medicationAdmin'] as Map<String, dynamic>)
          : null,
      grooming: json['grooming'] != null
          ? Grooming.fromJson(json['grooming'] as Map<String, dynamic>)
          : null,
      pickupDropoff: json['pickupDropoff'] != null
          ? PickupDropoff.fromJson(
              json['pickupDropoff'] as Map<String, dynamic>)
          : null,
      total: (json['total'] as num).toDouble(),
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'dailyCharge': dailyCharge.toJson(),
        'medicationAdmin': medicationAdmin?.toJson(),
        'grooming': grooming?.toJson(),
        'pickupDropoff': pickupDropoff?.toJson(),
        'total': total,
        'currency': currency,
      };
}

class DailyCharge {
  final int days;
  final double dailyRate;
  final double subtotal;

  DailyCharge({
    required this.days,
    required this.dailyRate,
    required this.subtotal,
  });

  factory DailyCharge.fromJson(Map<String, dynamic> json) {
    return DailyCharge(
      days: json['days'] as int,
      dailyRate: (json['dailyRate'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'days': days,
        'dailyRate': dailyRate,
        'subtotal': subtotal,
      };
}

class MedicationAdmin {
  final int days;
  final double dailyFee;
  final double subtotal;

  MedicationAdmin({
    required this.days,
    required this.dailyFee,
    required this.subtotal,
  });

  factory MedicationAdmin.fromJson(Map<String, dynamic> json) {
    return MedicationAdmin(
      days: json['days'] as int,
      dailyFee: (json['dailyFee'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'days': days,
        'dailyFee': dailyFee,
        'subtotal': subtotal,
      };
}

class Grooming {
  final double fee;

  Grooming({required this.fee});

  factory Grooming.fromJson(Map<String, dynamic> json) {
    return Grooming(fee: (json['fee'] as num).toDouble());
  }

  Map<String, dynamic> toJson() => {'fee': fee};
}

class PickupDropoff {
  final double fee;

  PickupDropoff({required this.fee});

  factory PickupDropoff.fromJson(Map<String, dynamic> json) {
    return PickupDropoff(fee: (json['fee'] as num).toDouble());
  }

  Map<String, dynamic> toJson() => {'fee': fee};
}
