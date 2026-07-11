import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://localhost/projek_mobile/public";

  // Update Profil (simpan lokal)
  static Future<Map<String, dynamic>> updateProfile({
    required String userId,
    required String username,
    required String phone,
    required String birthDate,
    required String gender,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("nama", username);
    await prefs.setString("telepon", phone);
    await prefs.setString("tanggal_lahir", birthDate);
    await prefs.setString("gender", gender);
    return {"status": 200, "message": "Profil berhasil diperbarui"};
  }

  // Post umum
  static Future<Map<String, dynamic>> post(
    String url,
    Map<String, String> body,
  ) async {
    final response = await http.post(Uri.parse(url), body: body);
    return jsonDecode(response.body);
  }

  // Get user
  static Future<Map<String, dynamic>?> getUser(String userId) async {
    final response = await http.get(Uri.parse("$baseUrl/api/user/$userId"));
    return jsonDecode(response.body);
  }

  // Create booking
  static Future<Map<String, dynamic>> createBooking({
    required String userId,
    required String pelanggan,
    required String whatsapp,
    required String namaLapangan,
    required String tanggal,
    required String jam,
    required String paket,
    required int harga,
    required String metodeBayar,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/pemesanan"),
      body: {
        "nama": pelanggan,
        "nama_lapangan": namaLapangan,
        "jenis_paket": paket,
        "jam": jam,
        "tanggal": tanggal,
      },
    );
    return jsonDecode(response.body);
  }

  // Get bookings pakai nama
  static Future<List<Map<String, dynamic>>> getBookings(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final nama = prefs.getString("nama") ?? "";
    final response = await http.get(
      Uri.parse("$baseUrl/api/pemesanan/user/$nama"),
    );
    final result = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(result["data"] ?? []);
  }

  // Tandai selesai
  static Future<void> tandaiSelesai(int bookingId) async {
    await http.post(
      Uri.parse("$baseUrl/api/pemesanan/selesai/$bookingId"),
      body: {"status": "selesai"},
    );
  }
}
