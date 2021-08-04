import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tracker extends StatefulWidget {
  Tracker({Key? key}) : super(key: key);

  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  //Location location = new Location();

  /*void _getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
  }
  */

  @override
  void initState() {
    super.initState();
  }

  Completer<GoogleMapController> _mapController = Completer();

  Marker? _origin;
  Marker? _destination;
  static final CameraPosition _source =
      CameraPosition(target: LatLng(37.773972, -122.431297), zoom: 11.5);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FIREMED GNFS',
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFF5C00),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GoogleMap(
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition: _source,
          onMapCreated: (GoogleMapController controller) {
            _mapController.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFFFF5C00),
        child: Icon(Icons.center_focus_strong),
        onPressed: () async {
          GoogleMapController _googleMapController =
              await _mapController.future;
          _googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(_source));
        },
      ),
    );
  }
}
