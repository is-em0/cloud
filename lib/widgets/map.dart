import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.513716319136815, 34.440583817776904),
    zoom: 14.4746,
  );

  Set<Marker> _createMarker() {
    return {
      const Marker(
          markerId: MarkerId("iuh"),
          position: LatLng(31.513716319136815, 34.440583817776904),
          infoWindow: InfoWindow(title: 'الجامعة الإسلامية ')),
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: GoogleMap(
        buildingsEnabled: true,
        myLocationButtonEnabled: true,
        indoorViewEnabled: true,
        zoomControlsEnabled: true,
        markers: _createMarker(),
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
