import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpass/TeacherModules/RequestLeave.dart';
import 'package:getpass/TeacherModules/StudentAllRequest.dart';
import 'package:getpass/TeacherModules/TeacherrLeaves.dart';
import '../SendLeaveNotificastion.dart';

class TeacherHome extends StatefulWidget {
  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  final FirebaseAuth _auth=FirebaseAuth.instance;

  Future<String> deptName() async {
    DocumentSnapshot docData=await FirebaseFirestore.instance.collection('Teachers').doc(_auth.currentUser!.uid).get();
    return docData['dept'].toString();
  }
  Future<int> studTotalLeaves() async {
    DocumentSnapshot studDoc=await FirebaseFirestore.instance.collection('Teachers').doc(_auth.currentUser!.uid).get();
    return int.parse(studDoc['totalLeave'].toString());
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color:  Color(0xffDBE2EF),borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                title:  Text("Student Request",style: TextStyle(color: Colors.black,fontSize: 17),),
                subtitle:  Text("View students recent leave request"),
                trailing:  Icon(Icons.keyboard_arrow_right_outlined),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder){
                    return StudentAllRequest();
                  }));
                },
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color:  Color(0xffDBE2EF),borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                title:  Text("Apply for leave",style: TextStyle(color: Colors.black,fontSize: 17),),
                subtitle:  Text("The leave application will be sent to principle and HOD"),
                trailing:  Icon(Icons.keyboard_arrow_right_outlined),
                onTap: () async {
                  if(await studTotalLeaves()>=5){
                    showDialog(
                        context: context,
                        builder: (context)=>AlertDialog(
                          title: Text("Leave Limit Reached"),
                          content: Text("Monthly leave limit (5) reached. Please get a physical pass."),
                          actions: [
                            ElevatedButton(
                              child: Text("Ok"),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            )
                          ],
                        )
                    );
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (builder){
                      return RequestLeave();
                    }));
                  }
                },
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color:  Color(0xffDBE2EF),borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                title:  Text("View your leave",style: TextStyle(color: Colors.black,fontSize: 17),),
                subtitle:  Text("You can view your all leaves."),
                trailing:  Icon(Icons.keyboard_arrow_right_outlined),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder){
                    return TeacherLeaves();
                  }));
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}