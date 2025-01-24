import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpass/HODsModules/StudentRequest.dart';
import 'package:getpass/HODsModules/TeacherRequest.dart';

class HODsHome extends StatefulWidget {
  @override
  State<HODsHome> createState() => _HODsHomeState();
}

class _HODsHomeState extends State<HODsHome> {
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: const Color(0xffDBE2EF),borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                title: const Text("Student Request",style: TextStyle(color: Colors.black,fontSize: 17),),
                subtitle: const Text("View students recent leave request"),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder){
                    return StudentRequest();
                  }));
                },
              ),
            ),
            const SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: const Color(0xffDBE2EF),borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                title: const Text("Teachers Request",style: TextStyle(color: Colors.black,fontSize: 17),),
                subtitle: const Text("View teacher recent leave request"),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder){
                    return TeacherRequest();
                  }));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}