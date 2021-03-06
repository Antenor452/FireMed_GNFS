import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
  late double originlat;
  late double originlon;
  late Marker _detsi;
  late LocationData currentLocation;
  Location location = Location();
  Completer<GoogleMapController> _mapController = Completer();
  static final CameraPosition _center =
      CameraPosition(target: LatLng(0, 0), zoom: 11.5);

  Future<bool> getlocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationdata;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('__');
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    _locationdata = await location.getLocation();
    setState(() {
      currentLocation = _locationdata;
      originlat = double.parse(_locationdata.latitude.toString());
      originlon = double.parse(_locationdata.longitude.toString());
    });
    location.onLocationChanged.listen((currentlocation) {
      setState(() {
        currentLocation = _locationdata;
        originlat = double.parse(_locationdata.latitude.toString());
        originlon = double.parse(_locationdata.longitude.toString());

        setpolyline();

        print(_locationdata.latitude);
      });
    });
    print(_locationdata.latitude.toString());
    return true;
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
        PointLatLng(widget.destination.latitude, widget.destination.longitude));
    if (polylineCordinates.isEmpty) {
      if (result.points.isNotEmpty) {
        result.points.forEach((element) {
          polylineCordinates.add(LatLng(element.latitude, element.longitude));
        });
      } else {
        polylineCordinates.clear();
        result.points.forEach((element) {
          polylineCordinates.add(LatLng(element.latitude, element.longitude));
        });
      }

      setState(() {
        Polyline polyline = Polyline(
            polylineId: PolylineId('poly'),
            color: Colors.red,
            points: polylineCordinates);
        _polylines.add(polyline);
      });
    } else if (result.points.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No available route to destination')));
    }
  }

  @override
  void initState() {
    super.initState();
    getlocation().then((value) {
      setpolyline();
      createMarker();
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
            Future.delayed(Duration(seconds: 1), () {
              controller.animateCamera(
                  CameraUpdate.newLatLngZoom(LatLng(6.6699564, -1.56178), 16));
            });
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

                _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(
                    LatLng(originlat, originlon), 16));
              }),
        ),
      ),
    );
  }
}
