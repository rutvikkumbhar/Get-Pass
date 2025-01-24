import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../About.dart';
import '../Help.dart';
import '../Login/LoginOption.dart';

class HODsProfile extends StatelessWidget {

  final FirebaseAuth _auth=FirebaseAuth.instance;
  CollectionReference ref=FirebaseFirestore.instance.collection('HODs');
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              StreamBuilder(
                stream: ref.doc(_auth.currentUser!.uid).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> streamSnapshot){
                  if(streamSnapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  } else if(streamSnapshot.hasError){
                    return const Center(child: Text("Something went wrong"),);
                  } else {
                    Map<String, dynamic> data=streamSnapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      children: [
                        Container(
                          width:MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              const SizedBox(height: 30,),
                              Container(
                                height: 110,width: 110,
                                decoration: BoxDecoration(image: DecorationImage(image:data['photoURL']==null?const AssetImage("assets/images/teacherpfp.png") :NetworkImage(data['photoURL']),fit: BoxFit.fill),
                                    borderRadius: BorderRadius.circular(60)),
                              ),
                              const SizedBox(height: 15,),
                              Text("Prof. ${data['name']}",style: const TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                              const SizedBox(height: 30,),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text("Department",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15),),
                                subtitle: Text("${data['dept']}",style: const TextStyle(color: Colors.black,fontSize: 17),),
                                leading: const Icon(Icons.photo_size_select_small_rounded,color: Color(0xff3F72AF),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10),
                                child: Container(
                                  height: 1,width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              ListTile(
                                title: Text("Contact Number",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15),),
                                subtitle: Text("+91 ${data['contact']}",style: const TextStyle(color: Colors.black,fontSize: 17),),
                                leading: const Icon(Icons.call,color: Color(0xff3F72AF),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10),
                                child: Container(
                                  height: 1,width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              ListTile(
                                title: Text("Email Address",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15),),
                                subtitle: Text("${data['email']}",style: const TextStyle(color: Colors.black,fontSize: 17),),
                                leading: const Icon(Icons.email_rounded,color: Color(0xff3F72AF),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10),
                                child: Container(
                                  height: 1,width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              ListTile(
                                title: Text("Education",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15),),
                                subtitle: Text("${data['education']}",style: const TextStyle(color: Colors.black,fontSize: 17),),
                                leading: const Icon(Icons.school_rounded,color: Color(0xff3F72AF),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10),
                                child: Container(
                                  height: 1,width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                                ),
                              ),
                              const SizedBox(height: 20,),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:10),
                      child: ListTile(
                        title: const Text("Help",style: TextStyle(color: Colors.black,fontSize: 17)),
                        leading: const Icon(Icons.help_rounded,color: Color(0xff3F72AF),),
                        trailing: const Icon(Icons.keyboard_arrow_right_rounded,size: 28,),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (builder){
                            return Help();
                          }));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Container(
                        height: 1,width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(top:10),
                      child: ListTile(
                        title: const Text("About",style: TextStyle(color: Colors.black,fontSize: 17)),
                        leading: const Icon(Icons.info_rounded,color: Color(0xff3F72AF),),
                        trailing: const Icon(Icons.keyboard_arrow_right_rounded,size: 28,),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (builder){
                            return About();
                          }));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Container(
                        height: 1,width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(top:10),
                      child: ListTile(
                        title: const Text("Log Out",style: TextStyle(color: Colors.black,fontSize: 17)),
                        leading: const Icon(Icons.help_rounded,color: Color(0xff3F72AF),),
                        trailing: const Icon(Icons.keyboard_arrow_right_rounded,size: 28,),
                        onTap: (){
                          _auth.signOut();
                          Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => LoginOption()),
                                (Route<dynamic> route) => false,);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Container(
                        height: 1,width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                      ),
                    ),
                    const SizedBox(height: 20,)
                  ],
                ),
              ),
              const SizedBox(height: 30,),
            ],
          ),
        )
    );
  }

}