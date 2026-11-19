import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Token tidak ditemukan');

      final result = await ApiService.getOrders(token);
      _orders = result.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> addOrder(Map<String, String> fields, String? imagePath) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Token tidak ditemukan');

      final response = await ApiService.createOrder(token, fields, imagePath);
      if (response['message'] == 'Pesanan berhasil dibuat') {
        await fetchOrders(); 
        return null; 
      } else {
        return response['message'] ?? 'Gagal membuat pesanan';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // TAMBAHAN BARU: Fungsi Ubah Status
  Future<String?> updateStatus(int orderId, String newStatus) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Token tidak ditemukan');

      final response = await ApiService.updateOrderStatus(token, orderId, newStatus);
      
      if (response['message'] == 'Status pesanan berhasil diperbarui') {
        await fetchOrders(); // Refresh list jika sukses
        return null;
      } else {
        return response['message'] ?? 'Gagal update status';
      }
    } catch (e) {
      return e.toString();
    }
  }
}