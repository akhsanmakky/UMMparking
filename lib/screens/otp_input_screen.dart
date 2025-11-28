import 'package:flutter/material.dart';
import '../models/reset_data.dart';
import 'reset_password_screen.dart'; 

class OtpInputScreen extends StatefulWidget {
  final ResetData resetData;
  const OtpInputScreen({super.key, required this.resetData});

  @override
  State<OtpInputScreen> createState() => _OtpInputScreenState();
}

class _OtpInputScreenState extends State<OtpInputScreen> {
  String _otpCode = ''; 

  // MOCK: Ganti dengan fungsi API/Firebase yang sebenarnya
  Future<bool> _verifyOTP(String email, String otp) async {
    await Future.delayed(const Duration(seconds: 2));
    // Asumsi kode benar adalah '1234'
    return otp == '1234'; 
  }

  void _onContinue() async {
    if (_otpCode.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode OTP harus 4 digit.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Memverifikasi kode...')));

    final isVerified = await _verifyOTP(widget.resetData.email, _otpCode);

    if (isVerified) {
      // Simpan OTP yang terverifikasi ke model data
      widget.resetData.otp = _otpCode;
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(resetData: widget.resetData),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode OTP salah atau kedaluwarsa.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MASUKKAN OTP', style: TextStyle(color: Colors.white)),
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
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            'Cek email ${widget.resetData.email} dan masukkan code OTP',
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        
        // Bagian form OTP
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
                const Text('Masukkan Code OTP'),
                TextField(
                  onChanged: (value) {
                    _otpCode = value;
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 4, // Misalnya 4 digit
                  style: const TextStyle(fontSize: 24, letterSpacing: 20),
                  decoration: const InputDecoration(
                    hintText: '****',
                    counterText: '', 
                  ),
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
