import 'package:annivet/features/orders/data/dtos/order_dto.dart';

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromDto(OrderDto dto) {
    return Order(
      id: dto.id,
      userId: dto.userId,
      items: dto.items.map((item) => OrderItem.fromDto(item)).toList(),
      total: dto.total,
      status: dto.status,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
}

class OrderItem {
  final String productId;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromDto(OrderItemDto dto) {
    return OrderItem(
      productId: dto.productId,
      quantity: dto.quantity,
      price: dto.price,
    );
  }

  double get total => price * quantity;
}
