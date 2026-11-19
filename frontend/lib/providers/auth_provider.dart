import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

// Class AuthProvider menggunakan ChangeNotifier agar UI bisa mendengarkan perubahan state
class AuthProvider with ChangeNotifier {
  
  // Variabel state untuk menandakan proses loading (misal: saat tombol ditekan)
  bool _isLoading = false;
  
  // Getter untuk mengakses _isLoading dari UI
  bool get isLoading => _isLoading;

  // ================== FUNGSI LOGIN ==================
  Future<String?> login(String email, String password) async {
    // 1. Set loading menjadi true dan beritahu UI
    _isLoading = true;
    notifyListeners(); 

    // 2. Panggil API login
    final response = await ApiService.login(email, password);
    
    // 3. Selesai loading, beritahu UI
    _isLoading = false;
    notifyListeners(); 

    // 4. Cek apakah response memiliki token (tanda login sukses)
    if (response['token'] != null) {
      final prefs = await SharedPreferences.getInstance();
      
      // Simpan data user ke memori lokal HP
      await prefs.setString('token', response['token']);
      await prefs.setInt('role_id', response['user']['role_id']); 
      await prefs.setString('user_name', response['user']['name']);
      
      return null; // Return null berarti sukses (tidak ada error)
    } else {
      // Jika gagal, kembalikan pesan error dari API
      return response['message'] ?? 'Login gagal'; 
    }
  }

  // ================== FUNGSI REGISTER ==================
  Future<String?> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Panggil API register (otomatis role_id = 3 / Pelanggan)
    final response = await ApiService.register(name, email, password);
    
    _isLoading = false;
    notifyListeners();

    if (response['message'] == 'Registrasi berhasil') {
      return null; // Return null berarti sukses
    } else {
      return response['message'] ?? 'Registrasi gagal';
    }
  }

  // ================== FUNGSI LOGOUT (BARU) ==================
  Future<void> logout() async {
    // 1. Ambil instance SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    
    // 2. Hapus semua data (token, role_id, user_name)
    // Ini akan membuat sistem "lupa" siapa yang sedang login
    await prefs.clear(); 
    
    // 3. Beritahu UI bahwa state telah berubah
    notifyListeners();
  }
}