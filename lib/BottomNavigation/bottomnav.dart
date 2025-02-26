import 'package:auraflixx/Screens/homepage.dart';
import 'package:auraflixx/Screens/moviepage.dart';
import 'package:auraflixx/Screens/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomnavigationPage extends StatefulWidget {
  const BottomnavigationPage({super.key});

  @override
  State<BottomnavigationPage> createState() => _BottomnavigationPageState();
}

class _BottomnavigationPageState extends State<BottomnavigationPage> {
  int selectedIndex = 0;
  List<Widget> pages = [Homepage(), MoviePage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          showUnselectedLabels: false,
          showSelectedLabels: false,
          backgroundColor: Color(0xff15141F),

          items: [
        BottomNavigationBarItem(
            icon:selectedIndex==0? SvgPicture.asset('images/svg/Home.svg'):SvgPicture.asset('images/svg/homesel.svg'), label: 'home'),
        BottomNavigationBarItem(
            icon:selectedIndex==1? SvgPicture.asset('images/svg/PlaySelected.svg'):SvgPicture.asset('images/svg/Play.svg'), label: 'play'),
        BottomNavigationBarItem(
            icon:selectedIndex==2?Icon(Icons.person,size: 40,color: Colors.deepOrangeAccent,): Icon(Icons.person,size: 40,color: Color(0xff3d3c45),), label: 'person')
      ]),
    );
  }
}
