import 'package:flutter/material.dart';
import '../models/reset_data.dart'; 
import 'otp_input_screen.dart'; 

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  // MOCK: Ganti dengan fungsi API/Firebase yang sebenarnya
  Future<bool> _sendOTP(String email) async {
    // Simulasikan API Call
    await Future.delayed(const Duration(seconds: 2)); 
    print('Simulasi: OTP terkirim ke $email');
    // Di sini Anda memanggil Firebase Authentication:
    // await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    return true; 
  }

  void _onContinue() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan email yang valid.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mengirim kode OTP...')));

    final success = await _sendOTP(email);

    if (success) {
      final resetData = ResetData(email: email);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpInputScreen(resetData: resetData),
        ),
      );
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim OTP. Cek kembali email.')),
      );
    }
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LUPA PASSWORD', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 154, 12, 2),
      ),
      backgroundColor: const Color.fromARGB(255, 154, 12, 2), 
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        // Bagian atas (teks)
        const Padding(
          padding: EdgeInsets.all(30.0),
          child: Text(
            'Masukkan Email Kamu untuk memverifikasi code yang akan dikirim',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        
        // Bagian form (Kontainer Putih)
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(25.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Email'),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'akhsankmalky@gmail.com'),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), 
                      child: const Text('Kembali', style: TextStyle(color: Colors.red)),
                    ),
                    ElevatedButton(
                      onPressed: _onContinue,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Lanjut'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
