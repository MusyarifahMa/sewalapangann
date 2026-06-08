import 'package:flutter/material.dart';
import '../category/category_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _sportCard({
    required BuildContext context,
    required String image,
    required String title,
    required List<String> lapanganImages,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryScreen(title: title, images: lapanganImages),
          ),
        );
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Gradient label bawah
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFDCC2E8),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFDCC2E8),
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'SPORT FIELD',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _sportCard(
                context: context,
                image: 'assets/images/badminton.jpeg',
                title: 'Lapangan Badminton',
                lapanganImages: ['assets/images/bd1.jpeg','assets/images/bd2.jpg','assets/images/bd3.jpg','assets/images/bd4.jpg','assets/images/bd5.jpg','assets/images/bd6.jpg'],
              ),
              _sportCard(
                context: context,
                image: 'assets/images/basket.jpeg',
                title: 'Lapangan Basket',
                lapanganImages: ['assets/images/b1.jpeg','assets/images/b2.jpg','assets/images/b3.jpg','assets/images/b4.jpg','assets/images/b5.jpg','assets/images/b6.jpg'],
              ),
              _sportCard(
                context: context,
                image: 'assets/images/futsal.jpeg',
                title: 'Lapangan Futsal',
                lapanganImages: ['assets/images/f1.jpeg','assets/images/f2.jpg','assets/images/f3.jpeg','assets/images/f4.jpg','assets/images/f5.jpg','assets/images/f6.jpg'],
              ),
              _sportCard(
                context: context,
                image: 'assets/images/volly.jpeg',
                title: 'Lapangan Volly',
                lapanganImages: ['assets/images/v1.jpeg','assets/images/v2.jpg','assets/images/v3.jpg','assets/images/v4.jpg','assets/images/v5.jpg','assets/images/v6.jpg'],
              ),
            ],
          ),
        ),
      ),
    );
  }
}