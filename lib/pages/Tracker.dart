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
  late Position post;
  late Future<Position> position;
  late double originlat;
  late double originlon;
  Marker? _origin;
  Completer<GoogleMapController> _mapController = Completer();
  Marker? _detsi;
  static final CameraPosition _source =
      CameraPosition(target: LatLng(37.773972, -122.431297), zoom: 11.5);
  late CameraPosition _start;

  late Stream<Position> positionStream;

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
        print(originlat.toString() + originlon.toString());
      });
    });
    return positionStream;
  }

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
    originlat = post.latitude;
    originlon = post.longitude;

    setState(() {
      _start = CameraPosition(target: LatLng(originlat, originlon), zoom: 13.5);
    });
    GoogleMapController _googleMapController = await _mapController.future;
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(_start));
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

  setpolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,
        PointLatLng(originlat, originlon),
        PointLatLng(6.664220, -1.554187));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCordinates.add(LatLng(point.latitude, point.longitude));
      });
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

    getpostionstream().then((value) {
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
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          initialCameraPosition: _source,
          onMapCreated: (GoogleMapController controller) {
            _mapController.complete(controller);
          },
          markers: createMarkers ? {_detsi!.clone()} : {},
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
