import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/service_model.dart';
import '../services/api_service.dart';

class ServiceProvider with ChangeNotifier {
  List<ServiceModel> _services = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ServiceModel> get services => _services;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchServices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Token tidak ditemukan');

      final result = await ApiService.getServices(token);
      _services = result.map((json) => ServiceModel.fromJson(json)).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> addService(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await ApiService.createService(token!, data);
      
      if (response['message'] == 'Layanan servis berhasil ditambahkan') {
        await fetchServices();
        return null;
      }
      return response['message'] ?? 'Gagal menambah layanan';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateService(int id, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await ApiService.updateService(token!, id, data);
      
      if (response['message'] == 'Layanan servis berhasil diubah') {
        await fetchServices();
        return null;
      }
      return response['message'] ?? 'Gagal mengubah layanan';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteService(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await ApiService.deleteService(token!, id);
      
      if (response['message'] == 'Layanan servis berhasil dihapus') {
        await fetchServices();
        return null;
      }
      return response['message'] ?? 'Gagal menghapus layanan';
    } catch (e) {
      return e.toString();
    }
  }
}