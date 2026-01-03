import 'package:flutter/material.dart';
import '../services/auth_service.dart';

void showLogoutDialog(BuildContext context) {
  final AuthService auth = AuthService();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.logout,
              size: 48,
              color: Color(0xFF8B0000),
            ),
            const SizedBox(height: 12),
            const Text(
              'Apakah kamu yakin ingin logout?',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ===== LOGOUT BUTTON =====
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                  ),
                  onPressed: () async {
                    await auth.logout();

                    // Tutup dialog dulu
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Logout'),
                ),

                // ===== CANCEL BUTTON =====
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Batal'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
