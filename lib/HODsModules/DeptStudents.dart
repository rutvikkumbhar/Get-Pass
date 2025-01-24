import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeptStudents extends StatelessWidget {
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Students').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
        if(streamSnapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        } else if(streamSnapshot.hasError){
          return const Center(child: Text("Something went wrong"),);
        } else {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (itemBuilder, index){
              DocumentSnapshot data=streamSnapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(5)),
                    child: ListTile(
                      title: Text("${data['name']}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                      subtitle: Text("En No. ${data['enroll']}",style: const TextStyle(fontWeight: FontWeight.w500)),
                      leading: Container(
                        height: 55,width: 55,
                        decoration: BoxDecoration(image: DecorationImage(image: data['photoURL']==null?const AssetImage("assets/images/studentpfp.png")
                                :NetworkImage(data['photoURL']),fit: BoxFit.contain),
                            borderRadius: BorderRadius.circular(60)),
                      ),
                      trailing: Text("${data['class']}",style: const TextStyle(fontSize: 13),),
                    ),
                  ),
                );
            },
          );
        }
      },
    );
  }
}