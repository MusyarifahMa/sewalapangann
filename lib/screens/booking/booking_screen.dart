import 'package:flutter/material.dart';
import '../payment/payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final String image;
  final String namaLapangan; // Data yang diterima dari CategoryScreen

  const BookingScreen({
    super.key, 
    required this.image, 
    required this.namaLapangan
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final tanggalController = TextEditingController();
  final namaPemesanController = TextEditingController();
  
  String jam = '10.00'; 
  String paket = '2 Jam';

  final List<String> daftarJam = ['10.00', '13.00', '16.00', '19.00'];

  final Map<String, int> hargaPaket = {
    '2 Jam': 400000,
    '4 Jam': 700000,
  };

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF7B3FA0)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF7B3FA0), width: 1.5)),
      );

  String _bulan(int m) => ['','Januari','Februari','Maret','April','Mei','Juni',
      'Juli','Agustus','September','Oktober','November','Desember'][m];

  @override
  void dispose() {
    tanggalController.dispose();
    namaPemesanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCC2E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDCC2E8),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)),
        title: const Text('Booking Lapangan', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(widget.image, height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),

            // Nama Lapangan Otomatis
            TextFormField(
              initialValue: widget.namaLapangan,
              readOnly: true,
              decoration: _dec('Lapangan', Icons.sports),
            ),
            const SizedBox(height: 14),

            // Tanggal
            TextField(
              controller: tanggalController,
              readOnly: true,
              decoration: _dec('Tanggal Booking', Icons.calendar_today_outlined),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );
                if (picked != null) {
                  setState(() {
                    tanggalController.text = '${picked.day} ${_bulan(picked.month)} ${picked.year}';
                  });
                }
              },
            ),
            const SizedBox(height: 14),

            // Dropdown Jam Terbatas
            DropdownButtonFormField<String>(
              value: jam,
              decoration: _dec('Pilih Jam', Icons.access_time_outlined),
              items: daftarJam.map((j) => DropdownMenuItem(value: j, child: Text(j))).toList(),
              onChanged: (v) => setState(() => jam = v!),
            ),
            const SizedBox(height: 14),

            // Paket
            DropdownButtonFormField<String>(
              value: paket,
              decoration: _dec('Paket Durasi', Icons.timer_outlined),
              items: const [
                DropdownMenuItem(value: '2 Jam', child: Text('Paket 1 (2 Jam)')),
                DropdownMenuItem(value: '4 Jam', child: Text('Paket 2 (4 Jam)')),
              ],
              onChanged: (v) => setState(() => paket = v!),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7B3FA0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                onPressed: () {
                  if (tanggalController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih tanggal dulu!')));
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(
                        namaLapangan: widget.namaLapangan,
                        tanggal: tanggalController.text,
                        jam: jam,
                        paket: paket == '2 Jam' ? 'Paket 1' : 'Paket 2',
                        harga: hargaPaket[paket]!,
                      ),
                    ),
                  );
                },
                child: const Text('PESAN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}