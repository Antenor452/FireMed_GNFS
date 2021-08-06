import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tracker extends StatefulWidget {
  final LatLng destination;
  Tracker({Key? key, required this.destination}) : super(key: key);

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

  Completer<GoogleMapController> _mapController = Completer();
  LatLng _livepos = LatLng(0, 0);
  Marker? _detsi;
  double lat = 0;

  void createMarker() {
    setState(() {
      _detsi = Marker(
          markerId: MarkerId('Destination'),
          infoWindow: InfoWindow(title: 'Building'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: widget.destination);
    });
  }

  @override
  void initState() {
    super.initState();
    createMarker();
  }

  Marker _origin = Marker(
      markerId: MarkerId('Location'),
      infoWindow: InfoWindow(title: 'You'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: LatLng(37.773972, -122.431297));

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
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          initialCameraPosition: _source,
          onMapCreated: (GoogleMapController controller) {
            _mapController.complete(controller);
          },
          markers: {_origin, _detsi!.clone()},
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: FloatingActionButton(
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
        ),
      ),
    );
  }
}
