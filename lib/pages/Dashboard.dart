import 'package:final_year_project_gnfs/pages/Tracker.dart';
import 'package:final_year_project_gnfs/widgets/draweritems.dart';
import 'package:final_year_project_gnfs/widgets/fidasList.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Query _getDbList(String id) {
    return FirebaseDatabase.instance.reference().child('Fidas').child(id);
  }

  Query _get = FirebaseDatabase.instance.reference().child('Fidas');

  String? retrievalstatus = 'empty';
  String? Lat;
  String? Lng;
  late LatLng _destination;
  void initState() {
    super.initState();
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
      drawer: DrawerItems(),
      body: Container(
          height: double.infinity,
          decoration: BoxDecoration(color: Color(0xFFE5E5E5)),
          child: FirebaseAnimatedList(
              query: _get,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Map Fidas = snapshot.value;

                String idtxt = snapshot.key.toString();
                double lat = double.parse(Fidas['Latitude'].toString());
                double lon = double.parse(Fidas['Longitude'].toString());
                _destination = LatLng(lat, lon);

                if (Fidas.isNotEmpty) {
                  print(Fidas);
                  return Container(
                    child: Column(
                      children: [
                        FidasList(
                          id: idtxt,
                          destination: _destination,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Smoke Sensor Value :"),
                                  Text(Fidas['SmokeValue'])
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Flame Sensor Value :",
                                  ),
                                  Text(Fidas['FlameValue'])
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Status Value :"),
                                  Text(Fidas['Status'])
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return Container(
                    child: Text('No Users registered'),
                  );
                }
              })),
    );
  }
}
