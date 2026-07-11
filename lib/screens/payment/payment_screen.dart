import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api_service.dart';
import 'struk_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String namaLapangan;
  final String tanggal;
  final String jam;
  final String paket;
  final int harga;

  const PaymentScreen({
    super.key,
    required this.namaLapangan,
    required this.tanggal,
    required this.jam,
    required this.paket,
    this.harga = 400000,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String metode = 'Transfer';
  String? bank;
  bool isSaving = false;

  final Map<String, List<Map<String, dynamic>>> bankOptions = {
    'Transfer': [
      {'name': 'BCA', 'color': const Color(0xFF0066AE)},
      {'name': 'Mandiri', 'color': const Color(0xFF003087)},
      {'name': 'BRI', 'color': const Color(0xFF00529B)},
      {'name': 'BNI', 'color': const Color(0xFF004B87)},
    ],
    'Ewallet': [
      {'name': 'OVO', 'color': const Color(0xFF4C3494)},
      {'name': 'GoPay', 'color': const Color(0xFF00AED6)},
      {'name': 'Dana', 'color': const Color(0xFF118EEA)},
      {'name': 'ShopeePay', 'color': const Color(0xFFEE4D2D)},
    ],
    'Qris': [
      {'name': 'QRIS', 'color': const Color(0xFFCC0001)},
    ],
  };

  String _formatRupiah(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }

    return 'Rp $buffer';
  }

  Future<void> _bayar() async {
    final prefs = await SharedPreferences.getInstance();

    final int? userId = prefs.getInt("id");
    final String? nama = prefs.getString("nama");

    if (userId == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan login terlebih dahulu")),
      );
      return;
    }

    if (bank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih metode pembayaran terlebih dahulu"),
        ),
      );
      return;
    }

    try {
      setState(() {
        isSaving = true;
      });

      final metodeBayar = "$metode - $bank";

      final booking = await ApiService.createBooking(
        userId: userId.toString(),
        pelanggan: nama ?? "Pelanggan",
        whatsapp: "-",
        namaLapangan: widget.namaLapangan,
        tanggal: widget.tanggal,
        jam: widget.jam,
        paket: widget.paket,
        harga: widget.harga,
        metodeBayar: metodeBayar,
      );

      if (!mounted) return;

      final bookingId = booking["data"]?["id"]?.toString() ?? "-";

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7B3FA0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Pembayaran Berhasil",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B3FA0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StrukScreen(
                            kode: bookingId,
                            pelanggan: nama ?? "Pelanggan",
                            whatsapp: "-",
                            namaLapangan: widget.namaLapangan,
                            tanggal: widget.tanggal,
                            jam: widget.jam,
                            paket: widget.paket,
                            harga: widget.harga,
                            metodeBayar: metodeBayar,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Lihat Struk",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan pesanan : $e")));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final banks = bankOptions[metode] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFDCC2E8),
      appBar: AppBar(backgroundColor: const Color(0xFFDCC2E8), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Metode Pembayaran",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Row(
              children: ["Transfer", "Ewallet", "Qris"].map((m) {
                final active = metode == m;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      metode = m;
                      bank = null;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: active ? const Color(0xFF7B3FA0) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      m,
                      style: TextStyle(
                        color: active ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: banks.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.8,
              ),
              itemBuilder: (_, i) {
                final b = banks[i];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      bank = b["name"];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: bank == b["name"]
                          ? Border.all(color: const Color(0xFF7B3FA0), width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        b["name"],
                        style: TextStyle(
                          color: b["color"] as Color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B3FA0),
                ),
                onPressed: isSaving ? null : _bayar,
                child: Text(
                  isSaving ? "MENYIMPAN..." : "BAYAR",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
