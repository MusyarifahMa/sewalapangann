import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LokasiScreen extends StatelessWidget {
  const LokasiScreen({super.key});

  Future<void> bukaMaps() async {
    final Uri url = Uri.parse(
      'https://maps.google.com/?q=Politeknik+Negeri+Cilacap',
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDCC2E8),

      appBar: AppBar(
        backgroundColor: const Color(0xffDCC2E8),
        title: const Text(
          "Lokasi Lapangan",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Container(
              height: 300,
              width: double.infinity,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: const Center(
                child: Icon(
                  Icons.map,
                  size: 120,
                  color: Colors.purple,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Politeknik Negeri Cilacap",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Jl. Dr. Soetomo No.1, Sidakaya, Cilacap",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),

                onPressed: bukaMaps,

                icon: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),

                label: const Text(
                  "Buka Google Maps",
                  style: TextStyle(
                    color: Colors.white,
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