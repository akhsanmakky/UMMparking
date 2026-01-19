import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/logout_dialog.dart';
import '../zona/detail_zona_screen.dart';
import '../riwayat/riwayat_parkir_screen.dart';
import '../profile/profile_screen.dart';
import '../qr/qr_scan_screen.dart';
import '../qr/qr_simulation_screen.dart';

class MenuUtama extends StatelessWidget {
  const MenuUtama({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF8B0000),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B0000),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: user == null
            ? const Text('UMM Parkir')
            : StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  String displayName = user.displayName ?? 'Pengguna';

                  // Ambil nama dari Firestore jika ada
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>?;
                    displayName = userData?['name'] ??
                        userData?['fullName'] ??
                        userData?['displayName'] ??
                        user.displayName ??
                        'Pengguna';
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'UMM Parkir',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Selamat Datang, $displayName',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  );
                },
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const QrScanScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.developer_mode),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const QrSimulationScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => showLogoutDialog(context),
          ),
        ],
      ),

      // ================= BODY (REAL-TIME DATA) =================
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('zone').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 60, color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // Debug: Print jumlah dokumen
          print('Total dokumen zona: ${snapshot.data?.docs.length ?? 0}');

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.local_parking,
                        size: 60, color: Colors.white),
                    const SizedBox(height: 16),
                    const Text(
                      'Tidak dapat memuat data zona parkir',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Docs: ${snapshot.data?.docs.length ?? 0}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MenuUtama()),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF8B0000),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Ambil data zona dari Firestore
          final zones = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            print(
                'Zona ${doc.id}: ${data['name']}, avaible: ${data['avaible']}, capacity: ${data['capacity']}');
            return {
              'id': doc.id,
              'name': data['name'] ?? 'Zona',
              'available': data['avaible'] ?? 0,
              'capacity': data['capacity'] ?? 100,
            };
          }).toList();

          print('Total zona yang dimuat: ${zones.length}');

          // Hitung total occupancy
          int totalAvailable = 0;
          int totalCapacity = 0;
          for (var zone in zones) {
            totalAvailable += zone['available'] as int;
            totalCapacity += zone['capacity'] as int;
          }

          final occupancyPercent =
              totalCapacity > 0 ? 1 - (totalAvailable / totalCapacity) : 0.0;

          // Cari zona yang masih tersedia
          final availableZones = zones
              .where((z) => (z['available'] as int) > 0)
              .map((z) => z['name'])
              .join(', ');

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ================= OCCUPANCY CARD =================
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Occupancy ${(occupancyPercent * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: occupancyPercent,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF8B0000),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        availableZones.isEmpty
                            ? 'Semua zona parkir penuh'
                            : 'Tempat Kosong: $availableZones',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                _infoCard(
                  icon: Icons.location_on,
                  text: 'Cari Tempat Terdekat\nKampus II UMM',
                ),
                const SizedBox(height: 12),
                _infoCard(
                  icon: Icons.info,
                  text: 'Jam Buka 07.00 WIB • Jam Tutup 20.00 WIB',
                ),

                const SizedBox(height: 16),

                // ================= GRID PARKIR =================
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: zones.length,
                    itemBuilder: (context, index) {
                      final zone = zones[index];
                      final available = zone['available'] as int;
                      final capacity = zone['capacity'] as int;

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DetailZonaScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                zone['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$available / $capacity Tempat Kosong',
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                available == 0
                                    ? '(Penuh)'
                                    : available < 20
                                        ? '(Sedikit)'
                                        : '(Tersedia)',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: _bottomNav(context),
    );
  }

  // ================= INFO CARD =================
  Widget _infoCard({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF8B0000)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  // ================= BOTTOM NAV =================
  Widget _bottomNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: Color(0xFF8B0000)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DetailZonaScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RiwayatParkirScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
