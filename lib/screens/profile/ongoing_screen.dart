import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class OngoingScreen extends StatefulWidget {
  const OngoingScreen({super.key});

  @override
  State<OngoingScreen> createState() => _OngoingScreenState();
}

class _OngoingScreenState extends State<OngoingScreen> {
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("id");

    if (userId == null) {
      setState(() {
        _error = "User tidak ditemukan, silakan login kembali.";
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final all = await ApiService.getBookings(userId.toString());
      final proses = all
          .where((b) => b['status'] == 'pending' || b['status'] == 'proses')
          .toList();

      proses.sort(
        (a, b) => (b['created_at'] ?? '').toString().compareTo(
          (a['created_at'] ?? '').toString(),
        ),
      );

      setState(() {
        _bookings = proses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat pesanan: $e';
        _isLoading = false;
      });
    }
  }

  Widget _card(BuildContext context, Map<String, dynamic> data) {
    final tanggal = (data['tanggal'] ?? '-').toString();
    final lapangan = (data['nama_lapangan'] ?? '-').toString();
    final jam = (data['jam'] ?? '-').toString();
    final paket = (data['jenis_paket'] ?? '-').toString();
    final status = (data['status'] ?? '-').toString();
    final int bookingId = int.tryParse(data['id'].toString()) ?? 0;

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
              Expanded(
                child: Text(
                  '$jam • $paket',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                status,
                style: const TextStyle(fontSize: 13, color: Colors.amber),
              ),
              const Spacer(),
              
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
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Berjalan',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: _loadBookings,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _bookings.isEmpty
          ? const Center(
              child: Text(
                'Belum ada pesanan berjalan',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadBookings,
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _bookings.length,
                itemBuilder: (context, index) =>
                    _card(context, _bookings[index]),
              ),
            ),
    );
  }
}
