import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:annivet/core/constants/app_colors.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';

class OwnerScaffold extends ConsumerStatefulWidget {
  final Widget child;
  const OwnerScaffold({super.key, required this.child});

  @override
  ConsumerState<OwnerScaffold> createState() => _OwnerScaffoldState();
}

class _OwnerScaffoldState extends ConsumerState<OwnerScaffold> {
  // Bottom nav priority items - reduced to 4 essential items for cleaner UI
  static const List<_OwnerNavItem> _bottomItems = [
    _OwnerNavItem(
        path: '/owner/dashboard', icon: Icons.home_rounded, label: 'Home'),
    _OwnerNavItem(
        path: '/owner/boarding', icon: Icons.hotel_rounded, label: 'Boarding'),
    _OwnerNavItem(
        path: '/owner/orders',
        icon: Icons.receipt_long_rounded,
        label: 'Orders'),
    _OwnerNavItem(
        path: '/owner/more', icon: Icons.more_horiz_rounded, label: 'More'),
  ];

  int get _selectedBottomIndex {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _bottomItems.length; i++) {
      if (location.startsWith(_bottomItems[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: _buildAppBar(context, user),
      body: widget.child,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, dynamic user) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.primaryBlue,
      titleSpacing: 16,
      centerTitle: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.pets, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            'ANNIVET',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryBlue,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_rounded,
                  color: AppColors.primaryBlue),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications coming soon')),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => context.go('/owner/profile'),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryGreen.withOpacity(0.15),
              child: Text(
                (user?.name.isNotEmpty == true)
                    ? user!.name[0].toUpperCase()
                    : 'O',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final selectedIndex = _selectedBottomIndex;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_bottomItems.length, (i) {
              final item = _bottomItems[i];
              final selected = i == selectedIndex;
              final isMore = item.path == '/owner/more';

              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (isMore) {
                      context.go('/owner/more');
                    } else {
                      context.go(item.path);
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        scale: selected ? 1.1 : 1.0,
                        child: Icon(
                          item.icon,
                          size: 24,
                          color: selected
                              ? AppColors.primaryGreen
                              : const Color(0xFFB0B8C1),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w500,
                          color: selected
                              ? AppColors.primaryGreen
                              : const Color(0xFFB0B8C1),
                          letterSpacing: 0.2,
                        ),
                      ),
                      if (selected && !isMore)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
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

class _OwnerNavItem {
  final String path;
  final IconData icon;
  final String label;

  const _OwnerNavItem({
    required this.path,
    required this.icon,
    required this.label,
  });
}
