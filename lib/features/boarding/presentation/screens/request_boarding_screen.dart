import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/boarding_providers.dart';
import '../../../pet/presentation/providers/pet_providers.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/loading_indicator.dart';

class RequestBoardingScreen extends ConsumerStatefulWidget {
  const RequestBoardingScreen({super.key});

  @override
  ConsumerState<RequestBoardingScreen> createState() =>
      _RequestBoardingScreenState();
}

class _RequestBoardingScreenState extends ConsumerState<RequestBoardingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dailyRateController;
  late TextEditingController _medicationAdminFeeController;
  late TextEditingController _groomingFeeController;
  late TextEditingController _pickupDropoffFeeController;
  late TextEditingController _specialInstructionsController;
  late TextEditingController _numberOfDaysController;
  late TextEditingController _medicationAdminDaysController;

  String? _selectedPetId;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  bool _groomingRequired = false;
  bool _pickupDropoffRequired = false;
  int _medicationAdminDays = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dailyRateController = TextEditingController(text: '50000');
    _medicationAdminFeeController = TextEditingController(text: '5000');
    _groomingFeeController = TextEditingController(text: '30000');
    _pickupDropoffFeeController = TextEditingController(text: '20000');
    _specialInstructionsController = TextEditingController();
    _numberOfDaysController = TextEditingController(text: '1');
    _medicationAdminDaysController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _dailyRateController.dispose();
    _medicationAdminFeeController.dispose();
    _groomingFeeController.dispose();
    _pickupDropoffFeeController.dispose();
    _specialInstructionsController.dispose();
    _numberOfDaysController.dispose();
    _medicationAdminDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myPetsQuery = ref.watch(myPetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Boarding'),
      ),
      body: myPetsQuery.when(
        data: (pets) {
          if (pets.isEmpty) {
            return const Center(
              child: Text('Please add a pet first before requesting boarding'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pet selection
                  DropdownButtonFormField<String>(
                    value: _selectedPetId,
                    decoration: const InputDecoration(
                      labelText: 'Select Pet',
                      prefixIcon: Icon(Icons.pets),
                      border: OutlineInputBorder(),
                    ),
                    items: pets.map((pet) {
                      return DropdownMenuItem(
                        value: pet.id,
                        child: Text('${pet.name} (${pet.species})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPetId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a pet';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Check-in date
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Check-in Date'),
                    subtitle: Text(
                      _checkInDate != null
                          ? _formatDate(_checkInDate!)
                          : 'Select date',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _selectCheckInDate(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Check-out date
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Check-out Date (optional)'),
                    subtitle: Text(
                      _checkOutDate != null
                          ? _formatDate(_checkOutDate!)
                          : 'Select date',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _selectCheckOutDate(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Number of days
                  AppTextField(
                    controller: _numberOfDaysController,
                    label: 'Number of Days',
                    hint: 'Default: 1',
                    inputType: TextInputType.number,
                    prefixIcon: Icons.schedule,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final days = int.tryParse(value);
                        if (days == null || days < 1) {
                          return 'Please enter a valid number of days';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Daily Rate Section
                  Text(
                    'Pricing',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),

                  AppTextField(
                    controller: _dailyRateController,
                    label: 'Daily Rate (Required)',
                    prefixIcon: Icons.attach_money,
                    inputType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter daily rate';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Medication Administration Section
                  Text(
                    'Additional Services',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),

                  AppTextField(
                    controller: _medicationAdminDaysController,
                    label: 'Medication Admin Days (optional)',
                    hint: 'Default: 0',
                    inputType: TextInputType.number,
                    prefixIcon: Icons.medical_information,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final days = int.tryParse(value);
                        if (days == null || days < 0) {
                          return 'Please enter a valid number';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  AppTextField(
                    controller: _medicationAdminFeeController,
                    label: 'Medication Admin Fee (per day)',
                    hint: 'Default: 5000',
                    inputType: TextInputType.number,
                    prefixIcon: Icons.attach_money,
                  ),
                  const SizedBox(height: 16),

                  // Grooming Service
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Grooming Required'),
                            value: _groomingRequired,
                            onChanged: (value) {
                              setState(
                                  () => _groomingRequired = value ?? false);
                            },
                          ),
                          if (_groomingRequired)
                            AppTextField(
                              controller: _groomingFeeController,
                              label: 'Grooming Fee',
                              hint: 'Default: 30000',
                              inputType: TextInputType.number,
                              prefixIcon: Icons.attach_money,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pickup/Dropoff Service
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Pickup/Dropoff Required'),
                            value: _pickupDropoffRequired,
                            onChanged: (value) {
                              setState(() =>
                                  _pickupDropoffRequired = value ?? false);
                            },
                          ),
                          if (_pickupDropoffRequired)
                            AppTextField(
                              controller: _pickupDropoffFeeController,
                              label: 'Pickup/Dropoff Fee',
                              hint: 'Default: 20000',
                              inputType: TextInputType.number,
                              prefixIcon: Icons.attach_money,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Special Instructions
                  AppTextField(
                    controller: _specialInstructionsController,
                    label: 'Special Instructions (optional)',
                    prefixIcon: Icons.notes,
                    maxLines: 3,
                    hint: 'e.g., dietary restrictions, behavioral notes, etc.',
                  ),
                  const SizedBox(height: 24),

                  // Billing Breakdown Summary
                  if (_checkInDate != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estimated Billing Breakdown',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            _BillingRowSummary(
                              label: 'Daily Charge:',
                              days: _calculateNumberOfDays(),
                              rate: _parseDouble(_dailyRateController.text),
                            ),
                            if (_medicationAdminDays > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: _BillingRowSummary(
                                  label: 'Medication Admin:',
                                  days: _medicationAdminDays,
                                  rate: _parseDouble(
                                      _medicationAdminFeeController.text),
                                ),
                              ),
                            if (_groomingRequired)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Grooming:'),
                                    Text(
                                        '${_parseDouble(_groomingFeeController.text).toStringAsFixed(0)}'),
                                  ],
                                ),
                              ),
                            if (_pickupDropoffRequired)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Pickup/Dropoff:'),
                                    Text(
                                        '${_parseDouble(_pickupDropoffFeeController.text).toStringAsFixed(0)}'),
                                  ],
                                ),
                              ),
                            const Divider(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Estimated Total:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text(
                                  '${_calculateTotal().toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.green),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Submit Button
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : AppButton(
                          text: 'Submit Request',
                          onPressed: _submitRequest,
                        ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) =>
            Center(child: Text('Error loading pets: $error')),
      ),
    );
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _checkInDate = picked;
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate?.add(const Duration(days: 1)) ??
          DateTime.now().add(const Duration(days: 1)),
      firstDate: _checkInDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  int _calculateNumberOfDays() {
    if (_checkOutDate != null && _checkInDate != null) {
      return _checkOutDate!.difference(_checkInDate!).inDays;
    }
    return int.tryParse(_numberOfDaysController.text) ?? 1;
  }

  double _parseDouble(String value) {
    return double.tryParse(value) ?? 0;
  }

  double _calculateTotal() {
    final numDays = _calculateNumberOfDays();
    final dailyRate = _parseDouble(_dailyRateController.text);
    double total = numDays * dailyRate;

    if (_medicationAdminDays > 0) {
      total += _medicationAdminDays *
          _parseDouble(_medicationAdminFeeController.text);
    }

    if (_groomingRequired) {
      total += _parseDouble(_groomingFeeController.text);
    }

    if (_pickupDropoffRequired) {
      total += _parseDouble(_pickupDropoffFeeController.text);
    }

    return total;
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    if (_checkInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select check-in date')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final medicationAdminDays =
        int.tryParse(_medicationAdminDaysController.text) ?? 0;

    final data = {
      'petId': _selectedPetId!,
      'checkIn': _checkInDate!.toIso8601String(),
      if (_checkOutDate != null) 'checkOut': _checkOutDate!.toIso8601String(),
      'numberOfDays': _calculateNumberOfDays(),
      'dailyRate': _parseDouble(_dailyRateController.text),
      'medicationAdminDays': medicationAdminDays,
      'medicationAdminFee': _parseDouble(_medicationAdminFeeController.text),
      'groomingRequired': _groomingRequired,
      'groomingFee': _parseDouble(_groomingFeeController.text),
      'pickupDropoffRequired': _pickupDropoffRequired,
      'pickupDropoffFee': _parseDouble(_pickupDropoffFeeController.text),
      if (_specialInstructionsController.text.isNotEmpty)
        'specialInstructions': _specialInstructionsController.text,
      // NOTE: Do NOT include status or paidAmount
      // Backend will automatically set:
      // - status: 'REQUESTED'
      // - paidAmount: 0
    };

    try {
      await ref.read(createBoardingProvider(data).future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Boarding request submitted successfully')),
        );
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
}

class _BillingRowSummary extends StatelessWidget {
  final String label;
  final int days;
  final double rate;

  const _BillingRowSummary({
    required this.label,
    required this.days,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = days * rate;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
            '$days × ${rate.toStringAsFixed(0)} = ${subtotal.toStringAsFixed(0)}'),
      ],
    );
  }
}
