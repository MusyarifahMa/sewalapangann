import 'package:flutter/material.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking"),
      ),

      body: const Center(
        child: Text(
          "BOOKING HISTORY",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}