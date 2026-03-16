import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:annivet/core/constants/app_colors.dart';

class PricingScreen extends ConsumerStatefulWidget {
  const PricingScreen({super.key});

  @override
  ConsumerState<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends ConsumerState<PricingScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // Boarding pricing
  final _dailyRateCtrl = TextEditingController(text: '50000');
  final _medicationFeeCtrl = TextEditingController(text: '5000');
  final _groomingFeeCtrl = TextEditingController(text: '30000');
  final _pickupFeeCtrl = TextEditingController(text: '20000');

  // Consultation pricing
  final _consultationFeeCtrl = TextEditingController(text: '25000');
  final _vaccinationFeeCtrl = TextEditingController(text: '15000');
  final _examinationFeeCtrl = TextEditingController(text: '20000');

  @override
  void dispose() {
    _dailyRateCtrl.dispose();
    _medicationFeeCtrl.dispose();
    _groomingFeeCtrl.dispose();
    _pickupFeeCtrl.dispose();
    _consultationFeeCtrl.dispose();
    _vaccinationFeeCtrl.dispose();
    _examinationFeeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.price_change_rounded,
                          color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Pricing Configuration',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Set rates for all clinic services (TZS)',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Owner-only badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_rounded,
                            size: 14, color: Colors.amber),
                        const SizedBox(width: 6),
                        Text(
                          'Owner-only access',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.amber.shade200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Boarding pricing
                      _PriceSection(
                        title: 'Boarding Services',
                        icon: Icons.hotel_rounded,
                        color: AppColors.primaryBlue,
                        children: [
                          _PriceField(
                            label: 'Daily Boarding Rate',
                            controller: _dailyRateCtrl,
                            description: 'Base rate per day per pet',
                          ),
                          const SizedBox(height: 16),
                          _PriceField(
                            label: 'Medication Administration Fee',
                            controller: _medicationFeeCtrl,
                            description: 'Per medication session',
                          ),
                          const SizedBox(height: 16),
                          _PriceField(
                            label: 'Grooming Fee',
                            controller: _groomingFeeCtrl,
                            description: 'Full grooming session',
                          ),
                          const SizedBox(height: 16),
                          _PriceField(
                            label: 'Pickup & Dropoff Fee',
                            controller: _pickupFeeCtrl,
                            description: 'Door-to-door transport',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Consultation pricing
                      _PriceSection(
                        title: 'Clinic Services',
                        icon: Icons.medical_services_rounded,
                        color: const Color(0xFF00897B),
                        children: [
                          _PriceField(
                            label: 'Consultation Fee',
                            controller: _consultationFeeCtrl,
                            description: 'Standard vet consultation',
                          ),
                          const SizedBox(height: 16),
                          _PriceField(
                            label: 'Vaccination Fee',
                            controller: _vaccinationFeeCtrl,
                            description: 'Per vaccination',
                          ),
                          const SizedBox(height: 16),
                          _PriceField(
                            label: 'Examination Fee',
                            controller: _examinationFeeCtrl,
                            description: 'Physical examination',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Pricing summary preview
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppColors.primaryBlue.withOpacity(0.15)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.info_outline_rounded,
                                    size: 16, color: AppColors.primaryBlue),
                                const SizedBox(width: 6),
                                Text(
                                  'Current Pricing Summary',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _SummaryRow(
                                'Daily rate', 'TZS ${_dailyRateCtrl.text}'),
                            _SummaryRow(
                                'Grooming', 'TZS ${_groomingFeeCtrl.text}'),
                            _SummaryRow(
                                'Pickup/Dropoff', 'TZS ${_pickupFeeCtrl.text}'),
                            _SummaryRow('Medication admin',
                                'TZS ${_medicationFeeCtrl.text}'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Save button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2),
                                  )
                                : Text(
                                    'Save Pricing',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pricing updated successfully',
              style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}

class _PriceSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _PriceSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _PriceField extends StatelessWidget {
  final String label;
  final String description;
  final TextEditingController controller;

  const _PriceField({
    required this.label,
    required this.description,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlue,
                ),
              ),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
            decoration: InputDecoration(
              prefixText: 'TZS ',
              prefixStyle: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: const Color(0xFFF7F8FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: AppColors.primaryGreen, width: 1.5),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Required';
              if (double.tryParse(v) == null) return 'Invalid';
              return null;
            },
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textSecondary)),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue)),
        ],
      ),
    );
  }
}
