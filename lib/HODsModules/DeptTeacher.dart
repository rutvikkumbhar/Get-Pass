import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'AddTeacher.dart';

class DeptTeacher extends StatefulWidget {
  @override
  State<DeptTeacher> createState() => _DeptTeacherState();
}

class _DeptTeacherState extends State<DeptTeacher> {

  final FirebaseAuth _auth=FirebaseAuth.instance;

  Future<String> hodDept() async {
    DocumentSnapshot docData=await FirebaseFirestore.instance.collection('HODs').doc(_auth.currentUser!.uid).get();
    return docData['dept'].toString();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 70,width: 70,
        decoration: BoxDecoration(color: const Color(0xff3F72AF),borderRadius: BorderRadius.circular(25)),
        child: IconButton(
          icon: const Icon(Icons.add_rounded,color: Colors.white,size: 40,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (builder){
              return AddTeacher();
            }));
          },
        ),
      ),
      body: FutureBuilder(
        future: hodDept(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          } else if(snapshot.hasError){
            return const Center(child: Text("Something went wrong."),);
          } else {
            String department=snapshot.data.toString();
            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Teachers').where('dept', isEqualTo: department).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                if(streamSnapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator(),);
                } else if(streamSnapshot.hasError) {
                  return const Center(child: Text("Something went wrong"),);
                } else if(streamSnapshot.hasData==false || streamSnapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No any teacher listed"),);
                } else {
                  return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (itemBuilder, index){
                      DocumentSnapshot data=streamSnapshot.data!.docs[index];
                      return  Padding(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(5)),
                          child: ListTile(
                            title: Text("Prof. ${data['name']}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                            subtitle: Text("Class: ${data['class']}",style: const TextStyle(fontWeight: FontWeight.w500)),
                            leading: Container(
                              height: 55,width: 55,
                              decoration: BoxDecoration(image: DecorationImage(image:data['photoURL']==null?const AssetImage("assets/images/teacherpfp.png") :NetworkImage(data['photoURL']),fit: BoxFit.fill),
                                  borderRadius: BorderRadius.circular(60)),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit,color: Color(0xff3F72AF),),
                              onPressed: (){

                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}