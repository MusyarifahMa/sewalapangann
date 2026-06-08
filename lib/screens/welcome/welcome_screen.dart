import 'package:flutter/material.dart';
import '../auth/login_screen.dart'; 

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCC2E8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Gambar
            Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Image.asset('assets/images/logo.png', width: 120, height: 120),
                ),
                const SizedBox(height: 30),

            const Text(
                  "SPORT FIELD",
                  style: TextStyle(
                    color: Color(0xFF7B3FA0),
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 15),

            const Text(
              'SELAMAT DATANG', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 1)
            ),
            const SizedBox(height: 6),
            const Text(
              'DI SEWA LAPANGAN OLAHRAGA', 
              style: TextStyle(fontSize: 16, color: Colors.black54)
            ),
            
            const SizedBox(height: 32),
            
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
              child: const Text(
                'Masuk', 
                style: TextStyle(
                  fontSize: 15, 
                  color: Color(0xFF7B3FA0), 
                  fontWeight: FontWeight.w600, 
                  decoration: TextDecoration.underline
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}