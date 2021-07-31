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

  void initState() {
    super.initState();
  }

  void getdetails(String? id, String? username, String? phone) async {
    var res = await firestore.FirebaseFirestore.instance
        .collection('Users')
        .where('Fidas ID', isEqualTo: id)
        .get();
    var data = res.docs.first;
    print(res.size);
    setState(() {
      username = data.data()['Username'];
      phone = data.data()['Phone'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_getDbList);

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
        child: FirebaseAnimatedList(
            query: _getDbList,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              Map Fidasmap = snapshot.value;
              String? Fidasid = Fidasmap['ID'];
              String? FidasStatus = Fidasmap['Status'].toString();
              String? Fidasusername;
              String? Fidasphone;
              getdetails(Fidasmap['ID'], Fidasusername, Fidasphone);

              print('working');

              if (Fidasmap.isEmpty) {
                print('isempty');

                return Container(
                  child: Center(
                    child: Text('No registered user'),
                  ),
                );
              } else {
                print('not empty');
                return _FidasList(Fidasmap['ID'], Fidasusername, Fidasphone);
              }
            }),
      ),
    );
  }

  Widget _FidasList(String? id, String? username, String? phone) {
    return InkWell(
      child: Card(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('FIDAS ID : ' + id.toString()),
              Row(
                children: [
                  Column(
                    children: [
                      Text(username.toString()),
                      Text(phone.toString())
                    ],
                  ),
                  InkWell(
                    child: Container(
                      child: Center(
                        child: Text('Track'),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
