import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tracker extends StatefulWidget {
  final LatLng destination;
  Tracker({Key? key, required this.destination}) : super(key: key);

  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  bool createMarkers = false;
  late Position post;
  late Future<Position> position;
  Marker? _origin;
  Completer<GoogleMapController> _mapController = Completer();
  Marker? _detsi;
  static final CameraPosition _source =
      CameraPosition(target: LatLng(37.773972, -122.431297), zoom: 11.5);
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('cant get permission');
      }
    }
    post = await Geolocator.getCurrentPosition();
    print(post);
    return await Geolocator.getCurrentPosition();
  }

  void createMarker() {
    setState(() {
      _detsi = Marker(
          markerId: MarkerId('Destination'),
          infoWindow: InfoWindow(title: 'Building'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: widget.destination);

      _origin = Marker(
          markerId: MarkerId('Location'),
          infoWindow: InfoWindow(title: 'You'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: LatLng(post.latitude, post.longitude));
    });
  }

  @override
  void initState() {
    super.initState();
    _determinePosition().then((value) {
      setState(() {
        createMarkers = true;
      });
      createMarker();
    });
  }

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
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          initialCameraPosition: _source,
          onMapCreated: (GoogleMapController controller) {
            _mapController.complete(controller);
          },
          markers: createMarkers ? {_origin!.clone(), _detsi!.clone()} : {},
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
              print(position.toString());
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
