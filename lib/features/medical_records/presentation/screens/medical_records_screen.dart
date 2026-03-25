import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_error_widget.dart';


import '../providers/medical_record_providers.dart';
import '../widgets/medical_record_card.dart';
import '../../domain/entities/medical_record.dart';

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
          final displayRecords = records.isEmpty ? [
            MedicalRecord(
              id: 'dummy1',
              petId: petId,
              type: 'vaccination',
              title: 'Rabies Vaccination',
              description: 'Annual rabies booster',
              recordDate: DateTime.now().subtract(const Duration(days: 30)),
              dueDate: DateTime.now().add(const Duration(days: 335)),
              veterinarian: 'Dr. Smith',
              createdAt: DateTime.now().subtract(const Duration(days: 30)),
            ),
            MedicalRecord(
              id: 'dummy2',
              petId: petId,
              type: 'checkup',
              title: 'Annual Wellness Check',
              description: 'General health examination. All vitals normal.',
              recordDate: DateTime.now().subtract(const Duration(days: 90)),
              veterinarian: 'Dr. Johnson',
              createdAt: DateTime.now().subtract(const Duration(days: 90)),
            ),
          ] : records;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: displayRecords.length,
            itemBuilder: (context, index) {
              final record = displayRecords[index];
              return MedicalRecordCard(
                record: record,
                onTap: () => context.push('/medical-records/${record.id}?petId=$petId'),
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
