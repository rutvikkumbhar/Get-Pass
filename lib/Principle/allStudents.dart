import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class allStudents extends StatelessWidget {

  CollectionReference ref1=FirebaseFirestore.instance.collection('Students');
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: ref1.snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot> streamSnapshot){
            if(streamSnapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            } else if(streamSnapshot.hasError){
              return Center(child: Text("Something went wrong"),);
            } else {
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
                        subtitle: Text("Class: ${data['class']}",style:  TextStyle(fontWeight: FontWeight.w500)),
                        leading: Container(
                          height: 55,width: 55,
                          decoration: BoxDecoration(image: DecorationImage(image:data['photoURL']==null? AssetImage("assets/images/teacherpfp.png") :NetworkImage(data['photoURL']),fit: BoxFit.contain),
                              borderRadius: BorderRadius.circular(60)),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        )
    );
  }
}