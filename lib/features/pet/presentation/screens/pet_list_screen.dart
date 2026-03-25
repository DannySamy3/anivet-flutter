import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/pet_providers.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/pet_card.dart';

class PetListScreen extends ConsumerWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsQuery = ref.watch(myPetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.myPets),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(myPetsProvider),
          ),
        ],
      ),
      body: petsQuery.when(
        data: (pets) {
          if (pets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pets,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.noPetsYet,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.addYourFirstPet,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.refresh(myPetsProvider);
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
          onRetry: () => ref.invalidate(myPetsProvider),
        ),
      ),
    );
  }
}
