import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_speed/data/gps/dangerous_entity.dart';

class DangerousMapPage extends StatefulWidget {
  const DangerousMapPage({super.key, required this.entity});
  final DangerousEntity entity;

  @override
  State<DangerousMapPage> createState() => DangerousMapPageState();
}

class DangerousMapPageState extends State<DangerousMapPage> {
  GoogleMapController? _controller;

  LatLng get initialPosition => LatLng(widget.entity.latitude, widget.entity.longitude);

  DangerousEntity get dangerousLocation => widget.entity;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: initialPosition,
              zoom: 14.4746,
            ),
            markers: {
              Marker(
                markerId: MarkerId(dangerousLocation.hashCode.toString()),
                infoWindow: InfoWindow(
                  title: dangerousLocation.addressInfo,
                ),
                position: initialPosition,
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CircleAvatar(
                backgroundColor: Colors.black38.withOpacity(0.5),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
