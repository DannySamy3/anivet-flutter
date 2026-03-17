import '../../domain/entities/customer.dart';

class CustomerModel extends Customer {
  const CustomerModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.email,
    super.role,
    required super.createdAt,
    required super.pets,
    required super.orders,
    required super.boardings,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      pets: (json['pets'] as List<dynamic>?)
              ?.map((e) => CustomerPetModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      orders: (json['orders'] as List<dynamic>?)
              ?.map((e) => CustomerOrderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      boardings: (json['boardings'] as List<dynamic>?)
              ?.map((e) =>
                  CustomerBoardingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class CustomerPetModel extends CustomerPet {
  const CustomerPetModel({
    required super.id,
    required super.name,
    required super.breed,
    super.medicalRecords,
    super.reminders,
    super.history,
  });

  factory CustomerPetModel.fromJson(Map<String, dynamic> json) {
    return CustomerPetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      breed: json['breed'] as String? ?? 'Unknown Breed',
      medicalRecords: (json['medicalRecords'] as List<dynamic>?)
          ?.map((e) => MedicalRecordModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      reminders: (json['reminders'] as List<dynamic>?)
          ?.map((e) => ReminderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      history: json['history'] as List<dynamic>?,
    );
  }
}

class MedicalRecordModel extends MedicalRecord {
  const MedicalRecordModel({
    required super.id,
    required super.type,
    required super.date,
    required super.description,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['id'] as String,
      type: json['type'] as String? ?? 'GENERAL',
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String? ?? '',
    );
  }
}

class ReminderModel extends Reminder {
  const ReminderModel({
    required super.dueDate,
    required super.message,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      dueDate: DateTime.parse(json['dueDate'] as String),
      message: json['message'] as String? ?? '',
    );
  }
}

class CustomerOrderModel extends CustomerOrder {
  const CustomerOrderModel({
    required super.id,
    required super.totalPrice,
    required super.status,
    super.createdAt,
    super.items,
  });

  factory CustomerOrderModel.fromJson(Map<String, dynamic> json) {
    return CustomerOrderModel(
      id: json['id'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String? ?? 'PENDING',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.productName,
    required super.price,
    required super.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>?;
    return OrderItemModel(
      productName: product?['name'] as String? ?? 'Unknown Product',
      price: (product?['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 1,
    );
  }
}

class CustomerBoardingModel extends CustomerBoarding {
  const CustomerBoardingModel({
    required super.id,
    required super.totalAmount,
    required super.status,
    required super.createdAt,
    super.logs,
    super.charges,
  });

  factory CustomerBoardingModel.fromJson(Map<String, dynamic> json) {
    return CustomerBoardingModel(
      id: json['id'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String? ?? 'PENDING',
      createdAt: DateTime.parse(json['createdAt'] as String),
      logs: json['logs'] as List<dynamic>?,
      charges: json['charges'] as List<dynamic>?,
    );
  }
}
