import 'package:flutter/material.dart';
import '../booking/booking_screen.dart';
import '../jadwal/jadwal_screen.dart';
import '../lokasi/lokasi_screen.dart';

class DetailScreen extends StatelessWidget {
  final String image;
  final String namaLapangan;

  const DetailScreen({
    super.key,
    required this.image,
    required this.namaLapangan,
  });

  Widget menuButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(title, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDCC2E8),
      appBar: AppBar(
        backgroundColor: const Color(0xffDCC2E8),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Detail Lapangan",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double aspectRatio = constraints.maxWidth > 600 ? 2.0 : 0.9;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      image,
                      height: 230,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    namaLapangan,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Menu Detail Jadwal
                  menuButton(
                    icon: Icons.calendar_month,
                    title: "Detail Jadwal",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const JadwalScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Menu Lokasi
                  menuButton(
                    icon: Icons.location_on,
                    title: "Lokasi Lapangan",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LokasiScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Menu Pesan Lapangan
                  menuButton(
                    icon: Icons.event_note,
                    title: "Pesan Lapangan",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingScreen(
                            image: image,
                            namaLapangan:
                                namaLapangan, 
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
