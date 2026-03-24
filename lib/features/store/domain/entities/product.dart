class Product {
  final String id;
  final String clinicId;
  final String name;
  final String description;
  final double price;
  final int stock;
  final int lowStockThreshold;
  final String? photoUrl;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.clinicId,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.lowStockThreshold,
    this.photoUrl,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  Product copyWith({
    String? id,
    String? clinicId,
    String? name,
    String? description,
    double? price,
    int? stock,
    int? lowStockThreshold,
    String? photoUrl,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      clinicId: clinicId ?? this.clinicId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      photoUrl: photoUrl ?? this.photoUrl,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Product.fromDto(dynamic dto) {
    return Product(
      id: dto.id,
      clinicId: dto.clinic?.id ?? '',
      name: dto.name,
      description: dto.description,
      price: dto.price,
      stock: dto.stock,
      lowStockThreshold: dto.lowStockThreshold ?? 5,
      photoUrl: dto.imageUrl,
      category: dto.category ?? 'Uncategorized',
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  bool isLowStock() => stock <= lowStockThreshold;

  bool isOutOfStock() => stock == 0;
}
