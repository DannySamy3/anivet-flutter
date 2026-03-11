import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/pet_providers.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';

class PetDetailScreen extends ConsumerWidget {
  final String petId;

  const PetDetailScreen({
    super.key,
    required this.petId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petQuery = ref.watch(petDetailProvider(petId));
    return petQuery.when(
      data: (pet) => Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.petDetails),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.push('/pets/$petId/edit');
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context, ref),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pet Image
              if (pet.photoUrl != null)
                CachedNetworkImage(
                  imageUrl: pet.photoUrl!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(),
                )
              else
                Container(
                  width: double.infinity,
                  height: 250,
                  color: AppColors.surfaceVariant,
                  child: Icon(
                    Icons.pets,
                    size: 80,
                    color: AppColors.primaryGreen,
                  ),
                ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      icon: Icons.category,
                      label: 'Species',
                      value: pet.species.name.toUpperCase(),
                    ),
                    _buildInfoRow(
                      context,
                      icon: Icons.pets,
                      label: 'Breed',
                      value: pet.breed,
                    ),
                    _buildInfoRow(
                      context,
                      icon: Icons.cake,
                      label: 'Age',
                      value: '${pet.age} ${pet.age == 1 ? 'year' : 'years'}',
                    ),
                    _buildInfoRow(
                      context,
                      icon: pet.gender == 'male' ? Icons.male : Icons.female,
                      label: 'Gender',
                      value:
                          pet.gender != null ? pet.gender!.toUpperCase() : '',
                    ),
                    _buildInfoRow(
                      context,
                      icon: Icons.palette,
                      label: 'Color',
                      value: pet.color ?? 'Not specified',
                    ),
                    if (pet.weight != null)
                      _buildInfoRow(
                        context,
                        icon: Icons.monitor_weight,
                        label: 'Weight',
                        value: '${pet.weight} kg',
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error loading pet: $error')),
    );
    // All widget code referencing pet must be inside petQuery.when. No code should follow this block.
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryGreen),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.deletePet),
        content: const Text(AppStrings.deletePetConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await ref.read(deletePetProvider(petId).future);
                if (context.mounted) {
                  context.pop(); // Go back to pet list
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppStrings.petDeletedSuccessfully),
                    ),
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
            child: const Text(
              AppStrings.delete,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
