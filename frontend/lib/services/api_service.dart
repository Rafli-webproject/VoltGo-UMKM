import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api'; 

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Tidak dapat terhubung ke server'};
    }
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password, 'role_id': 3}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Tidak dapat terhubung ke server'};
    }
  }

  static Future<List<dynamic>> getOrders(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data']; 
      } else {
        throw Exception('Gagal memuat pesanan');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Map<String, dynamic>> createOrder(String token, Map<String, String> fields, String? imagePath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/orders'));
      request.headers['Authorization'] = 'Bearer $token';
      request.fields.addAll(fields);
      if (imagePath != null) {
        request.files.add(await http.MultipartFile.fromPath('photo', imagePath));
      }
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Gagal membuat pesanan: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> updateOrderStatus(String token, int orderId, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/orders/$orderId/status'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({'status': status}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Gagal update status: ${e.toString()}'};
    }
  }

  // ==================== CRUD LAYANAN SERVIS ====================

  // 1. Ambil Semua Layanan
  static Future<List<dynamic>> getServices(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/services'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception('Gagal memuat layanan');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // 2. Tambah Layanan
  static Future<Map<String, dynamic>> createService(String token, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/services'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(data),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Gagal menambah layanan: ${e.toString()}'};
    }
  }

  // 3. Edit Layanan
  static Future<Map<String, dynamic>> updateService(String token, int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/services/$id'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(data),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Gagal mengubah layanan: ${e.toString()}'};
    }
  }

  // 4. Hapus Layanan
  static Future<Map<String, dynamic>> deleteService(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/services/$id'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Gagal menghapus layanan: ${e.toString()}'};
    }
  }
}