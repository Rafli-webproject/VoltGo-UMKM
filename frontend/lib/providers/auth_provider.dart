import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners(); 

    final response = await ApiService.login(email, password);
    
    _isLoading = false;
    notifyListeners(); 

    if (response['token'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['token']);
      await prefs.setInt('role_id', response['user']['role_id']); 
      await prefs.setString('user_name', response['user']['name']);
      return null; 
    } else {
      return response['message'] ?? 'Login gagal'; 
    }
  }

  // TAMBAHAN BARU: Fungsi untuk mendaftar
  Future<String?> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final response = await ApiService.register(name, email, password);
    
    _isLoading = false;
    notifyListeners();

    if (response['message'] == 'Registrasi berhasil') {
      return null; // Sukses
    } else {
      return response['message'] ?? 'Registrasi gagal';
    }
  }
}