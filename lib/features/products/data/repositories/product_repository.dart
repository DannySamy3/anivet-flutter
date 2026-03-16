import '../../../../core/services/api_service.dart';
import '../dtos/product_dto.dart';
import '../dtos/low_stock_product_dto.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/low_stock_product.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository(this._apiService);

  // GET /api/products - Browse products (public)
  Future<List<Product>> getProducts() async {
    final response = await _apiService.get('products');
    final dynamic data = response.data;
    final List<dynamic> productsJson =
        (data is Map && data.containsKey('data')) ? data['data'] : data;
    return productsJson
        .map((json) => Product.fromDto(ProductDto.fromJson(json)))
        .toList();
  }

  // GET /api/products/:id - Get product by ID (public)
  Future<Product> getProductById(String productId) async {
    final response = await _apiService.get('products/$productId');
    final dynamic data = response.data;
    final Map<String, dynamic> productJson =
        (data is Map && data.containsKey('data')) ? data['data'] : data;
    return Product.fromDto(ProductDto.fromJson(productJson));
  }

  // POST /api/products - Create product (OWNER/STAFF only)
  Future<Product> createProduct(Map<String, dynamic> productData) async {
    final response = await _apiService.post('products', data: productData);
    final dynamic data = response.data;
    final Map<String, dynamic> productJson =
        (data is Map && data.containsKey('data')) ? data['data'] : data;
    return Product.fromDto(ProductDto.fromJson(productJson));
  }

  // PUT /api/products/:id - Update product (OWNER/STAFF only)
  Future<Product> updateProduct(
    String productId,
    Map<String, dynamic> productData,
  ) async {
    final response = await _apiService.put(
      'products/$productId',
      data: productData,
    );
    final dynamic data = response.data;
    final Map<String, dynamic> productJson =
        (data is Map && data.containsKey('data')) ? data['data'] : data;
    return Product.fromDto(ProductDto.fromJson(productJson));
  }

  // DELETE /api/products/:id - Delete product (OWNER/STAFF only)
  Future<void> deleteProduct(String productId) async {
    await _apiService.delete('products/$productId');
  }

  // GET /api/products/inventory/low-stock - Low stock alerts (admin)
  Future<List<LowStockProduct>> getLowStockProducts() async {
    final response = await _apiService.get('products/inventory/low-stock');
    final dynamic data = response.data;
    final List<dynamic> productsJson =
        (data is Map && data.containsKey('data')) ? data['data'] : data;
    return productsJson
        .map((json) =>
            LowStockProduct.fromDto(LowStockProductDto.fromJson(json)))
        .toList();
  }
}
