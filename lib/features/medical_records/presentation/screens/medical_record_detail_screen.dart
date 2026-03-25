import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/medical_record_providers.dart';

class MedicalRecordDetailScreen extends ConsumerWidget {
  final String recordId;
  final String? petId;

  const MedicalRecordDetailScreen({
    super.key,
    required this.recordId,
    this.petId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordQuery = ref.watch(medicalRecordDetailProvider(recordId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Record'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push(
                '/medical-records/edit/$recordId',
                extra: petId,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context, ref),
          ),
        ],
      ),
      body: recordQuery.when(
        data: (record) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header Section with Type Badge and Title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor(record.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      record.type.toUpperCase(),
                      style: TextStyle(
                        color: _getTypeColor(record.type),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (record.isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning, size: 14, color: Colors.red),
                          SizedBox(width: 4),
                          Text(
                            'OVERDUE',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (record.isDueSoon)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info, size: 14, color: Colors.orange),
                          SizedBox(width: 4),
                          Text(
                            'DUE SOON',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                record.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),

              // Pet Information Section
              _SectionTitle('Pet Information'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _InfoRow(
                    label: 'Pet ID',
                    value: record.petId,
                    icon: Icons.pets,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Record Details Card
              _SectionTitle('Record Details'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow(
                        label: 'Record Date',
                        value: _formatDate(record.recordDate),
                        icon: Icons.calendar_today,
                      ),
                      if (record.dueDate != null) ...[
                        const Divider(height: 20),
                        _InfoRow(
                          label: 'Due Date',
                          value: _formatDate(record.dueDate!),
                          icon: Icons.event_note,
                          valueColor: record.isOverdue
                              ? Colors.red
                              : (record.isDueSoon ? Colors.orange : null),
                        ),
                      ],
                      if (record.veterinarian != null) ...[
                        const Divider(height: 20),
                        _InfoRow(
                          label: 'Veterinarian',
                          value: record.veterinarian!,
                          icon: Icons.person,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Description Section
              _SectionTitle('Description'),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  record.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

              // Notes Section
              if (record.notes != null) ...[
                const SizedBox(height: 20),
                _SectionTitle('Additional Notes'),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    record.notes!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],

              // Record Metadata Section
              const SizedBox(height: 20),
              _SectionTitle('Record Information'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow(
                        label: 'Created',
                        value: _formatDateTime(record.createdAt),
                        icon: Icons.add_circle_outline,
                      ),
                      if (record.updatedAt != null) ...[
                        const Divider(height: 20),
                        _InfoRow(
                          label: 'Last Updated',
                          value: _formatDateTime(record.updatedAt!),
                          icon: Icons.edit_calendar,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stackTrace) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(medicalRecordDetailProvider(recordId)),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record'),
        content:
            const Text('Are you sure you want to delete this medical record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteRecord(context, ref);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteRecord(BuildContext context, WidgetRef ref) async {
    try {
      final repository = ref.read(medicalRecordRepositoryProvider);
      await repository.deleteMedicalRecord(recordId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medical record deleted successfully')),
        );
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dateTime) {
    final date = _formatDate(dateTime);
    final time =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date at $time';
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'vaccination':
        return Colors.blue;
      case 'checkup':
        return Colors.green;
      case 'treatment':
        return Colors.orange;
      case 'surgery':
        return Colors.red;
      case 'medication':
        return Colors.purple;
      default:
        return AppColors.primaryGreen;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
