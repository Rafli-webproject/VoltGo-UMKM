class ServiceModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int estimatedDays;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.estimatedDays,
  });

  // Fungsi untuk mengubah JSON dari API menjadi object Dart
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: double.parse(json['price'].toString()),
      estimatedDays: json['estimated_days'],
    );
  }
}