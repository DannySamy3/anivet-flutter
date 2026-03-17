import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:annivet/core/constants/app_colors.dart';
import 'package:annivet/features/customers/presentation/providers/customer_providers.dart';
import 'package:annivet/features/customers/domain/entities/customer.dart';
import 'package:annivet/core/widgets/loading_indicator.dart';
import 'package:annivet/core/widgets/app_error_widget.dart';

class CustomerDetailScreen extends ConsumerWidget {
  final String customerId;

  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailQuery = ref.watch(customerDetailProvider(customerId));

    return detailQuery.when(
      data: (customer) => _CustomerDetailScaffold(customer: customer),
      loading: () => Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
        body: const LoadingIndicator(),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
        body: AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(customerDetailProvider(customerId)),
        ),
      ),
    );
  }
}

class _CustomerDetailScaffold extends StatelessWidget {
  final Customer customer;

  const _CustomerDetailScaffold({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: CustomScrollView(
        slivers: [
          // Elegant Header with Name in AppBar
          SliverAppBar(
            pinned: true,
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primaryBlue,
            title: Text(
              customer.name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: AppColors.primaryBlue,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContactSection(),
                  const SizedBox(height: 24),
                  
                  _buildSectionHeader('Account Overview'),
                  _buildCustomerStats(),
                  const SizedBox(height: 24),
                  
                  _buildSectionHeader('Registered Patients'),
                  ...customer.pets.map((pet) => _PetCard(pet: pet)),
                  
                  const SizedBox(height: 24),
                  _buildSectionHeader('Transaction History'),
                  if (customer.orders.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(child: Text('No previous orders')),
                    )
                  else
                    ...customer.orders.map((order) => _OrderCard(order: order)),
                  
                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          _ContactItem(icon: Icons.email_outlined, value: customer.email, flex: 3),
          Container(height: 16, width: 1, color: AppColors.primaryBlue.withOpacity(0.1), margin: const EdgeInsets.symmetric(horizontal: 8)),
          _ContactItem(icon: Icons.phone_outlined, value: customer.phone, flex: 2),
        ],
      ),
    );
  }

  Widget _buildCustomerStats() {
    return Row(
      children: [
        _StatItem(label: 'Total Pets', value: customer.pets.length.toString(), icon: Icons.pets_outlined),
        const SizedBox(width: 12),
        _StatItem(label: 'Orders', value: customer.orders.length.toString(), icon: Icons.shopping_bag_outlined),
        const SizedBox(width: 12),
        _StatItem(label: 'Boardings', value: customer.boardings.length.toString(), icon: Icons.hotel_outlined),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final int flex;

  const _ContactItem({required this.icon, required this.value, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primaryBlue.withOpacity(0.5)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryGreen),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: AppColors.textHint,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final CustomerPet pet;

  const _PetCard({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.pets, color: AppColors.primaryGreen, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      pet.breed,
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFFB0B8C1)),
            ],
          ),
          if (pet.medicalRecords != null && pet.medicalRecords!.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                Icon(Icons.history_edu_outlined, size: 14, color: AppColors.textHint),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    pet.medicalRecords![0].description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final CustomerOrder order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: 'Tsh ', decimalDigits: 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order #${order.id.substring(0, 8).toUpperCase()}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primaryBlue),
              ),
              if (order.createdAt != null)
                Text(
                  DateFormat.yMMMd().format(order.createdAt!),
                  style: TextStyle(fontSize: 11, color: AppColors.textHint),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currencyFormat.format(order.totalPrice),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              _StatusBadge(status: order.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'FULFILLED':
        color = AppColors.success;
        break;
      case 'PENDING':
        color = Colors.amber[800]!;
        break;
      default:
        color = AppColors.textHint;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
