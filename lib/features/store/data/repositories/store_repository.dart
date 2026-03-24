import 'package:annivet/core/services/api_service.dart';
import 'package:annivet/features/store/data/models/product_dto.dart';
import 'package:annivet/features/store/domain/entities/product.dart';

class StoreRepository {
  final ApiService _apiService;

  const StoreRepository(this._apiService);

  /// Get all products in store
  Future<List<Product>> getProducts() async {
    try {
      final response = await _apiService.get('/products');
      final products = (response.data as List)
          .map((p) => ProductDto.fromJson(p as Map<String, dynamic>))
          .toList();
      return products.map((dto) => _dtoToEntity(dto)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await _apiService.get('/products', queryParameters: {
        'category': category,
      });
      final products = (response.data as List)
          .map((p) => ProductDto.fromJson(p as Map<String, dynamic>))
          .toList();
      return products.map((dto) => _dtoToEntity(dto)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get product by ID
  Future<Product> getProductById(String productId) async {
    try {
      final response = await _apiService.get('/products/$productId');
      final dto = ProductDto.fromJson(response.data as Map<String, dynamic>);
      return _dtoToEntity(dto);
    } catch (e) {
      rethrow;
    }
  }

  /// Get product inventory
  Future<int> getProductStock(String productId) async {
    try {
      final response = await _apiService.get('/products/$productId/stock');
      return response.data['stock'] as int;
    } catch (e) {
      rethrow;
    }
  }

  /// Get low stock products
  Future<List<Product>> getLowStockProducts() async {
    try {
      final response = await _apiService.get('/products/stock/low');
      final products = (response.data as List)
          .map((p) => ProductDto.fromJson(p as Map<String, dynamic>))
          .toList();
      return products.map((dto) => _dtoToEntity(dto)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get product categories
  Future<List<String>> getCategories() async {
    try {
      final response = await _apiService.get('/products/categories');
      return List<String>.from(response.data as List);
    } catch (e) {
      rethrow;
    }
  }

  /// Helper method to convert DTO to Entity
  Product _dtoToEntity(ProductDto dto) {
    return Product(
      id: dto.id,
      clinicId: dto.clinicId,
      name: dto.name,
      description: dto.description,
      price: dto.price,
      stock: dto.stock,
      lowStockThreshold: dto.lowStockThreshold,
      photoUrl: dto.photoUrl,
      category: dto.category,
      createdAt: DateTime.parse(dto.createdAt),
      updatedAt: DateTime.parse(dto.updatedAt),
    );
  }
}
