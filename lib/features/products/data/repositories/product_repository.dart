import '../../../../core/services/api_service.dart';
import '../dtos/product_dto.dart';
import '../../domain/entities/product.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository(this._apiService);

  // GET /api/products - Browse products (public)
  Future<List<Product>> getProducts() async {
    final response = await _apiService.get('/products');
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => Product.fromDto(ProductDto.fromJson(json)))
        .toList();
  }

  // GET /api/products/:id - Get product by ID (public)
  Future<Product> getProductById(String productId) async {
    final response = await _apiService.get('/products/$productId');
    return Product.fromDto(ProductDto.fromJson(response.data));
  }

  // POST /api/products - Create product (OWNER/STAFF only)
  Future<Product> createProduct(Map<String, dynamic> productData) async {
    final response = await _apiService.post('/products', data: productData);
    return Product.fromDto(ProductDto.fromJson(response.data));
  }

  // PUT /api/products/:id - Update product (OWNER/STAFF only)
  Future<Product> updateProduct(
    String productId,
    Map<String, dynamic> productData,
  ) async {
    final response = await _apiService.put(
      '/products/$productId',
      data: productData,
    );
    return Product.fromDto(ProductDto.fromJson(response.data));
  }

  // DELETE /api/products/:id - Delete product (OWNER/STAFF only)
  Future<void> deleteProduct(String productId) async {
    await _apiService.delete('/products/$productId');
  }
}
