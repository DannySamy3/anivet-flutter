import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/pet_providers.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/pet_card.dart';

class AdminPetsScreen extends ConsumerWidget {
  const AdminPetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsQuery = ref.watch(allPetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Pets (Admin)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(allPetsProvider),
          ),
        ],
      ),
      body: petsQuery.when(
        data: (pets) {
          if (pets.isEmpty) {
            return const Center(
              child: Text('No pets in the system'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(allPetsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return PetCard(
                  pet: pet,
                  onTap: () => context.push('/pets/${pet.id}'),
                );
              },
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stackTrace) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(allPetsProvider),
        ),
      ),
    );
  }
}
