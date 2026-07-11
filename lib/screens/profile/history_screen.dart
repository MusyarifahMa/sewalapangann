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
      final selesai = all
          .where(
            (b) => b['status'] == 'confirmed' || b['status'] == 'cancelled',
          )
          .toList();

      setState(() {
        _history = selesai;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Widget _card(Map<String, dynamic> data) {
    final tanggal = (data['tanggal'] ?? '-').toString();
    final lapangan = (data['nama_lapangan'] ?? '-').toString();
    final jam = (data['jam'] ?? '-').toString();
    final status = (data['status'] ?? '-').toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Colors.black54,
              ),
              const SizedBox(width: 8),
              Text(
                tanggal,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.sports_soccer_outlined,
                size: 16,
                color: Colors.black54,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  lapangan,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.access_time_outlined,
                size: 16,
                color: Colors.black54,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(jam, style: const TextStyle(fontSize: 14))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                status == 'cancelled' ? Icons.cancel : Icons.check_circle,
                size: 16,
                color: status == 'cancelled' ? Colors.red : Colors.green,
              ),
              const SizedBox(width: 6),
              Text(
                status == 'cancelled' ? 'Dibatalkan' : 'Selesai',
                style: TextStyle(
                  fontSize: 13,
                  color: status == 'cancelled' ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCC2E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDCC2E8),
        title: const Text('History'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
          ? const Center(
              child: Text(
                'Belum ada riwayat pesanan',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _history.length,
              itemBuilder: (_, i) => _card(_history[i]),
            ),
    );
  }
}
