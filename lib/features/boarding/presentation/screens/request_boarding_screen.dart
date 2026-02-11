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
  late TextEditingController _instructionsController;

  String? _selectedPetId;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dailyRateController = TextEditingController(text: '50.00');
    _instructionsController = TextEditingController();
  }

  @override
  void dispose() {
    _dailyRateController.dispose();
    _instructionsController.dispose();
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
                  const SizedBox(height: 16),

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

                  AppTextField(
                    controller: _dailyRateController,
                    label: 'Daily Rate',
                    prefixIcon: Icons.attach_money,
                    inputType: TextInputType.number,
                    enabled: false, // Admin sets this
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _instructionsController,
                    label: 'Special Instructions (optional)',
                    prefixIcon: Icons.notes,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // Cost estimate
                  if (_checkInDate != null && _checkOutDate != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Duration:'),
                                Text(
                                    '${_checkOutDate!.difference(_checkInDate!).inDays} days'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Daily Rate:'),
                                Text('\$${_dailyRateController.text}'),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Estimated Total:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  '\$${(_checkOutDate!.difference(_checkInDate!).inDays * double.parse(_dailyRateController.text)).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),

                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : AppButton.primary(
                          onPressed: _submitRequest,
                          text: 'Submit Request',
                        ),
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

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    if (_checkInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select check-in date')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final data = {
      'petId': _selectedPetId!,
      'checkIn': _checkInDate!.toIso8601String(),
      if (_checkOutDate != null) 'checkOut': _checkOutDate!.toIso8601String(),
      'dailyRate': double.parse(_dailyRateController.text),
      if (_instructionsController.text.isNotEmpty)
        'instructions': _instructionsController.text,
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
