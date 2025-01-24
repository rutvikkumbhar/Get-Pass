import 'package:flutter/material.dart';
import 'package:getpass/TeacherModules/AllStudents.dart';
import 'package:getpass/TeacherModules/TeaProfile.dart';
import 'package:getpass/TeacherModules/TeacherHome.dart';
import 'TeacherrLeaves.dart';

class TeaBottomNav extends StatefulWidget {
  @override
  State<TeaBottomNav> createState() => _TeaBottomNavState();
}

class _TeaBottomNavState extends State<TeaBottomNav> {

  int selectedPage=0;
  final List<Widget> modules=[
    TeacherHome(),
    TeacherLeaves(),
    AllStudents(),
    TeaProfile()
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teachers Dashboard"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        onTap: (int index){
          setState(() {
            selectedPage=index;
          });
        },
        selectedItemColor: const Color(0xFF074799),
        unselectedItemColor: const Color(0xFF074799),
        items: const [
          BottomNavigationBarItem(
            label: "Requests",
            icon: Icon(Icons.watch_later_rounded)
          ),
          BottomNavigationBarItem(
              label: "Leaves",
              icon: Icon(Icons.access_time_rounded)
          ),
          BottomNavigationBarItem(
              label: "Students",
              icon: Icon(Icons.school_rounded)
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