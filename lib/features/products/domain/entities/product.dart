import 'package:annivet/features/products/data/dtos/product_dto.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final int stock;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stock,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromDto(ProductDto dto) {
    return Product(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      price: dto.price,
      category: dto.category,
      stock: dto.stock,
      imageUrl: dto.imageUrl,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  bool get isInStock => stock > 0;

  bool get isLowStock => stock > 0 && stock <= 5;
}
