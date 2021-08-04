import 'package:final_year_project_gnfs/pages/Tracker.dart';
import 'package:final_year_project_gnfs/widgets/draweritems.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Query _getDbList = FirebaseDatabase.instance.reference().child('Fidas');
  String? Fidasusername;
  String? Fidasphone;
  String? retrievalstatus = 'empty';

  void initState() {
    super.initState();
  }

  void getdetails(String? id) async {
    var res = await firestore.FirebaseFirestore.instance
        .collection('Users')
        .where('Fidas ID', isEqualTo: id)
        .get();
    var data = res.docs.first.data();

    setState(() {
      Fidasusername = data['Username'];
      Fidasphone = data['Phone'];
      retrievalstatus = 'done';
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
      drawer: DrawerItems(),
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFE5E5E5)),
        child: FirebaseAnimatedList(
            query: _getDbList,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              Map Fidasmap = snapshot.value;
              String? Fidasid = Fidasmap['ID'];

              String? FidasStatus = Fidasmap['Status'].toString();
              getdetails(Fidasid);

              if (Fidasmap.isEmpty) {
                return Container(
                  child: Center(
                    child: Text('No registered user'),
                  ),
                );
              } else {
                return retrievalstatus == 'empty'
                    ? Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : _FidasList(Fidasmap['ID'], Fidasusername, Fidasphone);
              }
            }),
      ),
    );
  }

  Widget _FidasList(String? id, String? username, String? phone) {
    return Padding(
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
                  Text('FIDAS ID : ' + id.toString()),
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
                                builder: (context) => Tracker()));
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
    );
  }
}
