import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annivet/features/store/data/repositories/store_repository.dart';
import 'package:annivet/features/store/domain/entities/product.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';
import 'package:annivet/core/services/mock_data_service.dart';

// Search state provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Repository provider
final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return StoreRepository(apiService);
});

// ============ QUERIES ============

/// Get all products
final allProductsProvider = FutureProvider<List<Product>>((ref) async {
  // Using mock data for development
  final mockProducts = MockDataService.getMockStoreProducts();
  return mockProducts
      .map((p) => Product(
            id: p['id'] as String,
            clinicId: p['clinicId'] as String,
            name: p['name'] as String,
            description: p['description'] as String,
            price: p['price'] as double,
            stock: p['stock'] as int,
            lowStockThreshold: p['lowStockThreshold'] as int,
            photoUrl: p['photoUrl'] as String?,
            category: p['category'] as String,
            createdAt: DateTime.parse(p['createdAt'] as String),
            updatedAt: DateTime.parse(p['updatedAt'] as String),
          ))
      .toList();
});

/// Get products by category
final productByCategoryProvider =
    FutureProvider.family<List<Product>, String>((ref, category) async {
  // Using mock data for development
  final mockProducts = MockDataService.getMockStoreProducts();
  final filtered = mockProducts
      .where((p) =>
          (p['category'] as String).toLowerCase() == category.toLowerCase())
      .toList();
  return filtered
      .map((p) => Product(
            id: p['id'] as String,
            clinicId: p['clinicId'] as String,
            name: p['name'] as String,
            description: p['description'] as String,
            price: p['price'] as double,
            stock: p['stock'] as int,
            lowStockThreshold: p['lowStockThreshold'] as int,
            photoUrl: p['photoUrl'] as String?,
            category: p['category'] as String,
            createdAt: DateTime.parse(p['createdAt'] as String),
            updatedAt: DateTime.parse(p['updatedAt'] as String),
          ))
      .toList();
});

/// Get filtered products based on search query
final filteredProductsProvider = FutureProvider<List<Product>>((ref) async {
  final products = await ref.watch(allProductsProvider.future);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  if (searchQuery.isEmpty) {
    return products;
  }

  return products.where((product) {
    return product.name.toLowerCase().contains(searchQuery) ||
        product.description.toLowerCase().contains(searchQuery) ||
        (product.category?.toLowerCase().contains(searchQuery) ?? false);
  }).toList();
});

/// Get product by ID
final productDetailProvider =
    FutureProvider.family<Product, String>((ref, productId) async {
  // Using mock data for development
  final mockProduct = MockDataService.getMockProductDetail(productId);
  if (mockProduct == null) {
    throw Exception('Product not found');
  }
  return Product(
    id: mockProduct['id'] as String,
    clinicId: mockProduct['clinicId'] as String,
    name: mockProduct['name'] as String,
    description: mockProduct['description'] as String,
    price: mockProduct['price'] as double,
    stock: mockProduct['stock'] as int,
    lowStockThreshold: mockProduct['lowStockThreshold'] as int,
    photoUrl: mockProduct['photoUrl'] as String?,
    category: mockProduct['category'] as String,
    createdAt: DateTime.parse(mockProduct['createdAt'] as String),
    updatedAt: DateTime.parse(mockProduct['updatedAt'] as String),
  );
});

/// Get all product categories
final productCategoriesProvider = FutureProvider<List<String>>((ref) async {
  // Using mock data for development
  final mockProducts = MockDataService.getMockStoreProducts();
  final categories = <String>{};
  for (final product in mockProducts) {
    categories.add(product['category'] as String);
  }
  return categories.toList()..sort();
});

/// Get low stock products
final lowStockProductsProvider = FutureProvider<List<Product>>((ref) async {
  // Using mock data for development
  final mockProducts = MockDataService.getMockStoreProducts();
  final filtered = mockProducts
      .where((p) => (p['stock'] as int) <= (p['lowStockThreshold'] as int))
      .toList();
  return filtered
      .map((p) => Product(
            id: p['id'] as String,
            clinicId: p['clinicId'] as String,
            name: p['name'] as String,
            description: p['description'] as String,
            price: p['price'] as double,
            stock: p['stock'] as int,
            lowStockThreshold: p['lowStockThreshold'] as int,
            photoUrl: p['photoUrl'] as String?,
            category: p['category'] as String,
            createdAt: DateTime.parse(p['createdAt'] as String),
            updatedAt: DateTime.parse(p['updatedAt'] as String),
          ))
      .toList();
});
