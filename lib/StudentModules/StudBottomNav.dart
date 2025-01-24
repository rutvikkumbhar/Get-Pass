import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:getpass/StudentModules/StudProfile.dart';
import 'package:getpass/StudentModules/StudHome.dart';
import 'LeaveList.dart';

class StudBottomNav extends StatefulWidget {
  @override
  State<StudBottomNav> createState() => _StudBottomNavState();
}

class _StudBottomNavState extends State<StudBottomNav> {

  FirebaseMessaging firebaseMessaging=FirebaseMessaging.instance;

  int selectedPage=0;
  final List<Widget> modules=[
    StudHome(),
    LeaveList(),
    Studprofile()
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Pass"),
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
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home_filled)
          ),
          BottomNavigationBarItem(
              label: "Leaves",
              icon: Icon(Icons.access_time_filled_rounded)
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