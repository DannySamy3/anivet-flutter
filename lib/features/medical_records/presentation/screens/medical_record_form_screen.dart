import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

import '../../data/dtos/medical_record_dto.dart';
import '../providers/medical_record_providers.dart';

class MedicalRecordFormScreen extends ConsumerStatefulWidget {
  final String petId;
  final String? recordId;

  const MedicalRecordFormScreen({
    super.key,
    required this.petId,
    this.recordId,
  });

  @override
  ConsumerState<MedicalRecordFormScreen> createState() =>
      _MedicalRecordFormScreenState();
}

class _MedicalRecordFormScreenState
    extends ConsumerState<MedicalRecordFormScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _veterinarianController;
  late final TextEditingController _notesController;

  String _selectedType = 'vaccination';
  DateTime _selectedRecordDate = DateTime.now();
  DateTime? _selectedDueDate;
  bool _isLoading = false;

  final List<String> recordTypes = [
    'vaccination',
    'checkup',
    'treatment',
    'surgery',
    'medication',
    'grooming',
    'other'
  ];

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _veterinarianController = TextEditingController();
    _notesController = TextEditingController();

    // Load existing record if editing
    if (widget.recordId != null) {
      _loadRecord();
    }
  }

  void _loadRecord() async {
    try {
      final repository = ref.read(medicalRecordRepositoryProvider);
      final record = await repository.getMedicalRecordById(widget.recordId!);

      setState(() {
        _titleController.text = record.title;
        _descriptionController.text = record.description;
        _veterinarianController.text = record.veterinarian ?? '';
        _notesController.text = record.notes ?? '';
        _selectedType = record.type;
        _selectedRecordDate = record.recordDate;
        _selectedDueDate = record.dueDate;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading record: $e')),
        );
      }
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    bool isDueDate,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          isDueDate ? _selectedDueDate ?? DateTime.now() : _selectedRecordDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isDueDate) {
          _selectedDueDate = picked;
        } else {
          _selectedRecordDate = picked;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final dto = MedicalRecordDto.create(
        petId: widget.petId,
        type: _selectedType,
        title: _titleController.text,
        description: _descriptionController.text,
        recordDate: _selectedRecordDate,
        dueDate: _selectedDueDate,
        veterinarian: _veterinarianController.text.isEmpty
            ? null
            : _veterinarianController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      if (widget.recordId != null) {
        // Update
        await ref.read(medicalRecordRepositoryProvider).updateMedicalRecord(
              widget.recordId!,
              dto.toJson(),
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Medical record updated successfully')),
          );
        }
      } else {
        // Create
        await ref.read(medicalRecordRepositoryProvider).createMedicalRecord(
              widget.petId,
              dto,
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Medical record created successfully')),
          );
        }
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.recordId != null ? 'Edit Record' : 'New Medical Record'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Record Type Dropdown
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'Record Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.category),
              ),
              items: recordTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.capitalize()),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Title
            AppTextField(
              controller: _titleController,
              label: 'Title',
              hint: 'e.g., Annual Vaccination',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              prefixIcon: Icons.title,
            ),
            const SizedBox(height: 16),

            // Description
            AppTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Provide details about this record',
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              prefixIcon: Icons.description,
            ),
            const SizedBox(height: 16),

            // Record Date
            InkWell(
              onTap: () => _selectDate(context, false),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Record Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(
                  '${_selectedRecordDate.year}-${_selectedRecordDate.month.toString().padLeft(2, '0')}-${_selectedRecordDate.day.toString().padLeft(2, '0')}',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Due Date (Optional)
            InkWell(
              onTap: () => _selectDate(context, true),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Due Date (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.event_note),
                  helperText: 'For recurring records (e.g., vaccinations)',
                ),
                child: Text(
                  _selectedDueDate != null
                      ? '${_selectedDueDate!.year}-${_selectedDueDate!.month.toString().padLeft(2, '0')}-${_selectedDueDate!.day.toString().padLeft(2, '0')}'
                      : 'Not set',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Veterinarian (Optional)
            AppTextField(
              controller: _veterinarianController,
              label: 'Veterinarian Name (Optional)',
              hint: 'e.g., Dr. Smith',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),

            // Notes (Optional)
            AppTextField(
              controller: _notesController,
              label: 'Additional Notes (Optional)',
              hint: 'Add any extra information',
              maxLines: 2,
              prefixIcon: Icons.notes,
            ),
            const SizedBox(height: 32),

            // Submit Button
            AppButton(
              text: widget.recordId != null ? 'Update Record' : 'Create Record',
              onPressed: _isLoading ? null : _submitForm,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _veterinarianController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

extension _StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
