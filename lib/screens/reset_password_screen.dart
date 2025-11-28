import 'package:flutter/material.dart';
import '../models/reset_data.dart';

class ResetPasswordScreen extends StatefulWidget {
  final ResetData resetData;
  const ResetPasswordScreen({super.key, required this.resetData});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // MOCK: Ganti dengan fungsi API/Firebase yang sebenarnya
  Future<bool> _updatePassword(String email, String otp, String newPassword) async {
    await Future.delayed(const Duration(seconds: 2));
    print('Simulasi: Update password untuk ${email}');
    // Di sini Anda memanggil API reset password dengan membawa OTP dan New Password
    return true; 
  }

  void _onContinue() async {
    final newPassword = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi minimal 6 karakter.')),
      );
      return;
    }
    
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi kata sandi tidak cocok.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Memperbarui kata sandi...')));

    // Cek apakah data reset sudah siap (Email dan OTP ada)
    if (!widget.resetData.isReadyForReset) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kesalahan alur: Data verifikasi tidak lengkap.')),
      );
      return;
    }

    final success = await _updatePassword(
      widget.resetData.email,
      widget.resetData.otp!,
      newPassword,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata Sandi berhasil diubah! Silakan login kembali.')),
      );
      
      // Navigasi kembali ke halaman Login (rute paling awal)
      Navigator.popUntil(context, (route) => route.isFirst); 

    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui kata sandi. Coba lagi.')),
      );
    }
  }
  
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RESET PASSWORD', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 154, 12, 2),
      ),
      backgroundColor: const Color.fromARGB(255, 154, 12, 2),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        // Bagian atas
        const Padding(
          padding: EdgeInsets.all(30.0),
          child: Text(
            'Masukkan password baru',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        
        // Bagian form Reset Password
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
                const Text('Password baru'),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'password baru'),
                ),
                const SizedBox(height: 20),
                const Text('Konfirmasi Password'),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'ulangi password baru'),
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
