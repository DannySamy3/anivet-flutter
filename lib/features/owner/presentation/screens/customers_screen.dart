import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:annivet/core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:annivet/features/customers/presentation/providers/customer_providers.dart';
import 'package:annivet/features/customers/domain/entities/customer.dart';
import 'package:annivet/core/widgets/loading_indicator.dart';
import 'package:annivet/core/widgets/app_error_widget.dart';

class CustomersScreen extends ConsumerWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersQuery = ref.watch(allCustomersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          'Clinic Customers',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(allCustomersProvider),
          ),
        ],
      ),
      body: customersQuery.when(
        data: (customers) {
          return Column(
            children: [
              // Search Bar (Local Filtering)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search customers...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              
              // Customer List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => ref.refresh(allCustomersProvider),
                  child: customers.isEmpty 
                    ? const Center(child: Text('No customers found'))
                    : ListView.builder(
                        itemCount: customers.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final customer = customers[index];
                          return _CustomerListItem(customer: customer);
                        },
                      ),
                ),
              ),
            ],
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stackTrace) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(allCustomersProvider),
        ),
      ),
    );
  }
}

class _CustomerListItem extends StatelessWidget {
  final Customer customer;

  const _CustomerListItem({required this.customer});

  @override
  Widget build(BuildContext context) {
    final petCount = customer.pets.length;
    final petLabel = petCount == 1 ? '1 Pet' : '$petCount Pets';

    return GestureDetector(
      onTap: () => context.push('/owner/customers/${customer.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
              child: Text(
                customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  Text(
                    customer.email,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (customer.phone.isNotEmpty)
                    Text(
                      customer.phone,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    petLabel,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                if (customer.orders.isNotEmpty || customer.boardings.isNotEmpty)
                  Text(
                    'Active Client',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
