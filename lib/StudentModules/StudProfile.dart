import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpass/About.dart';
import 'package:getpass/Login/LoginOption.dart';
import '../Help.dart';

class Studprofile extends StatelessWidget {

  final FirebaseAuth _auth=FirebaseAuth.instance;
  CollectionReference ref=FirebaseFirestore.instance.collection('Students');

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding:  EdgeInsets.fromLTRB(15, 5, 15, 0),
            child: Container(
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding:  EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: StreamBuilder(
                  stream: ref.doc(_auth.currentUser!.uid).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> streamSnapshot){
                    if(streamSnapshot.connectionState == ConnectionState.waiting){
                      return  Center(child: CircularProgressIndicator(),);
                    } else if(streamSnapshot.hasError){
                      return  Center(child: Text("Something went wrong"),);
                    } else {
                      Map<String, dynamic> data=streamSnapshot.data!.data() as Map<String, dynamic>;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 90,width: 90,
                                decoration: BoxDecoration(image: DecorationImage(image:data['photoURL']==null? AssetImage("assets/images/studentpfp.png")
                                        :NetworkImage(data['photoURL']),fit: BoxFit.contain),
                                    borderRadius: BorderRadius.circular(60)),
                              ),
                               SizedBox(width: 20,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${data['name']}",style:  TextStyle(fontSize: 19,fontWeight: FontWeight.w500),),
                                  Text("${data['email']}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.black87.withOpacity(0.7)),),
                                  Text("EnNo. ${data['enroll']}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.black87.withOpacity(0.7)),)
                                ],
                              ),
                            ],
                          ),
                           SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text("Class",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black.withOpacity(0.5)),),
                                  subtitle: Text("${data['class']}",style:  TextStyle(color: Color(0xFF074799),fontWeight: FontWeight.w600),),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text("Department",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black.withOpacity(0.5))),
                                  subtitle: Text("${data['dept']}",style:  TextStyle(color: Color(0xFF074799),fontWeight: FontWeight.w600),),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text("Class coordinator",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black.withOpacity(0.5)),),
                                  subtitle: Text("Prof. ${data['ctName']}",style:  TextStyle(color: Color(0xFF074799),fontWeight: FontWeight.w600),),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text("HOD",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black.withOpacity(0.5))),
                                  subtitle: Text("Prof. ${data['hodName']}",style:  TextStyle(color: Color(0xFF074799),fontWeight: FontWeight.w600),),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text("Contact",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black.withOpacity(0.5)),),
                                  subtitle: Text("+91 ${data['contact']}",style:  TextStyle(color: Color(0xFF074799),fontWeight: FontWeight.w600),),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text("Student ID",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black.withOpacity(0.5))),
                                  subtitle: Text("${data['userID']}",style:  TextStyle(color: Color(0xFF074799),fontWeight: FontWeight.w600),),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 175,
                                child: ListTile(
                                  title: Text("Total leaves",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black.withOpacity(0.5)),),
                                  subtitle: Text("${data['totalLeave']}",style:  TextStyle(color: Color(0xFF074799),fontWeight: FontWeight.w600),),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
           SizedBox(height: 10,),
          Padding(
            padding:  EdgeInsets.fromLTRB(15, 5, 15, 0),
            child: Container(
              child:
              Container(
                height: 250,
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:  EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListTile(
                        title:  Text("About"),
                        subtitle:  Text("More about Get Pass app and the developer.",style: TextStyle(color: Color(0xff4F7A94)),),
                        leading:  Icon(Icons.info,color: Color(0xff006BFF),),
                        trailing:  Icon(Icons.keyboard_arrow_right_rounded),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (builder){
                            return About();
                          }));
                        },
                      ),
                      ListTile(
                        title:  Text("Help"),
                        subtitle:  Text("Manage your account.",style: TextStyle(color: Color(0xff4F7A94)),),
                        leading:  Icon(Icons.help_rounded,color: Color(0xff006BFF)),
                        trailing:  Icon(Icons.keyboard_arrow_right_rounded),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (builder){
                            return Help();
                          }));
                        },
                      ),
                      ListTile(
                        title:  Text("Log out"),
                        subtitle:  Text("Account should not be deleted.",style: TextStyle(color: Color(0xff4F7A94)),),
                        leading:  Icon(Icons.logout_rounded,color: Color(0xff006BFF)),
                        trailing:  const Icon(Icons.keyboard_arrow_right_rounded),
                        onTap: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return  AlertDialog(
                                title: Text("Confirm Logout"),
                                content: Text("Are you sure you want to log out?"),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Log Out"),
                                    onPressed: (){
                                      _auth.signOut();
                                      Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => LoginOption()),
                                            (Route<dynamic> route) => false,);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      )
    );
  }

}