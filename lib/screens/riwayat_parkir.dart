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
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
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

      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Riwayat Parkir"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _riwayatCard("Senin", "20 Oktober 2025", "06:33 WIB", "09:55 WIB"),
              _riwayatCard("Senin", "20 Oktober 2025", "13:56 WIB", "15:24 WIB"),
              _riwayatCard("Kamis", "23 Oktober 2025", "06:33 WIB", "10:55 WIB"),
              _riwayatCard("Jumat", "24 Oktober 2025", "08:11 WIB", "09:55 WIB"),
            ],
          ),
        ),
      ),
    );
  }
}
