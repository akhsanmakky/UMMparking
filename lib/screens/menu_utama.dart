import 'package:flutter/material.dart';
import 'detail_zona.dart';

class MenuUtama extends StatefulWidget {
  const MenuUtama({super.key});

  @override
  State<MenuUtama> createState() => _MenuUtamaState();
}

class _MenuUtamaState extends State<MenuUtama> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ======================= BOTTOM NAVIGATION =======================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // NAVIGASI (nanti bisa ganti ke halaman lain)
          if (index == 1) {
            // QR Scan
          } else if (index == 2) {
            // Riwayat
          } else if (index == 3) {
            // Profil
          }
        },
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.red.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ======================= HEADER =======================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 55,
                left: 20,
                right: 20,
                bottom: 30,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 154, 12, 2),
                    Color.fromARGB(255, 241, 221, 214),
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

                  // =================== OCCUPANCY ===================
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Occupancy : 34%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: 0.34,
                          color: Colors.red,
                          backgroundColor: Colors.grey[300],
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Tempat Kosong : Parkir Belakang 1, Parkir Belakang 2, Parkir Depan 1",
                        ),
                      ],
                    ),
                  ),
                ],
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
                  _parkingCard(context, "Parkir Belakang 1"),
                  _parkingCard(context, "Parkir Belakang 2"),
                  _parkingCard(context, "Parkir Depan 1"),
                  _parkingCard(context, "Parkir Depan 2"),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // =================== PARKING CARD ===================
  Widget _parkingCard(BuildContext context, String title) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DetailZona()),
        );
      },
      child: Container(
        width: 158,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text("50/100 Tempat Kosong"),
            const Text("(Cukup)"),
          ],
        ),
      ),
    );
  }
}
