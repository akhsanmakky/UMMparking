import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class DetailZona extends StatefulWidget {
  const DetailZona({super.key});

  @override
  State<DetailZona> createState() => _DetailZonaState();
}

class _DetailZonaState extends State<DetailZona> {
  GoogleMapController? mapController;

  Set<Marker> markers = {};
  BitmapDescriptor? parkingIcon;
  BitmapDescriptor? userIcon;

  Location location = Location();
  LatLng? userLatLng;

  @override
  void initState() {
    super.initState();
    _loadMarkerIcons();
    _initLocation();
    _loadParkingMarkers();
  }

  // =========================
  // LOAD CUSTOM ICONS
  // =========================
  Future<void> _loadMarkerIcons() async {
    parkingIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        "assets/icons/parking.png");

    userIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        "assets/icons/user_location.png");

    setState(() {});
  }

  // =========================
  // LIVE USER LOCATION
  // =========================
  Future<void> _initLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Service ON?
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    // Permission
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Listen real-time
    location.onLocationChanged.listen((loc) {
      userLatLng = LatLng(loc.latitude!, loc.longitude!);

      markers.removeWhere((m) => m.markerId.value == "user");

      markers.add(
        Marker(
          markerId: const MarkerId("user"),
          icon: userIcon ?? BitmapDescriptor.defaultMarkerWithHue(210),
          position: userLatLng!,
          infoWindow: const InfoWindow(title: "Lokasi Kamu Sekarang"),
        ),
      );

      setState(() {});

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLng(userLatLng!),
        );
      }
    });
  }

  // =========================
  // STATIC PARKING MARKERS
  // =========================
  void _loadParkingMarkers() {
    markers.addAll({
      Marker(
        markerId: const MarkerId("belakang1"),
        position: const LatLng(-7.981500, 112.630900),
        icon: parkingIcon ?? BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: "Parkir Belakang 1"),
      ),
      Marker(
        markerId: const MarkerId("belakang2"),
        position: const LatLng(-7.981800, 112.630600),
        icon: parkingIcon ?? BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: "Parkir Belakang 2"),
      ),
    });
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),

      bottomNavigationBar: _bottomNav(),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            _mapSection(),
            const SizedBox(height: 20),
            _gridPark(),
            const SizedBox(height: 20),
            _infoTambahan(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // =====================================================
  //  WIDGETS
  // =====================================================

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 55, left: 20, right: 20, bottom: 20),
      child: Row(
        children: [
          // BUTTON BACK
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 15),
          const Text(
            "Detail Zona",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: GoogleMap(
          onMapCreated: (c) => mapController = c,
          initialCameraPosition: const CameraPosition(
            target: LatLng(-7.981298, 112.63044),
            zoom: 16,
          ),
          mapType: MapType.normal,
          markers: markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),
      ),
    );
  }

  Widget _gridPark() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 15,
        runSpacing: 15,
        children: [
          _parkCard("Parkir Belakang 1", "60/100 Tempat Kosong", "(Cukup)"),
          _parkCard("Parkir Belakang 2", "12/100 Tempat Kosong", "(Banyak)"),
          _parkCard("Parkir Depan 1", "50/100 Tempat Kosong", "(Cukup)"),
          _parkCard("Parkir Depan 2", "100/100 Tempat Kosong", "(Penuh)"),
        ],
      ),
    );
  }

  Widget _parkCard(String title, String value, String status) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(color: Colors.black54)),
          Text(status, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _infoTambahan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: const [
            Icon(Icons.info, color: Colors.grey),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Informasi Tambahan : Jam Buka 07.00 WIB,\nJam Tutup 20.00 WIB",
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -1)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(Icons.home, size: 30, color: Colors.red),
          Icon(Icons.emoji_emotions, size: 30, color: Colors.red),
          Icon(Icons.call, size: 30, color: Colors.red),
          Icon(Icons.person, size: 30, color: Colors.red),
        ],
      ),
    );
  }
}
