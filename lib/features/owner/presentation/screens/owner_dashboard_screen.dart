import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:annivet/core/constants/app_colors.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';
import 'package:annivet/features/boarding/presentation/providers/boarding_providers.dart';
import 'package:annivet/features/reminders/presentation/providers/reminder_providers.dart';
import 'package:annivet/features/pet/presentation/providers/pet_providers.dart';
import 'package:annivet/features/products/presentation/providers/product_providers.dart';
import 'package:annivet/features/products/domain/entities/low_stock_product.dart';
import 'package:annivet/features/reminders/domain/entities/reminder.dart';

class OwnerDashboardScreen extends ConsumerWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingRemindersAsync = ref.watch(upcomingRemindersProvider);
    final lowStockProductsAsync = ref.watch(lowStockProductsProvider);
    final petsAsync = ref.watch(allPetsProvider);
    final user = ref.watch(currentUserProvider);
    final firstName = user?.name.split(' ').first ?? 'Doctor';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: RefreshIndicator(
        color: AppColors.primaryGreen,
        onRefresh: () async {
          ref.invalidate(allBoardingsProvider);
          ref.invalidate(upcomingRemindersProvider);
          ref.invalidate(lowStockProductsProvider);
          ref.invalidate(allPetsProvider);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Professional Greeting Header - Seamless Extension
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFC2185B), Color(0xFF1A3558)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: petsAsync.when(
                  data: (pets) {
                    final remindersCount = upcomingRemindersAsync.maybeWhen(
                      data: (reminders) => reminders.length,
                      orElse: () => 0,
                    );
                    final stockAlertsCount = lowStockProductsAsync.maybeWhen(
                      data: (products) => products.length,
                      orElse: () => 0,
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          '👋 Welcome back, $firstName',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your clinic dashboard is ready',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _HeaderMetric(
                              value: '${pets.length}',
                              label: 'Patients',
                            ),
                            _HeaderMetric(
                              value: '$stockAlertsCount',
                              label: 'Stock Alert',
                            ),
                            _HeaderMetric(
                              value: '$remindersCount',
                              label: 'Reminders',
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  loading: () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        '👋 Welcome back, $firstName',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Loading your clinic data...',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  error: (_, __) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        '👋 Welcome back, $firstName',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your clinic dashboard',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Quick Actions - Reorganized
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryBlue,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            _QuickActionCard(
                              icon: Icons.calendar_today_rounded,
                              label: 'Schedule',
                              color: const Color(0xFF1976D2),
                              onTap: () => context.go('/owner/boarding'),
                            ),
                            _QuickActionCard(
                              icon: Icons.assignment_rounded,
                              label: 'Records',
                              color: const Color(0xFFF57C00),
                              onTap: () => context.go('/owner/medical-records'),
                            ),
                            _QuickActionCard(
                              icon: Icons.notifications_rounded,
                              label: 'Reminders',
                              color: AppColors.primaryGreen,
                              onTap: () => context.go('/owner/reminders'),
                            ),
                            _QuickActionCard(
                              icon: Icons.pets_rounded,
                              label: 'Patients',
                              color: const Color(0xFF7B1FA2),
                              onTap: () => context.go('/owner/pet'),
                            ),
                            _QuickActionCard(
                              icon: Icons.trending_up_rounded,
                              label: 'Analytics',
                              color: const Color(0xFF00796B),
                              onTap: () {},
                            ),
                            _QuickActionCard(
                              icon: Icons.settings_rounded,
                              label: 'Settings',
                              color: const Color(0xFF455A64),
                              onTap: () => context.go('/owner/more'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Health Alerts - Critical Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reminders',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue.withOpacity(0.8),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      upcomingRemindersAsync.when(
                        data: (reminders) {
                          if (reminders.isEmpty) {
                            return _EmptyCard(
                              message: '✓ No upcoming reminders',
                              icon: Icons.check_circle_outline,
                              bgColor:
                                  const Color(0xFF4CAF50).withOpacity(0.08),
                            );
                          }
                          final uniqueReminders = <String, Reminder>{};
                          for (final r in reminders) {
                            uniqueReminders[r.id] = r;
                          }
                          final sortedReminders = uniqueReminders.values.toList()
                            ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

                          return Column(
                            children: sortedReminders
                                .take(3)
                                .map((r) => _HealthAlertCard(reminder: r))
                                .toList(),
                          );
                        },
                        loading: () => const Center(
                            child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(
                              color: AppColors.primaryGreen),
                        )),
                        error: (err, _) => _EmptyCard(
                          message: 'Could not load reminders',
                          icon: Icons.error_outline,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Active Consultations - Patient Care Focus
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stock Alert',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue.withOpacity(0.8),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      lowStockProductsAsync.when(
                        data: (products) {
                          if (products.isEmpty) {
                            return _EmptyCard(
                              message: 'No stock alerts at the moment',
                              icon: Icons.inventory_2_outlined,
                              bgColor:
                                  const Color(0xFF2196F3).withOpacity(0.08),
                            );
                          }
                          final sortedProducts = List<LowStockProduct>.from(products)
                            ..sort((a, b) {
                              final urgencyOrder = {
                                'CRITICAL': 0,
                                'HIGH': 1,
                                'MEDIUM': 2
                              };
                              return (urgencyOrder[a.urgency] ?? 3)
                                  .compareTo(urgencyOrder[b.urgency] ?? 3);
                            });

                          return Column(
                            children: sortedProducts
                                .take(3)
                                .map((p) => _StockAlertCard(product: p))
                                .toList(),
                          );
                        },
                        loading: () => const Center(
                            child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(
                              color: AppColors.primaryGreen),
                        )),
                        error: (err, _) => _EmptyCard(
                          message: 'Error: $err',
                          icon: Icons.error_outline,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widgets ──────────────────────────────────────────────────────────────────

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryBlue.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? bgColor;

  const _EmptyCard({
    required this.message,
    required this.icon,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: (bgColor ?? Colors.white).withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: (bgColor ?? AppColors.textHint).withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: (bgColor ?? AppColors.textHint).withOpacity(0.5)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StockAlertCard extends StatelessWidget {
  final LowStockProduct product;

  const _StockAlertCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final urgencyColor = _urgencyColor(product.urgency);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: urgencyColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.inventory_2_rounded, color: urgencyColor, size: 19),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
                Text(
                  '${product.stock} units left',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: urgencyColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              product.urgency,
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: urgencyColor.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _urgencyColor(String urgency) {
    switch (urgency) {
      case 'CRITICAL':
        return const Color(0xFFE53935);
      case 'HIGH':
        return const Color(0xFFFB8C00);
      case 'MEDIUM':
        return const Color(0xFFFDD835);
      default:
        return AppColors.textHint;
    }
  }
}


class _HealthAlertCard extends StatelessWidget {
  final dynamic reminder;

  const _HealthAlertCard({required this.reminder});

  @override
  Widget build(BuildContext context) {
    final reminderType = (reminder.type ?? 'REMINDER').toString().toUpperCase();
    final alertColor = _alertColor(reminderType);
    final dueDate = reminder.dueDate as DateTime?;
    final dateLabel = dueDate != null
        ? '${dueDate.day}/${dueDate.month}/${dueDate.year}'
        : 'No date';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: alertColor.withOpacity(0.08),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: alertColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_alertIcon(reminderType), color: alertColor, size: 19),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  reminder.message,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
                Text(
                  'Due: $dateLabel',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: alertColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              reminderType,
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: alertColor.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _alertColor(String type) {
    switch (type) {
      case 'VACCINATION':
        return const Color(0xFF2196F3);
      case 'CHECKUP':
        return const Color(0xFF4CAF50);
      case 'MEDICATION':
        return const Color(0xFFFF9800);
      case 'PRESCRIPTION':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9C27B0);
    }
  }

  IconData _alertIcon(String type) {
    switch (type) {
      case 'VACCINATION':
        return Icons.vaccines_rounded;
      case 'CHECKUP':
        return Icons.medical_services_rounded;
      case 'MEDICATION':
        return Icons.medication_rounded;
      case 'PRESCRIPTION':
        return Icons.assignment_rounded;
      default:
        return Icons.notification_important_rounded;
    }
  }
}

class _HeaderMetric extends StatelessWidget {
  final String value;
  final String label;

  const _HeaderMetric({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
