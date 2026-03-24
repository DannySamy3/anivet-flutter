class ProductDto {
  final String id;
  final String clinicId;
  final String name;
  final String description;
  final double price;
  final int stock;
  final int lowStockThreshold;
  final String? photoUrl;
  final String category;
  final String createdAt;
  final String updatedAt;

  const ProductDto({
    required this.id,
    required this.clinicId,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.lowStockThreshold,
    this.photoUrl,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] as String,
      clinicId: json['clinicId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      lowStockThreshold: json['lowStockThreshold'] as int,
      photoUrl: json['photoUrl'] as String?,
      category: json['category'] as String,
      createdAt:
          json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt:
          json['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clinicId': clinicId,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'lowStockThreshold': lowStockThreshold,
      'photoUrl': photoUrl,
      'category': category,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
