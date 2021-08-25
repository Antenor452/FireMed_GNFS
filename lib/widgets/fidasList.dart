import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project_gnfs/pages/Tracker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FidasList extends StatefulWidget {
  final LatLng destination;
  final String id;
  FidasList({Key? key, required this.id, required this.destination})
      : super(key: key);

  @override
  _FidasListState createState() => _FidasListState();
}

class _FidasListState extends State<FidasList> {
  @override
  void initState() {
    super.initState();
    setState(() {
      id = widget.id;
    });
    _getdetails(id);
  }

  String? username;
  String? phone;
  String? id;
  bool status = false;

  void _getdetails(id) async {
    var res = await FirebaseFirestore.instance
        .collection('Users')
        .where('Fidas ID', isEqualTo: widget.id)
        .get();
    var data = res.docs.first.data();
    setState(() {
      username = data['Username'];
      print(username);
      phone = data['Phone'];
      status = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return status
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: InkWell(
              child: Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('FIDAS ID : ' + widget.id.toString()),
                        SizedBox(
                          height: 18,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: Column(
                                children: [
                                  Text(username.toString()),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(phone.toString())
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Tracker(
                                            destination: widget.destination,
                                          )));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFF5C00),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Track',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}
