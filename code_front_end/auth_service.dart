import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://127.0.0.1:3000/api/auth';


// ============================================================
// LAYANAN API (AuthService)
// ============================================================
class AuthService {
  // -- Simpan token ke penyimpanan lokal --
  static Future<void> simpanToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  // -- Ambil token dari penyimpanan lokal --
  static Future<String?> ambilToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // -- Hapus token (logout) --
  static Future<void> hapusToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  // -- Register --
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    return jsonDecode(res.body);
  }

  // -- Login --
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(res.body);
  }

  // -- Ambil profil user (butuh token) --
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await ambilToken();
    final res = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(res.body);
  }
}
