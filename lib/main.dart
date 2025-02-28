import 'package:auraflixx/BottomNavigation/bottomnav.dart';
import 'package:auraflixx/Screens/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (p0, p1, p2) => 
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BottomnavigationPage(),
      ),
    );
  }
}
