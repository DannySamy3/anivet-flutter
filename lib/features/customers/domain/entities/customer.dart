class Customer {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? role;
  final DateTime createdAt;
  final List<CustomerPet> pets;
  final List<CustomerOrder> orders;
  final List<CustomerBoarding> boardings;

  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.role,
    required this.createdAt,
    required this.pets,
    required this.orders,
    required this.boardings,
  });
}

class CustomerPet {
  final String id;
  final String name;
  final String breed;
  final List<MedicalRecord>? medicalRecords;
  final List<Reminder>? reminders;
  final List<dynamic>? history; // General history list

  const CustomerPet({
    required this.id,
    required this.name,
    required this.breed,
    this.medicalRecords,
    this.reminders,
    this.history,
  });
}

class MedicalRecord {
  final String id;
  final String type;
  final DateTime date;
  final String description;

  const MedicalRecord({
    required this.id,
    required this.type,
    required this.date,
    required this.description,
  });
}

class Reminder {
  final DateTime dueDate;
  final String message;

  const Reminder({
    required this.dueDate,
    required this.message,
  });
}

class CustomerOrder {
  final String id;
  final double totalPrice;
  final String status;
  final DateTime? createdAt;
  final List<OrderItem>? items;

  const CustomerOrder({
    required this.id,
    required this.totalPrice,
    required this.status,
    this.createdAt,
    this.items,
  });
}

class OrderItem {
  final String productName;
  final double price;
  final int quantity;

  const OrderItem({
    required this.productName,
    required this.price,
    required this.quantity,
  });
}

class CustomerBoarding {
  final String id;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final List<dynamic>? logs;
  final List<dynamic>? charges;

  const CustomerBoarding({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.logs,
    this.charges,
  });
}
