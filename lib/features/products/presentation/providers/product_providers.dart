import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annivet/features/products/data/repositories/product_repository.dart';
import 'package:annivet/features/products/domain/entities/product.dart';
import 'package:annivet/features/products/domain/entities/low_stock_product.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ProductRepository(apiService);
});

// ============ QUERIES ============

final allProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

final lowStockProductsProvider =
    FutureProvider<List<LowStockProduct>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getLowStockProducts();
});

final productDetailProvider =
    FutureProvider.family<Product, String>((ref, productId) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductById(productId);
});

// ============ MUTATIONS ============

final createProductProvider =
    FutureProvider.family<Product, Map<String, dynamic>>(
        (ref, variables) async {
  final repository = ref.watch(productRepositoryProvider);
  final newProduct = await repository.createProduct(variables);
  ref.invalidate(allProductsProvider);
  return newProduct;
});

final updateProductProvider =
    FutureProvider.family<Product, Map<String, dynamic>>(
        (ref, variables) async {
  final repository = ref.watch(productRepositoryProvider);
  final productId = variables['id'] as String;
  final data = Map<String, dynamic>.from(variables);
  data.remove('id');
  final updatedProduct = await repository.updateProduct(productId, data);
  ref.invalidate(allProductsProvider);
  ref.invalidate(productDetailProvider(productId));
  return updatedProduct;
});

final deleteProductProvider =
    FutureProvider.family<void, String>((ref, productId) async {
  final repository = ref.watch(productRepositoryProvider);
  await repository.deleteProduct(productId);
  ref.invalidate(allProductsProvider);
});
