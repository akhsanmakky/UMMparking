import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailZonaScreen extends StatefulWidget {
  const DetailZonaScreen({super.key});

  @override
  State<DetailZonaScreen> createState() => _DetailZonaScreenState();
}

class _DetailZonaScreenState extends State<DetailZonaScreen> {
  final Location _location = Location();

  LatLng? _currentPosition;
  List<LatLng> _routePoints = [];

  // ====================== DATA ZONA PARKIR ======================
  final Map<String, LatLng> zonaParkir = {
    'Parkir Belakang 1': LatLng(-7.92185, 112.59725),
    'Parkir Belakang 2': LatLng(-7.92215, 112.59775),
    'Parkir Depan 1': LatLng(-7.92155, 112.59805),
    'Parkir Depan 2': LatLng(-7.92130, 112.59830),
  };

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  // ====================== INIT LOCATION ======================
  Future<void> _initLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final loc = await _location.getLocation();
    final userPos = LatLng(loc.latitude!, loc.longitude!);

    final nearest = _findNearestZone(userPos);
    await _fetchRoute(userPos, nearest);

    setState(() {
      _currentPosition = userPos;
    });
  }

  // ====================== FIND NEAREST ZONE ======================
  LatLng _findNearestZone(LatLng user) {
    double minDistance = double.infinity;
    LatLng nearest = zonaParkir.values.first;

    for (final zone in zonaParkir.values) {
      final d = const Distance().as(LengthUnit.Meter, user, zone);
      if (d < minDistance) {
        minDistance = d;
        nearest = zone;
      }
    }
    return nearest;
  }

  // ====================== FETCH ROUTE OSRM ======================
  Future<void> _fetchRoute(LatLng start, LatLng end) async {
    final url = 'https://router.project-osrm.org/route/v1/driving/'
        '${start.longitude},${start.latitude};'
        '${end.longitude},${end.latitude}'
        '?overview=full&geometries=geojson';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final coords = data['routes'][0]['geometry']['coordinates'];

      setState(() {
        _routePoints = coords.map<LatLng>((c) => LatLng(c[1], c[0])).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B0000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B0000),
        elevation: 0,
        title: const Text('Detail Zona'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ====================== MAP ======================
            Container(
              height: 190,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _currentPosition == null
                    ? const Center(child: CircularProgressIndicator())
                    : FlutterMap(
                        options: MapOptions(
                          initialCenter: _currentPosition!,
                          initialZoom: 17,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.ummparkir',
                          ),

                          // ===== ROUTE =====
                          if (_routePoints.isNotEmpty)
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: _routePoints,
                                  color: Colors.blue,
                                  strokeWidth: 4,
                                ),
                              ],
                            ),

                          // ===== MARKERS =====
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _currentPosition!,
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.person_pin_circle,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                              ),
                              ...zonaParkir.entries.map(
                                (e) => Marker(
                                  point: e.value,
                                  width: 40,
                                  height: 40,
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.local_parking,
                                        color: Colors.red,
                                        size: 28,
                                      ),
                                      Text(
                                        e.key,
                                        style: const TextStyle(
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // ====================== GRID REAL-TIME ======================
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('zone').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Tidak ada data zona parkir',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  final zones = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return {
                      'name': data['name'] ?? 'Zona',
                      'available': data['avaible'] ?? 0,
                      'capacity': data['capacity'] ?? 100,
                    };
                  }).toList();

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: zones.length,
                    itemBuilder: (context, index) {
                      final zone = zones[index];
                      final available = zone['available'] as int;
                      final capacity = zone['capacity'] as int;

                      String status;
                      if (available == 0) {
                        status = '(Penuh)';
                      } else if (available < 20) {
                        status = '(Sedikit)';
                      } else if (available < 50) {
                        status = '(Cukup)';
                      } else {
                        status = '(Banyak)';
                      }

                      return _ZonaCard(
                        zone['name'],
                        '$available/$capacity',
                        status,
                      );
                    },
                  );
                },
              ),
            ),

            // ====================== INFO ======================
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.navigation, color: Color(0xFF8B0000)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Rute mengikuti jalan menuju zona parkir terdekat',
                      style: TextStyle(fontSize: 12),
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

// ====================== ZONA CARD ======================
class _ZonaCard extends StatelessWidget {
  final String title;
  final String count;
  final String status;

  const _ZonaCard(this.title, this.count, this.status);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('$count Tempat Kosong', style: const TextStyle(fontSize: 12)),
          Text(status,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
