import 'package:flutter/material.dart';
import 'package:getpass/Principle/PrinHODApprovedLeaves.dart';
import 'package:getpass/Principle/PrinHODRejectedLeaves.dart';
import 'package:getpass/Principle/PrinTeacherApprovedLeaves.dart';
import 'package:getpass/Principle/PrinTeacherRejectedLeaves.dart';
import 'allHODs.dart';
import 'allStudents.dart';
import 'allTeachers.dart';
import 'pHome.dart';
import 'pProfile.dart';

class pBottomNav extends StatefulWidget {

  State<pBottomNav> createState() => _pBottomNavState();
}

class _pBottomNavState extends State<pBottomNav> {

  int selectedPage=0;
  bool studTab=false;
  bool teaTab=false;
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
                icon: Icon(Icons.school_rounded)
            ),
            BottomNavigationBarItem(
                label: "Students",
                icon: Icon(Icons.school_outlined)
            ),
            BottomNavigationBarItem(
                label: "Profile",
                icon: Icon(Icons.person)
            ),
          ],
        ),
      body: modules[selectedPage],
      drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/VVP.jpg"),fit: BoxFit.fill)),
                  child: null
              ),
              ListTile(
                  title: Text("HOD Leaves"),
                  trailing: studTab?Icon(Icons.keyboard_arrow_up_rounded):Icon(Icons.keyboard_arrow_down_rounded),
                  onTap: (){
                    studTab=studTab?false:true;
                    setState(() {
                    });
                  }
              ),
              studTab?
              Container(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text("Approved Leaves"),
                      trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                      leading: const Icon(Icons.check_rounded,size: 20,color: Color(0xff1DB954),),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (builder){
                          return PrinHODApprovedLeaves();
                        }));
                      },
                    ),
                    Container(
                      height: 1,width: MediaQuery.of(context).size.width,
                      color: Colors.black.withOpacity(0.1),
                    ),
                    ListTile(
                      title: const Text("Rejected Leaves"),
                      trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                      leading: const Icon(Icons.close_rounded,size: 20,color: Color(0xffDC3545)),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (builder){
                          return PrinHODRejectedLeaves();
                        }));
                      },
                    ),
                  ],
                ),
              ):SizedBox(),
              Container(
                height: 1,width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.1),
              ),
              ListTile(
                  title: Text("Staf Leaves"),
                  trailing: teaTab?Icon(Icons.keyboard_arrow_up_rounded):Icon(Icons.keyboard_arrow_down_rounded),
                  onTap: (){
                    teaTab=teaTab?false:true;
                    setState(() {
                    });
                  }
              ),
              teaTab?
              Container(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text("Approved Leaves"),
                      trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                      leading: const Icon(Icons.check_rounded,size: 20,color: Color(0xff1DB954),),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (builder){
                          return PrinTeacherApprovedLeaves();
                        }));
                      },
                    ),
                    Container(
                      height: 1,width: MediaQuery.of(context).size.width,
                      color: Colors.black.withOpacity(0.1),
                    ),
                    ListTile(
                      title: const Text("Rejected Leaves"),
                      trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                      leading: const Icon(Icons.close_rounded,size: 20,color: Color(0xffDC3545)),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (builder){
                          return PrinTeacherRejectedLeaves();
                        }));
                      },
                    ),
                  ],
                ),
              ):SizedBox(),
              Container(
                height: 1,width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          )
      ),
    );
  }
}