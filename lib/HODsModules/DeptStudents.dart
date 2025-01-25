import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeptStudents extends StatelessWidget {

  FirebaseAuth _auth=FirebaseAuth.instance;
  Future<String> dept() async {
    DocumentSnapshot docData=await FirebaseFirestore.instance.collection('HODs').doc(_auth.currentUser!.uid).get();
    print("Dept is ${docData['dept']}");
    return docData['dept'].toString();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dept(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        } else if(snapshot.hasError){
          return Center(child: Text("Something went wrong"),);
        } else {
          String dept=snapshot.data.toString();
          print("Dept is: $dept");
          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Students').where("dept", isEqualTo: dept ).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
              if(streamSnapshot.connectionState == ConnectionState.waiting){
                return  Center(child: CircularProgressIndicator(),);
              } else if(streamSnapshot.hasError){
                return  Center(child: Text("Something went wrong"),);
              } else if(streamSnapshot.hasData==false || streamSnapshot.data!.docs.isEmpty){
                return Center(child: Text("No any student listed"),);
              } else{
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (itemBuilder, index){
                    DocumentSnapshot data=streamSnapshot.data!.docs[index];
                    return Padding(
                      padding:  EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(5)),
                        child: ListTile(
                          title: Text("${data['name']}",style:  TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                          subtitle: Text("En No. ${data['enroll']}",style:  TextStyle(fontWeight: FontWeight.w500)),
                          leading: Container(
                            height: 55,width: 55,
                            decoration: BoxDecoration(image: DecorationImage(image: data['photoURL']==null? AssetImage("assets/images/studentpfp.png")
                                :NetworkImage(data['photoURL']),fit: BoxFit.contain),
                                borderRadius: BorderRadius.circular(60)),
                          ),
                          trailing: Text("${data['class']}",style:  TextStyle(fontSize: 13),),
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
    );
  }
}