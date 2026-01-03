import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final name = TextEditingController();
  final nim = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  Future<void> _register() async {
    setState(() => loading = true);

    final error = await _authService.register(
      name: name.text.trim(),
      nim: nim.text.trim(),
      email: email.text.trim(),
      password: password.text.trim(),
    );

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
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Nama')),
            TextField(controller: nim, decoration: const InputDecoration(labelText: 'NIM')),
            TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: loading ? null : _register,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('DAFTAR'),
            ),
          ],
        ),
      ),
    );
  }
}

