import 'package:final_year_project_gnfs/widgets/draweritems.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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
              String Fidasid;
              String FidasStatus;

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
                return Container();
              }
            }),
      ),
    );
  }
}
