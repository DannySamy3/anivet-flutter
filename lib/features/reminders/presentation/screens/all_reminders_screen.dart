import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/reminder_providers.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/constants/app_colors.dart';

class AllRemindersScreen extends ConsumerWidget {
  const AllRemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersQuery = ref.watch(allRemindersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Reminders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(allRemindersProvider),
          ),
        ],
      ),
      body: remindersQuery.when(
        data: (reminders) {
          if (reminders.isEmpty) {
            return const Center(child: Text('No reminders yet'));
          }

          // Separate by status
          final overdue = reminders.where((r) => r.isOverdue).toList();
          final dueSoon = reminders.where((r) => r.isDueSoon).toList();
          final upcoming = reminders
              .where((r) => !r.isOverdue && !r.isDueSoon && !r.sent)
              .toList();
          final sent = reminders.where((r) => r.sent).toList();

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(allRemindersProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (overdue.isNotEmpty) ...[
                  _buildSectionHeader(
                      context, 'Overdue', overdue.length, Colors.red),
                  ...overdue.map(
                      (r) => _buildReminderCard(context, ref, r, Colors.red)),
                  const SizedBox(height: 16),
                ],
                if (dueSoon.isNotEmpty) ...[
                  _buildSectionHeader(
                      context, 'Due Soon', dueSoon.length, Colors.orange),
                  ...dueSoon.map((r) =>
                      _buildReminderCard(context, ref, r, Colors.orange)),
                  const SizedBox(height: 16),
                ],
                if (upcoming.isNotEmpty) ...[
                  _buildSectionHeader(
                      context, 'Upcoming', upcoming.length, Colors.blue),
                  ...upcoming.map(
                      (r) => _buildReminderCard(context, ref, r, Colors.blue)),
                  const SizedBox(height: 16),
                ],
                if (sent.isNotEmpty) ...[
                  _buildSectionHeader(
                      context, 'Sent', sent.length, Colors.grey),
                  ...sent.map(
                      (r) => _buildReminderCard(context, ref, r, Colors.grey)),
                ],
              ],
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(allRemindersProvider),
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

  Widget _buildReminderCard(
      BuildContext context, WidgetRef ref, reminder, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          _getIconForType(reminder.type),
          color: color,
        ),
        title: Text(reminder.message),
        subtitle: Text(
          'Due: ${_formatDate(reminder.dueDate)}\n'
          'Type: ${reminder.type}',
        ),
        trailing: reminder.sent
            ? Icon(Icons.check_circle, color: Colors.green)
            : IconButton(
                icon: Icon(Icons.send, color: AppColors.primaryGreen),
                onPressed: () async {
                  try {
                    await ref
                        .read(markReminderSentProvider(reminder.id).future);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Reminder marked as sent')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
              ),
        isThreeLine: true,
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'vaccination':
        return Icons.vaccines;
      case 'checkup':
        return Icons.healing;
      case 'medication':
        return Icons.medication;
      case 'grooming':
        return Icons.pets;
      default:
        return Icons.notifications;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
