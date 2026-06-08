import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      usernameController.text = prefs.getString("nama") ?? "";
      emailController.text = prefs.getString("email") ?? "";
      phoneController.text = prefs.getString("telepon") ?? "";
      birthDateController.text = prefs.getString("tanggal_lahir") ?? "";
      gender = prefs.getString("gender") ?? "laki-laki";
      isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    setState(() => isSaving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      // Mengambil ID dari prefs (dikonversi ke string untuk antisipasi)
      final userId = (prefs.getString("id") ?? prefs.getInt("id")?.toString()) ?? "0";

      await ApiService.updateProfile(
        userId: userId,
        username: usernameController.text,
        phone: phoneController.text,
        birthDate: birthDateController.text,
        gender: gender,
      );

      await prefs.setString("nama", usernameController.text);
      await prefs.setString("telepon", phoneController.text);
      await prefs.setString("tanggal_lahir", birthDateController.text);
      await prefs.setString("gender", gender);

      if (!mounted) return;
      setState(() => isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
  }

  Widget _field({required String label, required TextEditingController controller, required String hint, bool readOnly = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF7B3FA0), fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      TextField(controller: controller, readOnly: readOnly || !isEditing, decoration: InputDecoration(hintText: hint, filled: true, fillColor: isEditing ? Colors.white : Colors.grey.shade100, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
      const SizedBox(height: 14),
    ]);
  }

  Widget _genderOption(String value, String label) {
    return Expanded(child: GestureDetector(onTap: isEditing ? () => setState(() => gender = value) : null, child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: gender == value ? const Color(0xFF7B3FA0) : Colors.grey.shade100, borderRadius: BorderRadius.circular(12)), child: Center(child: Text(label, style: TextStyle(color: gender == value ? Colors.white : Colors.black87, fontWeight: FontWeight.w600))))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCC2E8),
      appBar: AppBar(backgroundColor: const Color(0xFFDCC2E8), title: const Text('Akun Saya'), elevation: 0),
      body: isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
            child: Column(children: [
              const CircleAvatar(radius: 43, backgroundColor: Color(0xFF7B3FA0), child: Icon(Icons.person, size: 48, color: Colors.white)),
              const SizedBox(height: 22),
              _field(label: 'Username', controller: usernameController, hint: 'Masukkan username'),
              _field(label: 'Email', controller: emailController, hint: 'Email', readOnly: true),
              _field(label: 'No. Telepon', controller: phoneController, hint: 'Masukkan no telepon'),
              _field(label: 'Tanggal Lahir', controller: birthDateController, hint: 'Pilih tanggal', readOnly: true),
              const Align(alignment: Alignment.centerLeft, child: Text('Gender', style: TextStyle(fontSize: 13, color: Color(0xFF7B3FA0), fontWeight: FontWeight.w600))),
              const SizedBox(height: 8),
              Row(children: [_genderOption('laki-laki', 'Laki-laki'), const SizedBox(width: 10), _genderOption('perempuan', 'Perempuan')]),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, height: 48, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7B3FA0)), onPressed: isEditing ? _saveProfile : () => setState(() => isEditing = true), child: Text(isEditing ? 'Simpan' : 'Ubah Profil', style: const TextStyle(color: Colors.white)))),
            ]),
          ),
          TextButton.icon(onPressed: _logout, icon: const Icon(Icons.logout, color: Colors.red), label: const Text('Logout', style: TextStyle(color: Colors.red))),
        ]),
      ),
    );
  }
}