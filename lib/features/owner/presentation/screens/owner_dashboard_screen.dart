import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:annivet/core/constants/app_colors.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';
import 'package:annivet/features/boarding/presentation/providers/boarding_providers.dart';
import 'package:annivet/features/reminders/presentation/providers/reminder_providers.dart';
import 'package:annivet/features/pet/presentation/providers/pet_providers.dart';

class OwnerDashboardScreen extends ConsumerWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(allRemindersProvider);
    final boardingsAsync = ref.watch(allBoardingsProvider);
    final petsAsync = ref.watch(allPetsProvider);
    final user = ref.watch(currentUserProvider);
    final firstName = user?.name.split(' ').first ?? 'Doctor';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: RefreshIndicator(
        color: AppColors.primaryGreen,
        onRefresh: () async {
          ref.invalidate(allBoardingsProvider);
          ref.invalidate(allRemindersProvider);
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
                    final pendingAlerts = remindersAsync.maybeWhen(
                      data: (reminders) =>
                          reminders.where((r) => !r.sent).length,
                      orElse: () => 0,
                    );
                    final activeCases = boardingsAsync.maybeWhen(
                      data: (boardings) => boardings
                          .where((b) =>
                              b.status == 'ACTIVE' || b.status == 'APPROVED')
                          .length,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '${pets.length}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Patients',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.white.withOpacity(0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '$activeCases',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Active Cases',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.white.withOpacity(0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '$pendingAlerts',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Alerts',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.white.withOpacity(0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
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
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.1,
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
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Health Alerts - Critical Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFE53935).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Color(0xFFE53935),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Health Alerts',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () => context.go('/owner/reminders'),
                            child: Text(
                              'View all',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      remindersAsync.when(
                        data: (reminders) {
                          final pendingReminders =
                              reminders.where((r) => !r.sent).take(6).toList();
                          if (pendingReminders.isEmpty) {
                            return _EmptyCard(
                              message: '✓ All patients are up to date',
                              icon: Icons.check_circle_outline,
                              bgColor:
                                  const Color(0xFF4CAF50).withOpacity(0.08),
                            );
                          }
                          return Column(
                            children: pendingReminders
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
                          message: 'Could not load health alerts',
                          icon: Icons.error_outline,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Active Consultations - Patient Care Focus
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF2196F3).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.medical_services_rounded,
                                  color: Color(0xFF2196F3),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Active Cases',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () => context.go('/owner/boarding'),
                            child: Text(
                              'View all',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      boardingsAsync.when(
                        data: (boardings) {
                          final activeCases = boardings
                              .where((b) =>
                                  b.status == 'ACTIVE' ||
                                  b.status == 'APPROVED')
                              .take(5)
                              .toList();
                          if (activeCases.isEmpty) {
                            return _EmptyCard(
                              message: 'No active cases at the moment',
                              icon: Icons.medical_services_outlined,
                              bgColor:
                                  const Color(0xFF2196F3).withOpacity(0.08),
                            );
                          }
                          return Column(
                            children: activeCases
                                .map((b) => _AppointmentCard(boarding: b))
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
                          message: 'Could not load cases',
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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryBlue,
              ),
              textAlign: TextAlign.center,
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(icon,
                size: 36,
                color: bgColor != null
                    ? Colors.black.withOpacity(0.3)
                    : AppColors.textHint),
            const SizedBox(height: 8),
            Text(
              message,
              style: GoogleFonts.poppins(
                  color: AppColors.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final dynamic boarding;

  const _AppointmentCard({required this.boarding});

  @override
  Widget build(BuildContext context) {
    final status = (boarding.status ?? '').toString().toUpperCase();
    final statusColor = _appointmentStatusColor(status);
    final consultationId = 'Case #${boarding.id.toString().substring(0, 8)}';
    final checkIn = boarding.checkIn as DateTime?;
    final dateLabel = checkIn != null
        ? '${checkIn.day}/${checkIn.month}/${checkIn.year}'
        : 'No date';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.medical_services_rounded,
              color: statusColor, size: 20),
        ),
        title: Text(
          consultationId,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          dateLabel,
          style:
              GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
      ),
    );
  }

  Color _appointmentStatusColor(String status) {
    switch (status) {
      case 'ACTIVE':
        return const Color(0xFF4CAF50);
      case 'APPROVED':
        return const Color(0xFF2196F3);
      case 'COMPLETED':
        return const Color(0xFF9C27B0);
      case 'CANCELLED':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFFFFA726);
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: alertColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: alertColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(_alertIcon(reminderType), color: alertColor, size: 20),
        ),
        title: Text(
          reminder.message,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Due: $dateLabel',
          style:
              GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: alertColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            reminderType,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: alertColor,
            ),
          ),
        ),
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
