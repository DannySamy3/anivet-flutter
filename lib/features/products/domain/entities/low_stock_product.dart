import '../../data/dtos/low_stock_product_dto.dart';

class LowStockProduct {
  final String id;
  final String name;
  final int stock;
  final double stockPercentage;
  final String urgency;

  LowStockProduct({
    required this.id,
    required this.name,
    required this.stock,
    required this.stockPercentage,
    required this.urgency,
  });

  factory LowStockProduct.fromDto(LowStockProductDto dto) {
    return LowStockProduct(
      id: dto.id,
      name: dto.name,
      stock: dto.stock,
      stockPercentage: dto.stockPercentage,
      urgency: dto.urgency,
    );
  }
}
