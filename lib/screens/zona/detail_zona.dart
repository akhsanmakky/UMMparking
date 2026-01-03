import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class DetailZonaScreen extends StatefulWidget {
  const DetailZonaScreen({super.key});

  @override
  State<DetailZonaScreen> createState() => _DetailZonaScreenState();
}

class _DetailZonaScreenState extends State<DetailZonaScreen> {
  final Location _location = Location();
  LatLng? _currentPosition;
  LatLng? _nearestZone;

  final Distance _distance = const Distance();

  // ====================== DATA ZONA PARKIR ======================
  final Map<String, LatLng> zonaParkir = {
    'Parkir Belakang 1': LatLng(-7.921950, 112.597400),
    'Parkir Belakang 2': LatLng(-7.922300, 112.597800),
    'Parkir Depan 1': LatLng(-7.921600, 112.598100),
    'Parkir Depan 2': LatLng(-7.921300, 112.597900),
  };

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  // ====================== GET USER LOCATION ======================
  Future<void> _getLocation() async {
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

    final locationData = await _location.getLocation();
    final userPos = LatLng(locationData.latitude!, locationData.longitude!);

    setState(() {
      _currentPosition = userPos;
      _nearestZone = _findNearestZone(userPos);
    });
  }

  // ====================== FIND NEAREST ZONE ======================
  LatLng _findNearestZone(LatLng user) {
    double minDistance = double.infinity;
    LatLng nearest = zonaParkir.values.first;

    for (final zone in zonaParkir.values) {
      final d = _distance.as(LengthUnit.Meter, user, zone);
      if (d < minDistance) {
        minDistance = d;
        nearest = zone;
      }
    }
    return nearest;
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
              height: 180,
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
                          center: _currentPosition,
                          zoom: 17,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.ummparkir',
                          ),

                          // ===== ROUTING (GARIS ARAH) =====
                          if (_nearestZone != null)
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: [
                                    _currentPosition!,
                                    _nearestZone!,
                                  ],
                                  color: Colors.blue,
                                  strokeWidth: 4,
                                ),
                              ],
                            ),

                          // ===== MARKERS =====
                          MarkerLayer(
                            markers: [
                              // USER
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

                              // ZONA PARKIR
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
                                        size: 30,
                                      ),
                                      Text(
                                        e.key,
                                        style: const TextStyle(
                                          fontSize: 8,
                                          color: Colors.black,
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

            // ====================== GRID PARKIR ======================
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: const [
                  _ZonaCard('Parkir Belakang 1', '60/100', '(Cukup)'),
                  _ZonaCard('Parkir Belakang 2', '12/100', '(Banyak)'),
                  _ZonaCard('Parkir Depan 1', '50/100', '(Cukup)'),
                  _ZonaCard('Parkir Depan 2', '100/100', '(Penuh)'),
                ],
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
                  Icon(Icons.info, color: Color(0xFF8B0000)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Arah otomatis ke zona parkir terdekat dari lokasi Anda',
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
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '$count Tempat Kosong',
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            status,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
