import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../About.dart';
import '../Help.dart';
import '../Login/LoginOption.dart';

class pProfile extends StatelessWidget {

  FirebaseAuth _auth=FirebaseAuth.instance;
  CollectionReference ref=FirebaseFirestore.instance.collection('Principle');
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding:  EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              StreamBuilder(
                stream: ref.doc(_auth.currentUser!.uid).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> streamSnapshot){
                  if(streamSnapshot.connectionState == ConnectionState.waiting){
                    return  Center(child: CircularProgressIndicator(),);
                  } else if(streamSnapshot.hasError){
                    return  Center(child: Text("Something went wrong"),);
                  } else {
                    Map<String, dynamic> data=streamSnapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      children: [
                        Container(
                          width:MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              SizedBox(height: 30,),
                              Container(
                                height: 110,width: 110,
                                decoration: BoxDecoration(image: DecorationImage(image:data['photoURL']==null? AssetImage("assets/images/teacherpfp.png") :NetworkImage(data['photoURL']),fit: BoxFit.fill),
                                    borderRadius: BorderRadius.circular(60)),
                              ),
                              SizedBox(height: 13,),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text("${data['name']}",style:  TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                              ),
                              SizedBox(height: 30,),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text("Principle",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15),),
                                subtitle: Text("${data['college']}",style:  TextStyle(color: Colors.black,fontSize: 17),),
                                leading:  Icon(Icons.photo_size_select_small_rounded,color: Color(0xff3F72AF),),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(left: 10,right: 10),
                                child: Container(
                                  height: 1,width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                                ),
                              ),
                              SizedBox(height: 10,),
                              ListTile(
                                title: Text("Contact Number",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15),),
                                subtitle: Text("+91 ${data['contact']}",style:  TextStyle(color: Colors.black,fontSize: 17),),
                                leading:  Icon(Icons.call,color: Color(0xff3F72AF),),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(left: 10,right: 10),
                                child: Container(
                                  height: 1,width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                                ),
                              ),
                              SizedBox(height: 10,),
                              ListTile(
                                title: Text("Email Address",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15),),
                                subtitle: Text("${data['email']}",style:  TextStyle(color: Colors.black,fontSize: 17),),
                                leading:  Icon(Icons.email_rounded,color: Color(0xff3F72AF),),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(left: 10,right: 10),
                                child: Container(
                                  height: 1,width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                                ),
                              ),
                              SizedBox(height: 10,),
                              ListTile(
                                title: Text("ID",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15),),
                                subtitle: Text("${data['userID']}",style:  TextStyle(color: Colors.black,fontSize: 17),),
                                leading:  Icon(Icons.school_rounded,color: Color(0xff3F72AF),),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(left: 10,right: 10),
                                child: Container(
                                  height: 1,width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                                ),
                              ),
                              SizedBox(height: 20,),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(top:10),
                      child: ListTile(
                        title:  Text("Help",style: TextStyle(color: Colors.black,fontSize: 17)),
                        leading:  Icon(Icons.help_rounded,color: Color(0xff3F72AF),),
                        trailing:  Icon(Icons.keyboard_arrow_right_rounded,size: 28,),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (builder){
                            return Help();
                          }));
                        },
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 10,right: 10),
                      child: Container(
                        height: 1,width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding:  EdgeInsets.only(top:10),
                      child: ListTile(
                        title:  Text("About",style: TextStyle(color: Colors.black,fontSize: 17)),
                        leading:  Icon(Icons.info_rounded,color: Color(0xff3F72AF),),
                        trailing:  Icon(Icons.keyboard_arrow_right_rounded,size: 28,),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (builder){
                            return About();
                          }));
                        },
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 10,right: 10),
                      child: Container(
                        height: 1,width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding:  EdgeInsets.only(top:10),
                      child: ListTile(
                        title:  Text("Log Out",style: TextStyle(color: Colors.black,fontSize: 17)),
                        leading:  Icon(Icons.logout_outlined,color: Color(0xff3F72AF),),
                        trailing:  Icon(Icons.keyboard_arrow_right_rounded,size: 28,),
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
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 10,right: 10),
                      child: Container(
                        height: 1,width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
              SizedBox(height: 30,),
            ],
          ),
        )
    );
  }
}