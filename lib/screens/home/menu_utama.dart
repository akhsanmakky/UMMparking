import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/logout_dialog.dart';

// IMPORT SCREEN TUJUAN
import '../zona/detail_zona_screen.dart';
import '../riwayat/riwayat_parkir_screen.dart';
import '../profile/profile_screen.dart';

class MenuUtama extends StatelessWidget {
  MenuUtama({super.key});

  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B0000),

      // ====================== APP BAR ======================
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B0000),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'UMM Parkir',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            Text(
              'Selamat Datang, Akhsan',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showLogoutDialog(context);
            },
          ),
        ],
      ),

      // ====================== BODY ======================
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ---------- OCCUPANCY CARD ----------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Occupancy : 34%',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.34,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF8B0000),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tempat Kosong : Parkir Belakang 1, Parkir Belakang 2, Parkir Depan 1',
                    style: TextStyle(fontSize: 12),
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
              text:
                  'Informasi Tambahan : Jam Buka 07.00 WIB, Jam Tutup 20.00 WIB',
            ),

            const SizedBox(height: 20),

            // ---------- PARKING GRID ----------
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _ParkirCard(
                    title: 'Parkir Belakang 1',
                    status: '60/100 Tempat Kosong',
                    level: '(cukup)',
                    onTap: () => _toDetailZona(context),
                  ),
                  _ParkirCard(
                    title: 'Parkir Belakang 2',
                    status: '12/100 Tempat Kosong',
                    level: '(banyak)',
                    onTap: () => _toDetailZona(context),
                  ),
                  _ParkirCard(
                    title: 'Parkir Depan 1',
                    status: '80/100 Tempat Kosong',
                    level: '(cukup)',
                    onTap: () => _toDetailZona(context),
                  ),
                  _ParkirCard(
                    title: 'Parkir Depan 2',
                    status: '100/100 Tempat Kosong',
                    level: '(penuh)',
                    onTap: () => _toDetailZona(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ====================== BOTTOM NAV ======================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
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
              onPressed: () => _toDetailZona(context),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _toRiwayat(context),
            ),
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => _toProfile(context),
            ),
          ],
        ),
      ),
    );
  }

  // ====================== NAVIGATION ======================
  void _toDetailZona(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DetailZonaScreen()),
    );
  }

  void _toRiwayat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RiwayatParkirScreen()),
    );
  }

  void _toProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  // ====================== INFO CARD ======================
  Widget _infoCard({required IconData icon, required String text}) {
    return Container(
      width: double.infinity,
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
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================== PARKIR CARD ======================
class _ParkirCard extends StatelessWidget {
  final String title;
  final String status;
  final String level;
  final VoidCallback onTap;

  const _ParkirCard({
    required this.title,
    required this.status,
    required this.level,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
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
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              status,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              level,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
