import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_speed/data/gps/dangerous_entity.dart';
import 'package:gps_speed/feature/dangerous_mark/listing_dangerous_mark_page.dart';
import 'package:gps_speed/feature/setting/help_and_feedback_page.dart';

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
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 40, left: 80, right: 80),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  ColumnStart(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Lat: ${dangerousLocation.latitude} - long: ${dangerousLocation.longitude}',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                              onPressed: () {
                                //copy lat long
                                Clipboard.setData(ClipboardData(
                                    text: '${dangerousLocation.latitude}, ${dangerousLocation.longitude}'));
                                //show toast
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Copied to clipboard: ${dangerousLocation.latitude}, ${dangerousLocation.longitude}'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Text(
                                'Copy',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                              )),
                        ],
                      ),
                      Text(
                        'Time: ${formatDate(dangerousLocation.time)}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Address: ${dangerousLocation.addressInfo}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
