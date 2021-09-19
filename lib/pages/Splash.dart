import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.orangeAccent, Colors.orange, Colors.red],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/splashimage.jpg'))),
            ),
          ],
        ));
  }
}
