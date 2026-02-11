import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/order_providers.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_error_widget.dart';

class MyOrdersScreen extends ConsumerWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersQuery = ref.watch(myOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(myOrdersProvider),
          ),
        ],
      ),
      body: ordersQuery.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet'));
          }

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(myOrdersProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text('Order #${order.id.substring(0, 8)}'),
                    subtitle: Text(
                      '${order.items.length} items • KSh ${order.total.toStringAsFixed(2)}',
                    ),
                    trailing: Chip(
                      label: Text(order.status.toUpperCase()),
                      backgroundColor: _getStatusColor(order.status),
                    ),
                    onTap: () => context.push('/orders/${order.id}'),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(myOrdersProvider),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange.withOpacity(0.3);
      case 'confirmed':
        return Colors.blue.withOpacity(0.3);
      case 'processing':
        return Colors.purple.withOpacity(0.3);
      case 'completed':
        return Colors.green.withOpacity(0.3);
      case 'cancelled':
        return Colors.red.withOpacity(0.3);
      default:
        return Colors.grey.withOpacity(0.3);
    }
  }
}
