import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:annivet/core/constants/app_colors.dart';

class ClinicManagementScreen extends ConsumerStatefulWidget {
  const ClinicManagementScreen({super.key});

  @override
  ConsumerState<ClinicManagementScreen> createState() =>
      _ClinicManagementScreenState();
}

class _ClinicManagementScreenState
    extends ConsumerState<ClinicManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // Form controllers
  final _nameCtrl = TextEditingController(text: 'ANNIVET Veterinary Clinic');
  final _addressCtrl = TextEditingController(text: '');
  final _phoneCtrl = TextEditingController(text: '');
  final _emailCtrl = TextEditingController(text: '');
  final _descriptionCtrl = TextEditingController(text: '');
  final _hoursCtrl =
      TextEditingController(text: 'Mon–Fri: 8AM–6PM, Sat: 8AM–2PM');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _descriptionCtrl.dispose();
    _hoursCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: CustomScrollView(
        slivers: [
          // Gradient header
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
                      const Icon(Icons.local_hospital_rounded,
                          color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Clinic Management',
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
                    'Manage your clinic information and contact details',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.8),
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
                      _SectionCard(
                        title: 'Clinic Information',
                        icon: Icons.business_rounded,
                        children: [
                          _FormField(
                            label: 'Clinic Name',
                            controller: _nameCtrl,
                            hint: 'ANNIVET Veterinary Clinic',
                            icon: Icons.local_hospital_rounded,
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          _FormField(
                            label: 'Description',
                            controller: _descriptionCtrl,
                            hint:
                                'Professional veterinary services for your pets...',
                            icon: Icons.description_rounded,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                          _FormField(
                            label: 'Address',
                            controller: _addressCtrl,
                            hint: '123 Clinic Street, Dar es Salaam',
                            icon: Icons.location_on_rounded,
                          ),
                          const SizedBox(height: 16),
                          _FormField(
                            label: 'Operating Hours',
                            controller: _hoursCtrl,
                            hint: 'Mon–Fri: 8AM–6PM',
                            icon: Icons.access_time_rounded,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _SectionCard(
                        title: 'Contact Information',
                        icon: Icons.contact_phone_rounded,
                        children: [
                          _FormField(
                            label: 'Phone Number',
                            controller: _phoneCtrl,
                            hint: '+255 700 000 000',
                            icon: Icons.phone_rounded,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          _FormField(
                            label: 'Email Address',
                            controller: _emailCtrl,
                            hint: 'info@annivet.co.tz',
                            icon: Icons.email_rounded,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
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
                                    'Save Changes',
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
          content: Text('Clinic information saved',
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

// ── Shared form widgets ───────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard(
      {required this.title, required this.icon, required this.children});

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
              Icon(icon, size: 18, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
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

class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _FormField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style:
              GoogleFonts.poppins(fontSize: 14, color: AppColors.primaryBlue),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.poppins(fontSize: 14, color: AppColors.textHint),
            prefixIcon: Icon(icon, size: 18, color: AppColors.primaryGreen),
            filled: true,
            fillColor: const Color(0xFFF7F8FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primaryGreen, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}
