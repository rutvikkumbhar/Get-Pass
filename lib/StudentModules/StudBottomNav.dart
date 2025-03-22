import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpass/StudentModules/StudApprovedLeaves.dart';
import 'package:getpass/StudentModules/StudProfile.dart';
import 'package:getpass/StudentModules/StudHome.dart';
import 'package:intl/intl.dart';
import 'LeaveList.dart';
import 'StudRejectedLeaves.dart';

class StudBottomNav extends StatefulWidget {
  State<StudBottomNav> createState() => _StudBottomNavState();
}

class _StudBottomNavState extends State<StudBottomNav> {
  void initState() {
    super.initState();
    resetLeaveIfNewMonth();
  }
  bool studTab=false;
  int selectedPage=0;
  final List<Widget> modules=[
    StudHome(),
    LeaveList(),
    Studprofile()
  ];

  void resetLeaveIfNewMonth() async {
    FirebaseAuth _auth=FirebaseAuth.instance;
    FirebaseFirestore _firestore=FirebaseFirestore.instance;

    User? user = _auth.currentUser;
    DocumentReference studentRef=_firestore.collection('Students').doc(user!.uid);
    DocumentSnapshot studentDoc=await studentRef.get();

    Map<String, dynamic> studentData=studentDoc.data() as Map<String, dynamic>;

    String currentMonth=DateFormat('yyyy-MM').format(DateTime.now());
    String lastReset=studentData['lastReset'];
    if (lastReset != currentMonth) {
      await studentRef.update({
        'totalLeave': 0,
        'lastReset': currentMonth,
      });
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Get Pass"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        onTap: (int index){
          setState(() {
            selectedPage=index;
          });
        },
        selectedItemColor:  Color(0xFF074799),
        unselectedItemColor:  Color(0xFF074799),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items:  [
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
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/VVP.jpg"),fit: BoxFit.fill)),
                child: null
                ),
            ListTile(
                title: Text("View Leaves"),
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
                        return StudApprovedLeaves();
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
                        return StudRejectedLeaves();
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