import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/customer_repository.dart';
import '../../domain/entities/customer.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CustomerRepository(apiService);
});

final allCustomersProvider = FutureProvider<List<Customer>>((ref) async {
  final repository = ref.watch(customerRepositoryProvider);
  return repository.getCustomers();
});

final customerDetailProvider =
    FutureProvider.family<Customer, String>((ref, id) async {
  final repository = ref.watch(customerRepositoryProvider);
  return repository.getCustomerById(id);
});
