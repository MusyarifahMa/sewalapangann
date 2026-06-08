import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("id");

    if (userId == null) return;

    try {
      final all = await ApiService.getBookings(userId.toString());
      // Filter hanya yang statusnya 'selesai'
      final selesai = all.where((b) => b['status'] == 'selesai').toList();
      
      setState(() {
        _history = selesai;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _formatRupiah(int amount) {
    return 'Rp.${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  Widget _card(Map<String, dynamic> data) {
    final harga = int.tryParse(data['harga'].toString()) ?? 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data['tanggal'] ?? '-', style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 8),
          Text(data['nama_lapangan'] ?? '-', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Text('${data['jam']} • ${data['paket']}', style: const TextStyle(fontSize: 14)),
          Text('${data['metode_bayar']} • ${_formatRupiah(harga)}', style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 10),
          const Row(children: [Icon(Icons.check_circle, size: 16, color: Colors.green), SizedBox(width: 6), Text('selesai', style: TextStyle(color: Colors.green))]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCC2E8),
      appBar: AppBar(backgroundColor: const Color(0xFFDCC2E8), title: const Text('History')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _history.length,
            itemBuilder: (_, i) => _card(_history[i]),
          ),
    );
  }
}