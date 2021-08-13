import 'dart:async';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
  String apiKey = 'AIzaSyAWR7JmiMchbbYFmLv4RHIKIV4wT6THask';
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCordinates = [];
  Set<Polyline> _polylines = {};

  bool createMarkers = false;
  late CameraPosition _start;
  late Stream<Position> positionStream;
  late Position post;
  late Future<Position> position;
  late double originlat;
  late double originlon;
  late Marker _origin;
  late Marker _detsi;
  Completer<GoogleMapController> _mapController = Completer();
  static final CameraPosition _center =
      CameraPosition(target: LatLng(0, 0), zoom: 11.5);

  Future<Stream> getpostionstream() async {
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
    positionStream = await Geolocator.getPositionStream();
    positionStream.forEach((position) {
      setState(() {
        originlat = position.latitude;
        originlon = position.longitude;
      });
    });
    return positionStream;
  }

  void createMarker() {
    setState(() {
      _detsi = Marker(
          markerId: MarkerId('Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: LatLng(
              widget.destination.latitude, widget.destination.longitude));
    });
  }

  setpolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,
        PointLatLng(originlat, originlon),
        PointLatLng(6.664220, -1.554187));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('!No possible route found')));
    }

    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId('poly'),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCordinates);
      _polylines.add(polyline);
    });
    print(polylineCordinates);
  }

  @override
  void initState() {
    super.initState();

    getpostionstream().then((position) {
      createMarker();
      setpolyline();
      setState(() {
        createMarkers = true;
      });
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
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          initialCameraPosition: _center,
          onMapCreated: (GoogleMapController controller) {
            _mapController.complete(controller);
            controller.moveCamera(
                CameraUpdate.newLatLng(LatLng(originlat, originlon)));
            controller.moveCamera(CameraUpdate.zoomTo(16));
            print('lat is ' + originlat.toString());
          },
          markers: createMarkers ? {_detsi} : {},
          polylines: createMarkers ? _polylines : {},
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
                    .moveCamera(
                        CameraUpdate.newLatLng(LatLng(originlat, originlon)))
                    .then((value) {
                  _googleMapController.animateCamera(CameraUpdate.zoomTo(16));
                });
              }),
        ),
      ),
    );
  }
}
