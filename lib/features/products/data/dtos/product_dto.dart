class ProductDto {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? category;
  final int stock;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductDto({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.category,
    required this.stock,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String?,
      stock: json['stock'] as int,
      imageUrl: json['photoUrl'] as String? ?? json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'stock': stock,
      'imageUrl': imageUrl,
    };
  }
}
