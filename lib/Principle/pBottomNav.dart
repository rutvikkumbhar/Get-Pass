import 'package:flutter/material.dart';
import 'allHODs.dart';
import 'allStudents.dart';
import 'allTeachers.dart';
import 'pHome.dart';
import 'pProfile.dart';

class pBottomNav extends StatefulWidget {

  @override
  State<pBottomNav> createState() => _pBottomNavState();
}

class _pBottomNavState extends State<pBottomNav> {
  int selectedPage=0;

  final List<Widget> modules=[
    pHome(),
    allHODs(),
    allTeachers(),
    allStudents(),
    pProfile(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Principle Dashboard"),
        centerTitle: true,
      ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedPage,
          onTap: (int index){
            setState(() {
              selectedPage=index;
            });
          },
          showUnselectedLabels: false,
          selectedItemColor:  Color(0xFF074799),
          unselectedItemColor:  Color(0xFF074799),
          items:  [
            BottomNavigationBarItem(
                label: "Home",
                icon: Icon(Icons.home_filled)
            ),
            BottomNavigationBarItem(
                label: "HODs",
                icon: Icon(Icons.school_rounded)
            ),
            BottomNavigationBarItem(
                label: "Teachers",
                icon: Icon(Icons.school_outlined)
            ),
            BottomNavigationBarItem(
                label: "Students",
                icon: Icon(Icons.child_care_outlined)
            ),
            BottomNavigationBarItem(
                label: "Profile",
                icon: Icon(Icons.person)
            ),
          ],
        ),
      body: modules[selectedPage],
    );
  }
}