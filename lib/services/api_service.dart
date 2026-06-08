import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2/sewalapangann_api";

  // Fungsi baru untuk Update Profil
  static Future<Map<String, dynamic>> updateProfile({
    required String userId,
    required String username,
    required String phone,
    required String birthDate,
    required String gender,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/user/update_profile.php"),
      body: {
        "id": userId,
        "username": username,
        "telepon": phone,
        "tanggal_lahir": birthDate,
        "gender": gender,
      },
    );
    return jsonDecode(response.body);
  }

  // Fungsi lainnya
  static Future<Map<String, dynamic>> post(String url, Map<String, String> body) async {
    final response = await http.post(Uri.parse(url), body: body);
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>?> getUser(String userId) async {
    final response = await http.post(Uri.parse("$baseUrl/user/get_user.php"), body: {"id": userId});
    return jsonDecode(response.body);
  }

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
    final response = await http.post(Uri.parse("$baseUrl/create_booking.php"), body: {
      "user_id": userId,
      "pelanggan": pelanggan,
      "whatsapp": whatsapp,
      "nama_lapangan": namaLapangan,
      "tanggal": tanggal,
      "jam": jam,
      "paket": paket,
      "harga": harga.toString(),
      "metode_bayar": metodeBayar,
    });
    return jsonDecode(response.body);
  }

  static Future<List<Map<String, dynamic>>> getBookings(String userId) async {
    final response = await http.post(Uri.parse("$baseUrl/booking/get_bookings.php"), body: {"user_id": userId});
    final result = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(result);
  }

  static Future<void> tandaiSelesai(int bookingId) async {
    await http.post(Uri.parse("$baseUrl/update_booking.php"), body: {
      "id": bookingId.toString(),
      "status": "selesai",
    });
  }
}