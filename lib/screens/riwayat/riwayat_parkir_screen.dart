import 'package:flutter/material.dart';

class RiwayatParkirScreen extends StatelessWidget {
  const RiwayatParkirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B0000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B0000),
        elevation: 0,
        title: const Text('Riwayat Parkir'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _RiwayatCard('Senin, 20 Oktober 2025', '06:33', '09:55'),
          _RiwayatCard('Senin, 20 Oktober 2025', '13:56', '15:24'),
          _RiwayatCard('Kamis, 23 Oktober 2025', '06:33', '10:55'),
          _RiwayatCard('Jumat, 24 Oktober 2025', '08:11', '09:55'),
        ],
      ),
    );
  }
}

class _RiwayatCard extends StatelessWidget {
  final String date;
  final String masuk;
  final String keluar;

  const _RiwayatCard(this.date, this.masuk, this.keluar);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_parking, color: Color(0xFF8B0000)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Masuk : $masuk WIB'),
                Text('Keluar : $keluar WIB'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
