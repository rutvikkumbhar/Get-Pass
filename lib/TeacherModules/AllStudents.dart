import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'AddStudent.dart';

class AllStudents extends StatelessWidget {

  final FirebaseAuth _auth=FirebaseAuth.instance;

  Future<String> classTeacher() async {
    DocumentSnapshot docData=await FirebaseFirestore.instance.collection('Teachers').doc(_auth.currentUser!.uid).get();
    return docData['name'].toString();
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
             return AddStudent();
           }));
         },
       ),
     ),
     body: FutureBuilder(
       future: classTeacher(),
       builder: (context, snapshot){
         if(snapshot.connectionState==ConnectionState.waiting){
           return const Center(child: CircularProgressIndicator(),);
         }else if(snapshot.hasError){
           return const Center(child: Text("Something went wrong"),);
         } else {
           return StreamBuilder(
             stream: FirebaseFirestore.instance.collection('Students').snapshots(),
             builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
               if(streamSnapshot.connectionState == ConnectionState.waiting){
                 return const Center(child: CircularProgressIndicator(),);
               } else if(streamSnapshot.hasError){
                 return const Center(child: Text("Something went wrong"),);
               } else if(streamSnapshot.hasData==false || streamSnapshot.data!.docs.isEmpty){
                 return const Center(child: Text("No any student listed"),);
               } else {
                 return ListView.builder(
                   itemCount: streamSnapshot.data!.docs.length,
                   itemBuilder: (itemBuilder, index){
                     DocumentSnapshot data=streamSnapshot.data!.docs[index];
                     if(data['ctName']==snapshot.data.toString()) {
                       return Padding(
                         padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                         child: Container(
                           decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(5)),
                           child: ListTile(
                             title: Text("${data['name']}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                             subtitle: Text("En No. ${data['enroll']}",style: const TextStyle(fontWeight: FontWeight.w500)),
                             leading: Container(
                               height: 55,width: 55,
                               decoration: BoxDecoration(image: DecorationImage(
                                   image: data['photoURL']==null?const AssetImage("assets/images/studentpfp.png")
                                   :NetworkImage(data['photoURL']),fit: BoxFit.contain),
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
                     } else {
                       return null;
                     }
                   },
                 );
               }
             },
           );
         }
       },
     )
   );
  }
}