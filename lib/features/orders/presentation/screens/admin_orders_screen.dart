import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/order_providers.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_error_widget.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersQuery = ref.watch(allOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(allOrdersProvider),
          ),
        ],
      ),
      body: ordersQuery.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet'));
          }

          // Group by status
          final pending = orders.where((o) => o.status == 'pending').toList();
          final confirmed =
              orders.where((o) => o.status == 'confirmed').toList();
          final processing =
              orders.where((o) => o.status == 'processing').toList();
          final completed =
              orders.where((o) => o.status == 'completed').toList();
          final cancelled =
              orders.where((o) => o.status == 'cancelled').toList();

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(allOrdersProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (pending.isNotEmpty) ...[
                  _buildSectionHeader(
                      context, 'Pending', pending.length, Colors.orange),
                  ...pending.map((o) => _buildOrderCard(context, ref, o)),
                  const SizedBox(height: 16),
                ],
                if (confirmed.isNotEmpty) ...[
                  _buildSectionHeader(
                      context, 'Confirmed', confirmed.length, Colors.blue),
                  ...confirmed.map((o) => _buildOrderCard(context, ref, o)),
                  const SizedBox(height: 16),
                ],
                if (processing.isNotEmpty) ...[
                  _buildSectionHeader(
                      context, 'Processing', processing.length, Colors.purple),
                  ...processing.map((o) => _buildOrderCard(context, ref, o)),
                  const SizedBox(height: 16),
                ],
                if (completed.isNotEmpty) ...[
                  _buildSectionHeader(
                      context, 'Completed', completed.length, Colors.green),
                  ...completed.map((o) => _buildOrderCard(context, ref, o)),
                  const SizedBox(height: 16),
                ],
                if (cancelled.isNotEmpty) ...[
                  _buildSectionHeader(
                      context, 'Cancelled', cancelled.length, Colors.grey),
                  ...cancelled.map((o) => _buildOrderCard(context, ref, o)),
                ],
              ],
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(allOrdersProvider),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$title ($count)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, WidgetRef ref, order) {
    final statusColor = _getStatusColor(order.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(Icons.shopping_bag, color: statusColor),
        ),
        title: Text('Order #${order.id.substring(0, 8)}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '\$${order.total.toStringAsFixed(2)} - ${order.items.length} items'),
            Text(_formatDate(order.createdAt)),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) =>
              _handleStatusChange(context, ref, order.id, value),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'confirmed', child: Text('Confirm')),
            const PopupMenuItem(value: 'processing', child: Text('Process')),
            const PopupMenuItem(value: 'completed', child: Text('Complete')),
            const PopupMenuItem(value: 'cancelled', child: Text('Cancel')),
          ],
          child: Chip(
            label: Text(order.status.toUpperCase()),
            backgroundColor: statusColor.withOpacity(0.2),
            labelStyle:
                TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () => context.push('/orders/${order.id}'),
        isThreeLine: true,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _handleStatusChange(BuildContext context, WidgetRef ref,
      String orderId, String newStatus) async {
    try {
      await ref.read(
          updateOrderStatusProvider({'orderId': orderId, 'status': newStatus})
              .future);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order status updated to $newStatus')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
