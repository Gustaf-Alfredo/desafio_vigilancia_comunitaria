import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(-7.145252, -34.841863),
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          const MarkerLayer(
            markers: [
              Marker(
                point: LatLng(-7.145252, -34.841863),
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 50,
                ),
              ),
              Marker(
                point: LatLng(-7.091604, -34.835672),
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            ],
          ),
          const RichAttributionWidget(attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
            )
          ])
        ]);
  }
}
