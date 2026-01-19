import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RiwayatParkirScreen extends StatelessWidget {
  const RiwayatParkirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF8B0000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B0000),
        elevation: 0,
        title: const Text('Riwayat Parkir'),
      ),
      body: user == null
          ? const Center(
              child: Text(
                'User belum login',
                style: TextStyle(color: Colors.white),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('parkings')
                  .where('userId', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                // Debug print
                print('Connection state: ${snapshot.connectionState}');
                print('Has data: ${snapshot.hasData}');
                print('Docs count: ${snapshot.data?.docs.length ?? 0}');

                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.white, size: 60),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.history,
                            color: Colors.white, size: 60),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum ada riwayat parkir',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'User ID: ${user.uid}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Sort data by timeIn descending (terbaru di atas)
                final docs = snapshot.data!.docs.toList();
                docs.sort((a, b) {
                  final aTime = (a.data() as Map<String, dynamic>)['timeIn']
                      as Timestamp?;
                  final bTime = (b.data() as Map<String, dynamic>)['timeIn']
                      as Timestamp?;
                  if (aTime == null || bTime == null) return 0;
                  return bTime.compareTo(aTime); // Descending
                });

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    final Timestamp timeInTs = data['timeIn'];
                    final Timestamp? timeOutTs = data['timeOut'];
                    final String zoneId = data['zoneId'] ?? '';

                    final DateTime timeIn = timeInTs.toDate();
                    final DateTime? timeOut =
                        timeOutTs != null ? timeOutTs.toDate() : null;

                    // Format tanggal tanpa locale spesifik
                    final String tanggal =
                        DateFormat('dd/MM/yyyy').format(timeIn);
                    final String jamMasuk = DateFormat('HH:mm').format(timeIn);
                    final String jamKeluar = timeOut != null
                        ? DateFormat('HH:mm').format(timeOut)
                        : '-';

                    // Hitung durasi parkir
                    String durasi = '-';
                    if (timeOut != null) {
                      final duration = timeOut.difference(timeIn);
                      final hours = duration.inHours;
                      final minutes = duration.inMinutes.remainder(60);
                      if (hours > 0) {
                        durasi = '$hours jam $minutes menit';
                      } else {
                        durasi = '$minutes menit';
                      }
                    }

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('zone')
                          .doc(zoneId)
                          .get(),
                      builder: (context, zoneSnapshot) {
                        String zoneName = 'Zona';
                        if (zoneSnapshot.hasData && zoneSnapshot.data!.exists) {
                          zoneName = zoneSnapshot.data!.get('name') ?? 'Zona';
                        }

                        return _RiwayatCard(
                          zoneName: zoneName,
                          date: tanggal,
                          masuk: jamMasuk,
                          keluar: jamKeluar,
                          durasi: durasi,
                          status: data['status'],
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}

// ====================== CARD ======================
class _RiwayatCard extends StatelessWidget {
  final String zoneName;
  final String date;
  final String masuk;
  final String keluar;
  final String durasi;
  final String status;

  const _RiwayatCard({
    required this.zoneName,
    required this.date,
    required this.masuk,
    required this.keluar,
    required this.durasi,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool masihParkir = status == 'IN';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_parking,
            color: masihParkir ? Colors.orange : const Color(0xFF8B0000),
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zoneName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF8B0000),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Masuk  : $masuk WIB'),
                Text(
                  'Keluar : ${masihParkir ? "Masih Parkir" : "$keluar WIB"}',
                ),
                if (!masihParkir && durasi != '-')
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Durasi : $durasi',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (masihParkir)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Aktif',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
