import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/boarding_providers.dart';
import '../widgets/boarding_log_widget.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/constants/app_colors.dart';

class BoardingDetailScreen extends ConsumerWidget {
  final String boardingId;

  const BoardingDetailScreen({super.key, required this.boardingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardingQuery = ref.watch(boardingDetailProvider(boardingId));
    final logsQuery = ref.watch(boardingLogsProvider(boardingId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boarding Details'),
      ),
      body: boardingQuery.when(
        data: (boarding) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Boarding info card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Boarding #${boarding.id.substring(0, 8)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Chip(
                            label: Text(boarding.status.toUpperCase()),
                            backgroundColor: _getStatusColor(boarding.status),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                          context, 'Check-in', _formatDate(boarding.checkIn)),
                      _buildInfoRow(
                        context,
                        'Check-out',
                        boarding.checkOut != null
                            ? _formatDate(boarding.checkOut!)
                            : 'Not set',
                      ),
                      _buildInfoRow(
                          context, 'Days Booked', '${boarding.daysBooked}'),
                      _buildInfoRow(context, 'Daily Rate',
                          'KSh ${boarding.dailyRate.toStringAsFixed(2)}'),
                      _buildInfoRow(context, 'Total Cost',
                          'KSh ${boarding.totalCost.toStringAsFixed(2)}'),
                      if (boarding.instructions != null) ...[
                        const Divider(height: 24),
                        Text(
                          'Special Instructions',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(boarding.instructions!),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Daily logs section
              Text(
                'Daily Care Logs',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              logsQuery.when(
                data: (logs) {
                  if (logs.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'No daily logs yet',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children:
                        logs.map((log) => BoardingLogWidget(log: log)).toList(),
                  );
                },
                loading: () => const LoadingIndicator(),
                error: (error, stack) => Text('Error loading logs: $error'),
              ),
            ],
          ),
        ),
        loading: () => const LoadingIndicator(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(boardingDetailProvider(boardingId)),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
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
