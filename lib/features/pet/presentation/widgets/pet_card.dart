import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:annivet/features/pet/domain/entities/pet.dart';
import 'package:annivet/core/constants/app_colors.dart';
import 'package:annivet/core/constants/app_enums.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback? onTap;

  const PetCard({super.key, required this.pet, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Pet image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: pet.photoUrl != null
                    ? CachedNetworkImage(
                        imageUrl: pet.photoUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 60,
                          height: 60,
                          color: AppColors.surfaceVariant,
                          child: const Icon(Icons.pets, size: 30),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 60,
                          height: 60,
                          color: AppColors.surfaceVariant,
                          child: const Icon(Icons.pets, size: 30),
                        ),
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        color: AppColors.surfaceVariant,
                        child: Icon(
                          _getPetIcon(pet.species),
                          size: 30,
                          color: AppColors.primaryGreen,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              // Pet info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet.breed} • ${pet.age} ${pet.age == 1 ? 'year' : 'years'}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          pet.gender == 'male' ? Icons.male : Icons.female,
                          size: 16,
                          color: pet.gender == 'male'
                              ? Colors.blue
                              : Colors.pink,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          (pet.gender ?? 'unknown').toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPetIcon(PetSpecies species) {
    switch (species) {
      case PetSpecies.dog:
        return Icons.pets;
      case PetSpecies.cat:
        return Icons.pets;
      case PetSpecies.bird:
        return Icons.flutter_dash;
      case PetSpecies.rabbit:
        return Icons.cruelty_free;
      case PetSpecies.other:
        return Icons.pets;
    }
  }
}
