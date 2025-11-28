import 'package:flutter/material.dart';

class MenuUtama extends StatelessWidget {
  const MenuUtama({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ======================= BOTTOM NAVIGATION =======================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
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
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ======================= HEADER MERAH =======================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 55, left: 20, right: 20, bottom: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 154, 12, 2),
                    Color.fromARGB(255, 241, 221, 214)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Scan Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "UMM Parkir",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.fullscreen, color: Colors.white),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),
                  const Text(
                    "Selamat Datang, Akhsan",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 20),

                  // =================== OCCUPANCY CARD ===================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Occupancy : 34%",
                            style:
                                TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 10),

                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: LinearProgressIndicator(
                            value: 0.34,
                            minHeight: 8,
                            color: Colors.red,
                            backgroundColor: Colors.grey[300],
                          ),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "Tempat Kosong : Parkir Belakang 1, Parkir Belakang 2, Parkir Depan 1",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // =================== SEARCH CARD ===================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.black45),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Cari Tempat Terdekat\nKampus III UMM",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =================== INFO CARD ===================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info, color: Colors.black45),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Informasi Tambahan : Jam Buka 07.00 WIB,\nJam Tutup 20.00 WIB",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // =================== GRID PARKIR ===================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  _parkingCard("Parkir Belakang 1", "60/100 Tempat Kosong", "(Cukup)"),
                  _parkingCard("Parkir Belakang 2", "12/100 Tempat Kosong", "(Banyak)"),
                  _parkingCard("Parkir Depan 1", "50/100 Tempat Kosong", "(Cukup)"),
                  _parkingCard("Parkir Depan 2", "100/100 Tempat Kosong", "(Penuh)"),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // =================== WIDGET KARTU PARKIR ===================
  Widget _parkingCard(String title, String value, String status) {
    return Container(
      width: 158,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(color: Colors.black54)),
          Text(status, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
