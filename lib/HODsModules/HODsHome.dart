import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpass/HODsModules/StudentRequest.dart';
import 'package:getpass/HODsModules/TeacherRequest.dart';

import 'ApplyLeave.dart';
import 'HODLeaves.dart';

class HODsHome extends StatefulWidget {
  @override
  State<HODsHome> createState() => _HODsHomeState();
}

class _HODsHomeState extends State<HODsHome> {
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.fromLTRB(15, 10, 15, 0),
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
                    return StudentRequest();
                  }));
                },
              ),
            ),
             SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color:  Color(0xffDBE2EF),borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                title:  Text("Teachers Request",style: TextStyle(color: Colors.black,fontSize: 17),),
                subtitle:  Text("View teacher recent leave request"),
                trailing:  Icon(Icons.keyboard_arrow_right_outlined),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder){
                    return TeacherRequest();
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
                subtitle:  Text("The leave application will be sent to principle"),
                trailing:  Icon(Icons.keyboard_arrow_right_outlined),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder){
                    return ApplyLeave();
                  }));
                },
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color:  Color(0xffDBE2EF),borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                title:  Text("View your leaves",style: TextStyle(color: Colors.black,fontSize: 17),),
                subtitle:  Text("Your all leaves and their current status"),
                trailing:  Icon(Icons.keyboard_arrow_right_outlined),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder){
                    return HODLeaves();
                  }));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}