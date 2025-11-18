import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              width: 130,
              errorBuilder: (context, error, stackTrace) {
                // jika asset gagal, tampilkan placeholder supaya tidak crash
                return const Icon(Icons.local_parking, size: 130, color: Colors.red);
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "UMMPark",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 40),

            // gunakan ElevatedButton.icon untuk feedback lebih jelas
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              ),
              onPressed: () {
                // debug print supaya kita tahu onPressed terpanggil
                debugPrint("HomeScreen: MASUK button pressed");

                try {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                } catch (e, st) {
                  // jika ada error saat navigasi, tampilkan snackbar agar kelihatan
                  debugPrint("Navigation error: $e\n$st");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Terjadi kesalahan: $e')),
                  );
                }
              },
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text("MASUK", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
