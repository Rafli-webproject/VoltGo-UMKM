class OrderModel {
  final int id;
  final String customerName;
  final String phone;
  final String deviceType;
  final String problemDescription;
  final String status;
  final String? photoPath;
  final String? serviceName;
  final String? technicianName;
  final String createdAt;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.deviceType,
    required this.problemDescription,
    required this.status,
    this.photoPath,
    this.serviceName,
    this.technicianName,
    required this.createdAt,
  });

  // Fungsi untuk mengubah JSON dari API menjadi object Dart
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      customerName: json['customer_name'],
      phone: json['phone'],
      deviceType: json['device_type'],
      problemDescription: json['problem_description'],
      status: json['status'],
      photoPath: json['photo_path'],
      serviceName: json['service_name'],
      technicianName: json['technician_name'],
      createdAt: json['created_at'],
    );
  }
}