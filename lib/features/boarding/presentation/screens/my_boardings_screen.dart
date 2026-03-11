import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/boarding_providers.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_error_widget.dart';

class MyBoardingsScreen extends ConsumerWidget {
  const MyBoardingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardingsQuery = ref.watch(myBoardingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Boardings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(myBoardingsProvider),
          ),
        ],
      ),
      body: boardingsQuery.when(
        data: (boardings) {
          if (boardings.isEmpty) {
            return const Center(child: Text('No boarding requests yet'));
          }

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(myBoardingsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: boardings.length,
              itemBuilder: (context, index) {
                final boarding = boardings[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text('Boarding #${boarding.id.substring(0, 8)}'),
                    subtitle: Text(
                      'Check-in: ${_formatDate(boarding.checkIn)}\n'
                      'Days: ${boarding.numberOfDays} • KSh ${boarding.totalAmount.toStringAsFixed(2)}',
                    ),
                    trailing: Chip(
                      label: Text(boarding.status.toUpperCase()),
                      backgroundColor: _getStatusColor(boarding.status),
                    ),
                    onTap: () => context.push('/boarding/${boarding.id}'),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(myBoardingsProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/boarding/request'),
        icon: const Icon(Icons.add),
        label: const Text('Request Boarding'),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange.withOpacity(0.3);
      case 'confirmed':
        return Colors.blue.withOpacity(0.3);
      case 'active':
        return Colors.green.withOpacity(0.3);
      case 'completed':
        return Colors.grey.withOpacity(0.3);
      case 'cancelled':
        return Colors.red.withOpacity(0.3);
      default:
        return Colors.grey.withOpacity(0.3);
    }
  }
}
