import 'package:flutter/material.dart';

class StrukScreen extends StatelessWidget {
  final String kode;
  final String pelanggan;
  final String whatsapp;
  final String namaLapangan;
  final String tanggal;
  final String jam;
  final String paket;
  final int harga;
  final String metodeBayar;

  const StrukScreen({
    super.key,
    required this.kode,
    required this.pelanggan,
    required this.whatsapp,
    required this.namaLapangan,
    required this.tanggal,
    required this.jam,
    required this.paket,
    required this.harga,
    required this.metodeBayar,
  });

  String _formatRupiah(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }

    return 'Rp.${buffer.toString()}';
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
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
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B3FA0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'SF',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SPORT FIELD',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Jl. Contoh 112 no 14',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        'No. 08123456789',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Divider(height: 24),

              _row('Kode', kode),
              _row('Pelanggan', pelanggan),
              _row('Whatsapp', whatsapp),

              const SizedBox(height: 10),

              _row('Jenis Lapangan', namaLapangan),
              _row('Tanggal', tanggal),
              _row('Waktu', jam),
              _row('Paket', paket),

              const Divider(height: 20),

              const Text(
                'Ringkasan Pembayaran',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    _formatRupiah(harga),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _formatRupiah(harga),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const Divider(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B3FA0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Pembayaran: $metodeBayar',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Terima kasih telah berbelanja di Sewa Lapangan.\nSimpan struk ini untuk verifikasi pembayaran.',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black45,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B3FA0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text(
                    'BACK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}