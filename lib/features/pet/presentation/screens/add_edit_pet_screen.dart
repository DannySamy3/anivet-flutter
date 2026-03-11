import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/pet_providers.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_enums.dart';
import 'package:annivet/features/pet/domain/entities/pet.dart';

class AddEditPetScreen extends ConsumerStatefulWidget {
  final String? petId; // null for add, non-null for edit

  const AddEditPetScreen({super.key, this.petId});

  @override
  ConsumerState<AddEditPetScreen> createState() => _AddEditPetScreenState();
}

class _AddEditPetScreenState extends ConsumerState<AddEditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _colorController = TextEditingController();
  final _weightController = TextEditingController();

  PetSpecies _selectedSpecies = PetSpecies.dog;
  String _selectedGender = 'male';
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.petId != null) {
      _loadPetData();
    }
  }

  void _loadPetData() {
    // Load pet data for editing
    final petQuery = ref.read(petDetailProvider(widget.petId!));
    petQuery.when(
      data: (pet) {
        _nameController.text = pet.name;
        _breedController.text = pet.breed;
        _ageController.text = pet.age.toString();
        _colorController.text = pet.color ?? '';
        _weightController.text = pet.weight?.toString() ?? '';
        _selectedSpecies = pet.species;
        _selectedGender = pet.gender ?? 'male';
      },
      loading: () {},
      error: (_, __) {},
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _colorController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final ownerId = 'currentUserId'; // TODO: Replace with actual user id
      final now = DateTime.now();
      if (widget.petId != null) {
        // Update existing pet
        final pet = Pet(
          id: widget.petId!,
          name: _nameController.text,
          species: _selectedSpecies,
          breed: _breedController.text,
          age: int.parse(_ageController.text),
          ownerId: ownerId,
          gender: _selectedGender,
          color:
              _colorController.text.isNotEmpty ? _colorController.text : null,
          weight: _weightController.text.isNotEmpty
              ? double.parse(_weightController.text)
              : null,
          createdAt: now,
        );
        await ref.read(updatePetProvider({
          'id': widget.petId!,
          ...{
            'name': pet.name,
            'species': pet.species,
            'breed': pet.breed,
            'age': pet.age,
            'ownerId': pet.ownerId,
            'gender': pet.gender,
            'color': pet.color,
            'weight': pet.weight,
            'createdAt': pet.createdAt,
          }
        }).future);
      } else {
        // Create new pet
        final newPet = await ref.read(createPetProvider(Pet(
          id: '', // Will be set by backend
          name: _nameController.text,
          species: _selectedSpecies,
          breed: _breedController.text,
          age: int.parse(_ageController.text),
          ownerId: ownerId,
          gender: _selectedGender,
          color:
              _colorController.text.isNotEmpty ? _colorController.text : null,
          weight: _weightController.text.isNotEmpty
              ? double.parse(_weightController.text)
              : null,
          createdAt: now,
        )).future);

        // Upload photo if selected
        if (_selectedImage != null) {
          await ref.read(uploadPetPhotoProvider({
            'petId': newPet.id,
            'filePath': _selectedImage!.path,
          }).future);
        }
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.petId != null
                  ? AppStrings.petUpdatedSuccessfully
                  : AppStrings.petCreatedSuccessfully,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.petId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? AppStrings.editPet : AppStrings.addPet),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Photo picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 48,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppStrings.tapToAddPhoto,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Name
              AppTextField(
                controller: _nameController,
                label: AppStrings.petName,
                hint: 'e.g., Buddy',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseEnterPetName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Species dropdown
              DropdownButtonFormField<PetSpecies>(
                value: _selectedSpecies,
                decoration: InputDecoration(
                  labelText: AppStrings.species,
                  border: const OutlineInputBorder(),
                ),
                items: PetSpecies.values.map((species) {
                  return DropdownMenuItem(
                    value: species,
                    child: Text(species.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedSpecies = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Breed
              AppTextField(
                controller: _breedController,
                label: AppStrings.breed,
                hint: 'e.g., Golden Retriever',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseEnterBreed;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Age
              AppTextField(
                controller: _ageController,
                label: AppStrings.age,
                hint: 'in years',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseEnterAge;
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Gender
              Text(
                AppStrings.gender,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Male'),
                      value: 'male',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedGender = value);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Female'),
                      value: 'female',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedGender = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Color (optional)
              AppTextField(
                controller: _colorController,
                label: '${AppStrings.color} (Optional)',
                hint: 'e.g., Brown',
              ),
              const SizedBox(height: 16),

              // Weight (optional)
              AppTextField(
                controller: _weightController,
                label: '${AppStrings.weight} (Optional)',
                hint: 'in kg',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),

              // Submit button
              AppButton.primary(
                onPressed: _submit,
                text: isEdit ? AppStrings.updatePet : AppStrings.addPet,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
