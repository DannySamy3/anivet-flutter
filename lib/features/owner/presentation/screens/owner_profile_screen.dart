import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:annivet/core/constants/app_colors.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';

class OwnerProfileScreen extends ConsumerStatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  ConsumerState<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends ConsumerState<OwnerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _isSaving = false;

  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _emailCtrl = TextEditingController(text: user?.email ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final initials = (user?.name.isNotEmpty == true)
        ? user!.name
            .trim()
            .split(' ')
            .map((w) => w.isNotEmpty ? w[0] : '')
            .take(2)
            .join()
            .toUpperCase()
        : 'O';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: CustomScrollView(
        slivers: [
          // Header with avatar
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
              child: Column(
                children: [
                  // Avatar circle
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user?.name ?? 'Clinic Owner',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'OWNER',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
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
                // Profile info card
                Container(
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Profile Information',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () =>
                                  setState(() => _isEditing = !_isEditing),
                              icon: Icon(
                                _isEditing ? Icons.close : Icons.edit_rounded,
                                size: 16,
                                color: AppColors.primaryGreen,
                              ),
                              label: Text(
                                _isEditing ? 'Cancel' : 'Edit',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        _ProfileField(
                          label: 'Full Name',
                          controller: _nameCtrl,
                          icon: Icons.person_rounded,
                          enabled: _isEditing,
                        ),
                        const SizedBox(height: 14),
                        _ProfileField(
                          label: 'Email Address',
                          controller: _emailCtrl,
                          icon: Icons.email_rounded,
                          enabled: false, // email usually not editable
                        ),
                        const SizedBox(height: 14),
                        _ProfileField(
                          label: 'Phone Number',
                          controller: _phoneCtrl,
                          icon: Icons.phone_rounded,
                          enabled: _isEditing,
                          keyboardType: TextInputType.phone,
                        ),
                        if (_isEditing) ...[
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ElevatedButton(
                                onPressed: _isSaving ? null : _saveProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: _isSaving
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2),
                                      )
                                    : Text(
                                        'Save Profile',
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Account actions
                Container(
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
                    children: [
                      _ActionTile(
                        icon: Icons.lock_outline_rounded,
                        label: 'Change Password',
                        color: AppColors.primaryBlue,
                        onTap: () => _showChangePasswordSheet(context),
                      ),
                      const Divider(height: 1, indent: 56),
                      _ActionTile(
                        icon: Icons.settings_rounded,
                        label: 'App Settings',
                        color: AppColors.primaryBlue,
                        onTap: () => context.go('/owner/settings'),
                      ),
                      const Divider(height: 1, indent: 56),
                      _ActionTile(
                        icon: Icons.help_outline_rounded,
                        label: 'Help & Support',
                        color: AppColors.primaryBlue,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Logout button
                Container(
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
                  child: _ActionTile(
                    icon: Icons.logout_rounded,
                    label: 'Log Out',
                    color: AppColors.error,
                    labelColor: AppColors.error,
                    onTap: () => _showLogoutConfirmation(context),
                  ),
                ),

                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'ANNIVET v1.0.0',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: AppColors.textHint),
                  ),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isSaving = false;
      _isEditing = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated',
              style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _showChangePasswordSheet(BuildContext context) {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Change Password',
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              _PasswordField(label: 'Current Password', ctrl: oldPassCtrl),
              const SizedBox(height: 12),
              _PasswordField(label: 'New Password', ctrl: newPassCtrl),
              const SizedBox(height: 12),
              _PasswordField(label: 'Confirm New Password', ctrl: confirmCtrl),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Password updated',
                              style: GoogleFonts.poppins(color: Colors.white)),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Update Password',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Log Out',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text('Are you sure you want to log out of your account?',
            style: GoogleFonts.poppins(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(authStateProvider.notifier).logout();
            },
            child: Text('Log Out',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool enabled;
  final TextInputType? keyboardType;

  const _ProfileField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.enabled,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          style:
              GoogleFonts.poppins(fontSize: 14, color: AppColors.primaryBlue),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: AppColors.primaryGreen),
            filled: true,
            fillColor:
                enabled ? const Color(0xFFF7F8FA) : const Color(0xFFF0F0F0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primaryGreen, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color? labelColor;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    this.labelColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: labelColor ?? AppColors.primaryBlue,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          color: AppColors.textSecondary, size: 20),
      onTap: onTap,
    );
  }
}

class _PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController ctrl;

  const _PasswordField({required this.label, required this.ctrl});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.ctrl,
      obscureText: _obscure,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: GoogleFonts.poppins(fontSize: 13),
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
        suffixIcon: IconButton(
          icon: Icon(
              _obscure
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              size: 18,
              color: AppColors.textSecondary),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }
}
