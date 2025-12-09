// riwayat_parkir.dart
import 'package:flutter/material.dart';

class RiwayatParkir extends StatelessWidget {
  const RiwayatParkir({super.key});

  Widget _riwayatCard(String day, String date, String masuk, String keluar) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_parking, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                "$day, $date",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text("Masuk : $masuk"),
          Text("Keluar : $keluar"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.only(top: 55, left: 20, right: 20, bottom: 20),
            child: const Text(
              "Riwayat Parkir",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFD32F2F),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _riwayatCard("Senin", "20 Oktober 2025", "06:33 Wib", "09:55 Wib"),
                    _riwayatCard("Senin", "20 Oktober 2025", "13:56 Wib", "15:24 Wib"),
                    _riwayatCard("Kamis", "23 Oktober 2025", "06:33 Wib", "10:55 Wib"),
                    _riwayatCard("Jumat", "24 Oktober 2025", "08:11 Wib", "09:55 Wib"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // BOTTOM NAV
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -1)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Icon(Icons.home, size: 28, color: Colors.red),
            Icon(Icons.emoji_emotions, size: 28, color: Colors.red),
            Icon(Icons.call, size: 28, color: Colors.red),
            Icon(Icons.person, size: 28, color: Colors.red),
          ],
        ),
      ),
    );
  }
}


// PERBAIKAN BOTTOM NAV UNTUK detail_zona.dart
Widget fixedBottomNav() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: const BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -1)),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Icon(Icons.home, size: 28, color: Colors.red),
        Icon(Icons.qr_code_scanner, size: 28, color: Colors.red),
        Icon(Icons.access_time, size: 28, color: Colors.red),
        Icon(Icons.person, size: 28, color: Colors.red),
      ],
    ),
  );
}
