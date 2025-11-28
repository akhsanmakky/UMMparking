import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'screens/forget_password_screen.dart';
import 'screens/menu_utama.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // ====== ANIMASI CUSTOM ======
  Route _createRouteToMenu() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (context, animation, secondaryAnimation) => const MenuUtama(),
      transitionsBuilder: (context, animation, secondary, child) {
        final offsetAnimation = Tween(
          begin: const Offset(0.0, 0.2),
          end: Offset.zero,
        ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutQuad));

        final fadeAnimation =
            Tween(begin: 0.0, end: 1.0).animate(animation);

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ====================== HEADER MERAH ======================
            Container(
              height: 320,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF9A0C02), Color(0xFFD2A49A)],
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
                              Image.asset(
                                "assets/logo.png",
                                width: 30,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.park, color: Colors.white),
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

                      const SizedBox(height: 25),

                      const Text(
                        "Selamat Datang",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ====================== EMAIL FIELD ======================
                      const TextField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 15),

                      // ====================== PASSWORD FIELD ======================
                      const TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 20),

                      // SIGN IN + FORGOT
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 14),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                _createRouteToMenu(),
                              );
                            },
                            child: const Text("SIGN IN"),
                          ),

                          // Forgot password
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgetPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "FORGET PASSWORD",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ====================== LINGKARAN PUTIH + PANAH ======================
            Transform.translate(
              offset: const Offset(0, -18),
              child: const CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Icon(Icons.keyboard_arrow_up, size: 28),
              ),
            ),

            const SizedBox(height: 10),

            // ====================== PANEL PUTIH BAWAH ======================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
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

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9A0C02),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Buat Akun"),
                        SizedBox(width: 5),
                        Icon(Icons.keyboard_arrow_up, size: 22),
                      ],
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
