import 'package:flutter/material.dart';
import 'package:sewalapangann/screens/detail/detail_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String title;
  final List<String> images;

  const CategoryScreen({super.key, required this.title, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDCC2E8),

      appBar: AppBar(
        backgroundColor: const Color(0xffDCC2E8),
        elevation: 0,
        centerTitle: true,

        title: Text(title, style: const TextStyle(color: Colors.black)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),

        child: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 900
                ? 3
                : constraints.maxWidth > 600
                ? 3
                : 2;
            double aspectRatio = constraints.maxWidth > 900
                ? 1.5
                : constraints.maxWidth > 600
                ? 1.2
                : 0.8;

            return GridView.builder(
              itemCount: images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: aspectRatio,
              ),

              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),

                          child: Image.asset(
                            images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                        ),

                        onPressed: () {
                          String fileName = images[index]
                              .split('/')
                              .last
                              .split('.')
                              .first
                              .toUpperCase();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(
                                image: images[index],
                                namaLapangan: "Lapangan $fileName",
                              ),
                            ),
                          );
                        },

                        child: const Text(
                          "Detail",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
