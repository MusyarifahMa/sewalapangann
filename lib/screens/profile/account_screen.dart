import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../auth/login_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final birthDateController = TextEditingController();

  String gender = 'laki-laki';
  bool isLoading = true;
  bool isSaving = false;
  bool isEditing = false;

  String _oldUsername =
      ''; // buat manggil endpoint (username lama sebelum diedit)
  String? _avatarUrl;
  File? _pickedAvatar;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString("nama") ?? "";
    _oldUsername = username;

    final data = await ApiService.getProfileScraped(username);

    if (data != null) {
      setState(() {
        usernameController.text = data['username'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['no_tlp'] ?? '';
        birthDateController.text = data['tgl_lahir'] ?? '';
        gender = (data['gender'] != null && data['gender'].isNotEmpty)
            ? data['gender']
            : 'laki-laki';
        _avatarUrl = data['avatar_url'];
        isLoading = false;
      });
    } else {
      // gagal scraping -> tetap tampilkan dari cache biar gak kosong total
      setState(() {
        usernameController.text = prefs.getString("nama") ?? "";
        emailController.text = prefs.getString("email") ?? "";
        isLoading = false;
      });
    }
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedAvatar = File(picked.path));
    }
  }

  Future<void> _saveProfile() async {
    setState(() => isSaving = true);
    try {
      Uint8List? oldAvatarBytes;
      if (_pickedAvatar == null && _avatarUrl != null) {
        final resp = await http.get(Uri.parse(_avatarUrl!));
        if (resp.statusCode == 200) oldAvatarBytes = resp.bodyBytes;
      }

      final success = await ApiService.updateProfileMultipart(
        username: _oldUsername,
        newUsername: usernameController.text,
        email: emailController.text,
        noTlp: phoneController.text,
        tglLahir: birthDateController.text,
        gender: gender,
        newAvatarFile: _pickedAvatar,
        oldAvatarBytes: oldAvatarBytes,
      );

      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("nama", usernameController.text);
        _oldUsername =
            usernameController.text; // update biar load berikutnya benar
      }

      if (!mounted) return;
      setState(() => isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Profil berhasil diperbarui' : 'Gagal memperbarui profil',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal: $e')));
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF7B3FA0),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly || !isEditing,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: isEditing ? Colors.white : Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _genderOption(String value, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: isEditing ? () => setState(() => gender = value) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: gender == value
                ? const Color(0xFF7B3FA0)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: gender == value ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCC2E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDCC2E8),
        title: const Text('Akun Saya'),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: isEditing ? _pickAvatar : null,
                          child: CircleAvatar(
                            radius: 43,
                            backgroundColor: const Color(0xFF7B3FA0),
                            backgroundImage: _pickedAvatar != null
                                ? FileImage(_pickedAvatar!)
                                : (_avatarUrl != null
                                          ? NetworkImage(_avatarUrl!)
                                          : null)
                                      as ImageProvider?,
                            child: (_pickedAvatar == null && _avatarUrl == null)
                                ? const Icon(
                                    Icons.person,
                                    size: 48,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        if (isEditing)
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              'Ketuk foto untuk ganti',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        const SizedBox(height: 22),
                        _field(
                          label: 'Username',
                          controller: usernameController,
                          hint: 'Masukkan username',
                        ),
                        _field(
                          label: 'Email',
                          controller: emailController,
                          hint: 'Email',
                          readOnly: true,
                        ),
                        _field(
                          label: 'No. Telepon',
                          controller: phoneController,
                          hint: 'Masukkan no telepon',
                        ),
                        GestureDetector(
                          onTap: isEditing
                              ? () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      birthDateController.text =
                                          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                                    });
                                  }
                                }
                              : null,
                          child: AbsorbPointer(
                            child: _field(
                              label: 'Tanggal Lahir',
                              controller: birthDateController,
                              hint: 'Pilih tanggal',
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Gender',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF7B3FA0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _genderOption('laki-laki', 'Laki-laki'),
                            const SizedBox(width: 10),
                            _genderOption('perempuan', 'Perempuan'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7B3FA0),
                            ),
                            onPressed: isSaving
                                ? null
                                : (isEditing
                                      ? _saveProfile
                                      : () => setState(() => isEditing = true)),
                            child: isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    isEditing ? 'Simpan' : 'Ubah Profil',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
