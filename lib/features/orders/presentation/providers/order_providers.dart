import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annivet/features/orders/data/repositories/order_repository.dart';
import 'package:annivet/features/orders/domain/entities/order.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return OrderRepository(apiService);
});

// ============ QUERIES ============

final myOrdersProvider = FutureProvider<List<Order>>((ref) async {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.getMyOrders();
});

final allOrdersProvider = FutureProvider<List<Order>>((ref) async {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.getAllOrders();
});

final orderDetailProvider =
    FutureProvider.family<Order, String>((ref, orderId) async {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.getOrderById(orderId);
});

// ============ MUTATIONS ============

final createOrderProvider =
    FutureProvider.family<Order, List<Map<String, dynamic>>>(
        (ref, items) async {
  final repository = ref.watch(orderRepositoryProvider);
  final newOrder = await repository.createOrder(items);
  ref.invalidate(myOrdersProvider);
  return newOrder;
});

final updateOrderStatusProvider =
    FutureProvider.family<Order, Map<String, dynamic>>((ref, variables) async {
  final repository = ref.watch(orderRepositoryProvider);
  final orderId = variables['orderId'] as String;
  final status = variables['status'] as String;
  final updatedOrder = await repository.updateOrderStatus(orderId, status);
  ref.invalidate(myOrdersProvider);
  ref.invalidate(allOrdersProvider);
  ref.invalidate(orderDetailProvider(orderId));
  return updatedOrder;
});
