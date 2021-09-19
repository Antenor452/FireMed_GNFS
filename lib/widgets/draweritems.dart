import 'package:final_year_project_gnfs/pages/Login.dart';
import 'package:final_year_project_gnfs/pages/Splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerItems extends StatelessWidget {
  const DrawerItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFFFF5C00)),
                child: Container()),
            ListTile(
              title: Text('Logout'),
              onTap: () async {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Login()),
                    (route) => false);

                await FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
