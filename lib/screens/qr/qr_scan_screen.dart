import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B0000),
        title: const Text('Scan QR Parkir'),
      ),
      body: MobileScanner(
        onDetect: (capture) async {
          if (processing || capture.barcodes.isEmpty) return;

          final zoneId = capture.barcodes.first.rawValue;
          if (zoneId == null || user == null) return;

          setState(() => processing = true);

          try {
            await _processQr(zoneId);
          } catch (e) {
            _showDialog('Error', 'Terjadi kesalahan sistem');
          }

          if (mounted) setState(() => processing = false);
        },
      ),
    );
  }

  Future<void> _processQr(String zoneId) async {
    final zoneRef = FirebaseFirestore.instance.collection('zone').doc(zoneId);
    final zoneSnap = await zoneRef.get();

    if (!zoneSnap.exists) {
      if (mounted) {
        _showDialog('QR Tidak Valid', 'Zona tidak ditemukan');
      }
      return;
    }

    final zoneData = zoneSnap.data()!;
    final available = zoneData['avaible'] ?? 0;
    final zoneName = zoneData['name'] ?? 'Zona';

    final parkings = FirebaseFirestore.instance.collection('parkings');

    final active = await parkings
        .where('userId', isEqualTo: user!.uid)
        .where('status', isEqualTo: 'IN')
        .limit(1)
        .get();

    // ================= MASUK =================
    if (active.docs.isEmpty) {
      if (available <= 0) {
        if (mounted) {
          _showDialog('Zona Penuh', '$zoneName sudah penuh');
        }
        return;
      }

      await parkings.add({
        'userId': user!.uid,
        'zoneId': zoneId,
        'status': 'IN',
        'timeIn': Timestamp.now(),
        'timeOut': null,
      });

      await zoneRef.update({
        'avaible': FieldValue.increment(-1),
      });

      if (mounted) {
        _showDialog(
            'Berhasil Masuk', 'Anda berhasil masuk parkir di\n$zoneName');
      }
    }

    // ================= KELUAR =================
    else {
      final activeDoc = active.docs.first;
      final activeZoneId = activeDoc.data()['zoneId'];

      // Cek apakah scan di zona yang sama
      if (activeZoneId != zoneId) {
        if (mounted) {
          _showDialog('Zona Salah',
              'Anda harus keluar dari zona yang sama dengan saat masuk');
        }
        return;
      }

      await parkings.doc(activeDoc.id).update({
        'status': 'OUT',
        'timeOut': Timestamp.now(),
      });

      await zoneRef.update({
        'avaible': FieldValue.increment(1),
      });

      if (mounted) {
        _showDialog(
            'Berhasil Keluar', 'Anda berhasil keluar parkir dari\n$zoneName');
      }
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
