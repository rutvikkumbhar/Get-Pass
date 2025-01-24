import 'package:flutter/material.dart';
import 'package:getpass/HODsModules/DeptStudents.dart';
import 'package:getpass/HODsModules/HODsHome.dart';
import 'package:getpass/HODsModules/HODsProfile.dart';
import 'package:getpass/HODsModules/DeptTeacher.dart';

import 'ViewFeedback.dart';

class hodBottomNav extends StatefulWidget {
  @override
  State<hodBottomNav> createState() => _hodBottomNavState();
}

class _hodBottomNavState extends State<hodBottomNav> {

  int selectedPage=0;
  final List<Widget> modules=[
    HODsHome(),
    DeptTeacher(),
    DeptStudents(),
    ViewFeedback(),
    HODsProfile(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HODs Dashboard"),
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
        selectedItemColor: const Color(0xFF074799),
        unselectedItemColor: const Color(0xFF074799),
        items: const [
          BottomNavigationBarItem(
              label: "Requests",
              icon: Icon(Icons.watch_later_rounded)
          ),
          BottomNavigationBarItem(
              label: "Teachers",
              icon: Icon(Icons.school_outlined)
          ),
          BottomNavigationBarItem(
              label: "Students",
              icon: Icon(Icons.school_rounded)
          ),
          BottomNavigationBarItem(
              label: "Feedback",
              icon: Icon(Icons.feedback_rounded)
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