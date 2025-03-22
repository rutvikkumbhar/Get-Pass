import 'package:flutter/material.dart';
import 'package:getpass/HODsModules/DeptStudents.dart';
import 'package:getpass/HODsModules/HODsHome.dart';
import 'package:getpass/HODsModules/HODsProfile.dart';
import 'package:getpass/HODsModules/DeptTeacher.dart';
import 'ViewFeedback.dart';
import 'hodApprovedTeacher.dart';
import 'hodRejectedTeacher.dart';
import 'hodStudApprovedRequest.dart';
import 'hodStudRejectedRequest.dart';

class hodBottomNav extends StatefulWidget {
  @override
  State<hodBottomNav> createState() => _hodBottomNavState();
}

class _hodBottomNavState extends State<hodBottomNav> {

  bool studTab=false;
  bool teaTab=false;
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
        title:  const Text("HODs Dashboard"),
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
        selectedItemColor:  const Color(0xFF074799),
        unselectedItemColor:  const Color(0xFF074799),
        items:  const [
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
      drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/VVP.jpg"),fit: BoxFit.fill)),
                  child: null
              ),
              ListTile(
                title: Text("Students Leaves"),
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
                          return hodStudApprovedRequest();
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
                          return hodStudRejectedRequest();
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
                  title: Text("Admin Leaves"),
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
                              return hodApprovedTeacher();
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
                              return hodRejectedTeacher();
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