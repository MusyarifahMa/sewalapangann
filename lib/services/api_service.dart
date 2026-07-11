import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/parser.dart' as html_parser;

class ApiService {
  static const String baseUrl = "http://localhost/projek_mobile/public";

  static Future<String> _getCookie() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_cookie') ?? '';
  }

  // Fungsi login/register (sudah ada) - sekarang nangkep cookie session
  static Future<Map<String, dynamic>> post(
    String url,
    Map<String, String> body,
  ) async {
    final response = await http.post(Uri.parse(url), body: body);

    final rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('session_cookie', rawCookie.split(';').first);
    }

    return jsonDecode(response.body);
  }

  // GET profil - scraping dari halaman /profile/{username}
  static Future<Map<String, dynamic>?> getProfileScraped(
    String username,
  ) async {
    final cookie = await _getCookie();
    final response = await http.get(
      Uri.parse("$baseUrl/profile/$username"),
      headers: {'Cookie': cookie},
    );

    if (response.statusCode != 200) return null;

    final document = html_parser.parse(response.body);
    final values = document.getElementsByClassName('profile-value');
    if (values.length < 5) return null;

    final idInput = document.querySelector('input[name="id"]');
    final avatarImg = document.querySelector('.avatar-wrapper img');

    return {
      'id': idInput?.attributes['value'] ?? '0',
      'username': values[0].text.trim(),
      'email': values[1].text.trim(),
      'no_tlp': values[2].text.trim(),
      'tgl_lahir': values[3].text.trim(),
      'gender': values[4].text.trim(),
      'avatar_url': avatarImg != null
          ? "$baseUrl/${avatarImg.attributes['src']}"
          : null,
    };
  }

  // UPDATE profil - kirim multipart ke /update/profile/{username}
  static Future<bool> updateProfileMultipart({
    required String username,
    required String newUsername,
    required String email,
    required String noTlp,
    required String tglLahir,
    required String gender,
    File? newAvatarFile,
    Uint8List? oldAvatarBytes,
  }) async {
    final cookie = await _getCookie();
    final uri = Uri.parse("$baseUrl/update/profile/$username");
    final request = http.MultipartRequest('POST', uri);
    request.headers['Cookie'] = cookie;

    request.fields['username'] = newUsername;
    request.fields['email'] = email;
    request.fields['no_tlp'] = noTlp;
    request.fields['tgl_lahir'] = tglLahir;
    request.fields['gender'] = gender;

    if (newAvatarFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('avatar', newAvatarFile.path),
      );
    } else if (oldAvatarBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'avatar',
          oldAvatarBytes,
          filename: 'avatar.jpg',
        ),
      );
    }

    final streamed = await request.send();
    return streamed.statusCode < 400;
  }

  // ============ Fungsi booking yang sudah ada, gak diubah ============

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

  static Future<List<Map<String, dynamic>>> getBookings(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final nama = prefs.getString("nama") ?? "";
    final response = await http.get(
      Uri.parse("$baseUrl/api/pemesanan/user/$nama"),
    );
    final result = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(result["data"] ?? []);
  }

  static Future<void> tandaiSelesai(int bookingId) async {
    await http.post(
      Uri.parse("$baseUrl/update_booking.php"),
      body: {"id": bookingId.toString(), "status": "selesai"},
    );
  }
}
