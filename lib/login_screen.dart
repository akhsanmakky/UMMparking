import 'package:flutter/material.dart';
import 'register_screen.dart';
// PASTIKAN PATH INI SESUAI: lib/screens/forget_password_screen.dart
import 'screens/forget_password_screen.dart'; 

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ====================== HEADER MERAH ======================
            Container(
              height: 330,
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
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row top bar (Home icon + Logo UMMPark)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.home,
                                color: Colors.white, size: 28),
                          ),
                          Row(
                            children: [
                              // Ganti dengan placeholder jika asset tidak ada
                              Image.asset(
                                "assets/logo.png",
                                width: 30,
                                // Fallback: jika gambar tidak ada, gunakan ikon atau teks
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.park, color: Colors.white);
                                },
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "UMMPark",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      const Text(
                        "Selamat Datang",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),
                      const Text(
                        "Silakan masuk untuk melanjutkan",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),

            // ====================== EMAIL ======================
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.red),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ====================== PASSWORD ======================
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.red),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ====================== SIGN IN + FORGOT ======================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 14),
                    ),
                    onPressed: () {
                      // Logic SIGN IN Anda di sini
                      print('Tombol SIGN IN ditekan.');
                    },
                    child: const Text("SIGN IN"),
                  ),
                  
                  // ====================== FORGOT PASSWORD BUTTON (FIXED) ======================
                  TextButton(
                    onPressed: () {
                      // Navigasi ke ForgetPasswordScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "FORGOT PASSWORD",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  // ============================================================================
                ],
              ),
            ),

            const SizedBox(height: 35),

            // ====================== PANEL PUTIH BAWAH (REGISTER) ======================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Buatlah\nAkun Kamu",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Jika belum ada akun\nbuatlah akun terlebih dahulu",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Navigasi ke RegisterScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      "Buat Akun",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
