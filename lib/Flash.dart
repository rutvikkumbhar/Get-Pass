import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpass/HODsModules/hodBottomnNav.dart';
import 'package:getpass/Login/LoginOption.dart';
import 'package:getpass/StudentModules/StudBottomNav.dart';
import 'package:getpass/TeacherModules/TeaBottomNav.dart';
import 'package:google_fonts/google_fonts.dart';

class Flash extends StatefulWidget {

  @override
  State<Flash> createState() => _FlashState();
}

class _FlashState extends State<Flash> {

  CollectionReference student=FirebaseFirestore.instance.collection('Students');
  CollectionReference teacher=FirebaseFirestore.instance.collection('Teachers');
  CollectionReference hod=FirebaseFirestore.instance.collection('HODs');
  final FirebaseAuth _auth=FirebaseAuth.instance;

  void initState(){
    super.initState();
    Timer(const Duration(seconds: 3),() async {
      if(_auth.currentUser!=null){
          DocumentSnapshot studDoc=await student.doc(_auth.currentUser!.uid).get();
          Map<String, dynamic>? studData=studDoc.exists?studDoc.data() as Map<String, dynamic>:null;
          DocumentSnapshot teaDoc=await teacher.doc(_auth.currentUser!.uid).get();
          Map<String, dynamic>? teaData=teaDoc.exists?teaDoc.data() as Map<String, dynamic>:null;
          DocumentSnapshot hodDoc=await hod.doc(_auth.currentUser!.uid).get();
          Map<String, dynamic>? hodData=hodDoc.exists?hodDoc.data() as Map<String, dynamic>:null;

          if(studData!=null && studData['userType']=="Student"){
            Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => StudBottomNav()),
                  (Route<dynamic> route) => false,);
          } else if(teaData!=null && teaData['userType']=="Teacher"){
            Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => TeaBottomNav()),
                  (Route<dynamic> route) => false,);
          } else if(hodData!=null && hodData['userType']=="HOD"){
            Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => hodBottomNav()),
                  (Route<dynamic> route) => false,);
          }
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder){
          return LoginOption();
        }));
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,width: 100,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/vvplogo.jpg"),fit: BoxFit.fill)),
            ),
            Text("VVP Polytechnic",style: GoogleFonts.acme(fontSize: 23),),
            const SizedBox(
              height: 20,width: 20,
                child: CircularProgressIndicator(color: Color(0xffF26B0F)))
          ],
        ),
      ),
    );
  }
}