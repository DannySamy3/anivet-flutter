import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/boarding_providers.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_error_widget.dart';

class AdminBoardingsScreen extends ConsumerWidget {
  const AdminBoardingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardingsQuery = ref.watch(allBoardingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Boardings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(allBoardingsProvider),
          ),
        ],
      ),
      body: boardingsQuery.when(
        data: (boardings) {
          if (boardings.isEmpty) {
            return const Center(child: Text('No boarding requests yet'));
          }

          // Group by status
          final pending =
              boardings.where((b) => b.status == 'pending').toList();
          final confirmed =
              boardings.where((b) => b.status == 'confirmed').toList();
          final active = boardings.where((b) => b.status == 'active').toList();
          final completed =
              boardings.where((b) => b.status == 'completed').toList();

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(allBoardingsProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (pending.isNotEmpty) ...[
                  _buildSectionHeader(context, 'Pending Approval',
                      pending.length, Colors.orange),
                  ...pending.map((b) => _buildBoardingCard(context, ref, b)),
                  const SizedBox(height: 16),
                ],
                if (confirmed.isNotEmpty) ...[
                  _buildSectionHeader(
                      context, 'Confirmed', confirmed.length, Colors.blue),
                  ...confirmed.map((b) => _buildBoardingCard(context, ref, b)),
                  const SizedBox(height: 16),
                ],
                if (active.isNotEmpty) ...[
                  _buildSectionHeader(
                      context, 'Active', active.length, Colors.green),
                  ...active.map((b) => _buildBoardingCard(context, ref, b)),
                  const SizedBox(height: 16),
                ],
                if (completed.isNotEmpty) ...[
                  _buildSectionHeader(
                      context, 'Completed', completed.length, Colors.grey),
                  ...completed.map((b) => _buildBoardingCard(context, ref, b)),
                ],
              ],
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(allBoardingsProvider),
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

  Widget _buildBoardingCard(BuildContext context, WidgetRef ref, boarding) {
    final statusColor = _getStatusColor(boarding.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(Icons.hotel, color: statusColor),
        ),
        title: Text('Boarding #${boarding.id.substring(0, 8)}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Check-in: ${_formatDate(boarding.checkIn)}'),
            if (boarding.checkOut != null)
              Text('Check-out: ${_formatDate(boarding.checkOut!)}'),
            Text('\$${boarding.dailyRate}/day'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) =>
              _handleStatusChange(context, ref, boarding.id, value),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'confirmed', child: Text('Confirm')),
            const PopupMenuItem(value: 'active', child: Text('Set Active')),
            const PopupMenuItem(value: 'completed', child: Text('Complete')),
            const PopupMenuItem(value: 'cancelled', child: Text('Cancel')),
          ],
          child: Chip(
            label: Text(boarding.status.toUpperCase()),
            backgroundColor: statusColor.withOpacity(0.2),
            labelStyle:
                TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () => context.push('/boarding/${boarding.id}'),
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
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _handleStatusChange(BuildContext context, WidgetRef ref,
      String boardingId, String newStatus) async {
    try {
      // Call the updateBoardingStatusProvider with the parameters
      await ref.read(updateBoardingStatusProvider(
          (boardingId: boardingId, status: newStatus)).future);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Boarding status updated to $newStatus')),
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
