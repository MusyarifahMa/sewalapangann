import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../profile/ongoing_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  final pages = [
    const HomeScreen(),
    const OngoingScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,

        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/home.jpg",
              width: 28,
              height: 28,
            ),
            label: "Beranda",
          ),

          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/book.jpg",
              width: 28,
              height: 28,
            ),
            label: "Book",
          ),

          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/profile.jpg",
              width: 28,
              height: 28,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}