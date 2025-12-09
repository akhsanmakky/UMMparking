import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  Widget infoTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.black),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 55, left: 20, right: 20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.logout, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Foto/Icon
            const Icon(Icons.account_circle,
                size: 140, color: Colors.white),

            const SizedBox(height: 15),

            // Nama & Status
            const Text(
              "Akhsan Makki",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              "202210370311241",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const Text(
              "Mahasiswa Aktif",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),

            const SizedBox(height: 30),

            // Data
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  infoTile(Icons.school, "Prodi", "Informatika"),
                  infoTile(Icons.apartment, "Fakultas", "Teknik"),
                  infoTile(Icons.email, "Email", "akhsanmakky@gmail.com"),
                ],
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
