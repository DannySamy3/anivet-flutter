import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_error_widget.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/medical_record_providers.dart';
import '../widgets/medical_record_card.dart';

class MedicalRecordsScreen extends ConsumerWidget {
  final String petId;

  const MedicalRecordsScreen({
    super.key,
    required this.petId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsQuery = ref.watch(medicalRecordsByPetProvider(petId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Records'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(medicalRecordsByPetProvider(petId)),
          ),
        ],
      ),
      body: recordsQuery.when(
        data: (records) {
          if (records.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.medical_information_outlined,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Medical Records Yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add your first medical record for this pet',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.push('/medical-records/create?petId=$petId'),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Record'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return MedicalRecordCard(
                record: record,
                onTap: () => context.push('/medical-records/${record.id}'),
              );
            },
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stackTrace) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(medicalRecordsByPetProvider(petId)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/medical-records/create?petId=$petId'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
