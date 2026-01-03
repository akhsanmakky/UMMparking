import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final AuthService _authService = AuthService();
  final email = TextEditingController();
  bool loading = false;

  Future<void> _reset() async {
    setState(() => loading = true);

    final error = await _authService.resetPassword(email.text.trim());

    setState(() => loading = false);

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lupa Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Masukkan email terdaftar'),
            TextField(controller: email),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: loading ? null : _reset,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('KIRIM LINK'),
            ),
          ],
        ),
      ),
    );
  }
}
