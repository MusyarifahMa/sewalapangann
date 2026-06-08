import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_screen.dart';
import 'history_screen.dart';
import 'ongoing_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "Memuat...";
  String email = "Memuat...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Mengambil data dari SharedPreferences (data yang disimpan saat login)
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("nama") ?? "Pengguna";
      email = prefs.getString("email") ?? "-";
    });
  }

  Widget _profileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B3FA0), Color(0xFFB77FD8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B3FA0).withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 38),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                Text(email, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuCard({required IconData icon, required String title, required VoidCallback onTap, Color iconColor = const Color(0xFF7B3FA0)}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 14),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCC2E8),
      appBar: AppBar(backgroundColor: const Color(0xFFDCC2E8), title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _profileHeader(),
            const SizedBox(height: 24),
            _menuCard(icon: Icons.account_circle, title: 'Akun Saya', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen()))),
            _menuCard(icon: Icons.timelapse, title: 'Pesanan Berjalan', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OngoingScreen()))),
            _menuCard(icon: Icons.history, title: 'Riwayat Pesanan', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()))),
          ],
        ),
      ),
    );
  }
}