import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:annivet/core/constants/app_colors.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';

class OwnerMoreScreen extends ConsumerWidget {
  const OwnerMoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          // Header with user info
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // User info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Clinic Owner',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? 'owner@clinic.com',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'CLINIC OWNER',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Menu sections
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Account section
                _MenuSectionTitle('Account'),
                const SizedBox(height: 8),
                _MenuItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  onTap: () => context.go('/owner/profile'),
                ),
                const SizedBox(height: 24),

                // Management section
                _MenuSectionTitle('Management'),
                const SizedBox(height: 8),
                _MenuItem(
                  icon: Icons.local_hospital_rounded,
                  label: 'Clinic Information',
                  onTap: () => context.go('/owner/clinic'),
                ),
                _MenuItem(
                  icon: Icons.pets_rounded,
                  label: 'My Pets',
                  onTap: () => context.go('/owner/pets'),
                ),
                _MenuItem(
                  icon: Icons.medical_information_rounded,
                  label: 'Medical Records',
                  onTap: () => context.go('/owner/medical-records'),
                ),
                _MenuItem(
                  icon: Icons.medication_rounded,
                  label: 'Products & Inventory',
                  onTap: () => context.go('/owner/products'),
                ),
                _MenuItem(
                  icon: Icons.price_change_rounded,
                  label: 'Pricing Configuration',
                  onTap: () => context.go('/owner/pricing'),
                ),
                _MenuItem(
                  icon: Icons.people_outline_rounded,
                  label: 'Customers',
                  onTap: () => context.go('/owner/customers'),
                ),
                const SizedBox(height: 24),

                // Settings section
                _MenuSectionTitle('Settings'),
                const SizedBox(height: 8),
                _MenuItem(
                  icon: Icons.settings_rounded,
                  label: 'App Settings',
                  onTap: () => context.go('/owner/settings'),
                ),
                _MenuItem(
                  icon: Icons.notifications_rounded,
                  label: 'Notifications',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Notification settings coming soon')),
                    );
                  },
                ),
                const SizedBox(height: 24),

                const SizedBox(height: 8),

                // Logout
                _MenuItem(
                  icon: Icons.logout_rounded,
                  label: 'Log Out',
                  color: AppColors.error,
                  onTap: () => _showLogoutConfirmation(context, ref),
                ),

                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Log Out',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to log out of your account?',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
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

// Menu item widget
class _MenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final itemColor = widget.color ?? AppColors.primaryGreen;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _isPressed ? itemColor.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isPressed ? itemColor.withOpacity(0.2) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 22,
              color: itemColor,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                widget.label,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: const Color(0xFFB0B8C1),
            ),
          ],
        ),
      ),
    );
  }
}

// Section title widget
class _MenuSectionTitle extends StatelessWidget {
  final String title;

  const _MenuSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }
}
