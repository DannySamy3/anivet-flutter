class LowStockProductDto {
  final String id;
  final String name;
  final int stock;
  final double stockPercentage;
  final String urgency; // CRITICAL, HIGH, MEDIUM

  LowStockProductDto({
    required this.id,
    required this.name,
    required this.stock,
    required this.stockPercentage,
    required this.urgency,
  });

  factory LowStockProductDto.fromJson(Map<String, dynamic> json) {
    return LowStockProductDto(
      id: json['id'] as String,
      name: json['name'] as String,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      stockPercentage: double.tryParse(json['stockPercentage']?.toString() ?? '0') ?? 0.0,
      urgency: json['urgency'] as String? ?? 'MEDIUM',
    );
  }
}
