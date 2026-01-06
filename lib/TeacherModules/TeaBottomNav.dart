import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpass/TeacherModules/AllStudents.dart';
import 'package:getpass/TeacherModules/TeaProfile.dart';
import 'package:getpass/TeacherModules/TeacherHome.dart';
import 'package:intl/intl.dart';
import 'TeaApprovedLeaves.dart';
import 'TeaRejectedLeaves.dart';

class TeaBottomNav extends StatefulWidget {
  const TeaBottomNav({super.key});
  @override
  State<TeaBottomNav> createState() => _TeaBottomNavState();
}

class _TeaBottomNavState extends State<TeaBottomNav> {
  @override
  void initState() {
    super.initState();
    resetLeaveIfNewMonth();
  }
  bool studTab=false;
  int selectedPage=0;
  final List<Widget> modules=[
    TeacherHome(),
    AllStudents(),
    TeaProfile()
  ];

  void resetLeaveIfNewMonth() async {
    FirebaseAuth auth=FirebaseAuth.instance;
    FirebaseFirestore firestore=FirebaseFirestore.instance;

    User? user = auth.currentUser;
    DocumentReference teaRef=firestore.collection('Students').doc(user!.uid);
    DocumentSnapshot teaDoc=await teaRef.get();

    Map<String, dynamic> studentData=teaDoc.data() as Map<String, dynamic>;

    String currentMonth=DateFormat('yyyy-MM').format(DateTime.now());
    String lastReset=studentData['lastReset'];
    if (lastReset != currentMonth) {
      await teaRef.update({
        'totalLeave': 0,
        'lastReset': currentMonth,
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text("Teachers Dashboard"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        onTap: (int index){
          setState(() {
            selectedPage=index;
          });
        },
        selectedItemColor:  const Color(0xFF074799),
        unselectedItemColor:  const Color(0xFF074799),
        items:  const [
          BottomNavigationBarItem(
            label: "Requests",
            icon: Icon(Icons.watch_later_rounded)
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
      drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/VVP.jpg"),fit: BoxFit.fill)),
                  child: null
              ),
              ListTile(
                  title: const Text("View Leaves"),
                  trailing: studTab?const Icon(Icons.keyboard_arrow_up_rounded):const Icon(Icons.keyboard_arrow_down_rounded),
                  onTap: (){
                    studTab=studTab?false:true;
                    setState(() {
                    });
                  }
              ),
              studTab?
              Column(
                children: [
                  ListTile(
                    title: const Text("Approved Leaves"),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                    leading: const Icon(Icons.check_rounded,size: 20,color: Color(0xff1DB954),),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (builder){
                        return const TeaApprovedLeaves();
                      }));
                    },
                  ),
                  Container(
                    height: 1,width: MediaQuery.of(context).size.width,
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                  ListTile(
                    title: const Text("Rejected Leaves"),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                    leading: const Icon(Icons.close_rounded,size: 20,color: Color(0xffDC3545)),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (builder){
                        return TeaRejectedLeaves();
                      }));
                    },
                  ),
                ],
              ):const SizedBox(),
              Container(
                height: 1,width: MediaQuery.of(context).size.width,
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ],
          )
      ),
    );
  }
}