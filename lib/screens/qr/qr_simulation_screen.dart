import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QrSimulationScreen extends StatefulWidget {
  const QrSimulationScreen({super.key});

  @override
  State<QrSimulationScreen> createState() => _QrSimulationScreenState();
}

class _QrSimulationScreenState extends State<QrSimulationScreen> {
  bool _processing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B0000),
        title: const Text('Simulasi QR Parkir'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('zone').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Data zona tidak tersedia'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final available = data['avaible'] ?? 0;

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.qr_code),
                  title: Text(data['name'] ?? 'Zona'),
                  subtitle: Text(
                    'ID: ${doc.id}\nSisa Slot: $available',
                  ),
                  trailing: ElevatedButton(
                    onPressed: _processing
                        ? null
                        : () => _simulateScan(context, doc.id),
                    child: const Text('SCAN'),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  // ===================== SIMULASI SCAN =====================
  Future<void> _simulateScan(BuildContext context, String zoneId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _processing = true);

    try {
      final zoneRef =
          FirebaseFirestore.instance.collection('zone').doc(zoneId);
      final parkingsRef =
          FirebaseFirestore.instance.collection('parkings');

      final zoneSnap = await zoneRef.get();
      if (!zoneSnap.exists) {
        _showDialog('Zona tidak ditemukan');
        return;
      }

      final zoneData = zoneSnap.data()!;
      final int available = zoneData['avaible'] ?? 0;
      final String zoneName = zoneData['name'] ?? 'Zona';

      // cek parkir aktif
      final activeParking = await parkingsRef
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'IN')
          .limit(1)
          .get();

      // ================= MASUK PARKIR =================
      if (activeParking.docs.isEmpty) {
        if (available <= 0) {
          _showDialog('$zoneName sudah penuh');
          return;
        }

        await parkingsRef.add({
          'userId': user.uid,
          'zoneId': zoneId,
          'zoneName': zoneName,
          'status': 'IN',
          'timeIn': Timestamp.now(),
          'timeOut': null,
        });

        await zoneRef.update({
          'avaible': FieldValue.increment(-1),
        });

        _showDialog('Masuk parkir berhasil\n$zoneName');
      }

      // ================= KELUAR PARKIR =================
      else {
        await parkingsRef.doc(activeParking.docs.first.id).update({
          'status': 'OUT',
          'timeOut': Timestamp.now(),
        });

        await zoneRef.update({
          'avaible': FieldValue.increment(1),
        });

        _showDialog('Keluar parkir berhasil\n$zoneName');
      }
    } catch (e) {
      _showDialog('Terjadi kesalahan sistem');
    }

    if (mounted) {
      setState(() => _processing = false);
    }
  }

  // ===================== DIALOG =====================
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
