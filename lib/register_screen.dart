import 'package:flutter/material.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(229, 174, 12, 0),
        elevation: 0,
        title: const Text(
          "Buat Akun",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header teks
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Buatlah\nAkun Kamu",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Jika belum ada akun\nbuatlah akun terlebih dahulu",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // === FORM INPUT ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  // Nama lengkap
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Nama Lengkap",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Email
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Password
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // === TOMBOL BUAT AKUN ===
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(229, 174, 12, 0),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Setelah daftar kembali ke halaman login
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "BUAT AKUN",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // back to login
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sudah punya akun? Login",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
