import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewFeedback extends StatelessWidget {

  final FirebaseAuth _auth=FirebaseAuth.instance;

  Future<String> dept() async {
    DocumentSnapshot docData=await FirebaseFirestore.instance.collection('HODs').doc(_auth.currentUser!.uid).get();
    return docData['dept'].toString();
  }
  Widget build(BuildContext context) {
   return Scaffold(
     body: Padding(
       padding: const EdgeInsets.only(left: 15,right: 15),
       child: FutureBuilder(
         future: dept(),
         builder: (context, snapshot){
           if(snapshot.connectionState == ConnectionState.waiting){
             return const Center(child: CircularProgressIndicator(),);
           } else if(snapshot.hasError){
             return const Center(child: Text("Something went wrong"),);
           } else {
             String dept=snapshot.data.toString();
             return StreamBuilder(
               stream: FirebaseFirestore.instance.collection('Feedback_$dept').orderBy('appliedAt', descending: true).snapshots(),
               builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                 if(streamSnapshot.connectionState == ConnectionState.waiting){
                   return const Center(child: CircularProgressIndicator(),);
                 } else if(streamSnapshot.hasError){
                   return const Center(child: Text("Something went wrong"),);
                 } else if(streamSnapshot.hasData ==false || streamSnapshot.data!.docs.isEmpty) {
                   return const Center(child: Text("No any feedback listed"),);
                 } else {
                   return ListView.builder(
                     itemCount: streamSnapshot.data!.docs.length,
                     itemBuilder: (itemBuilder, index){
                       DocumentSnapshot data=streamSnapshot.data!.docs[index];
                       return Padding(
                         padding: const EdgeInsets.only(top: 10),
                         child: Container(
                           decoration: BoxDecoration(color: const Color(0xffDDE6ED),borderRadius: BorderRadius.circular(5)),
                             child: Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text("${data['title']}",style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 17,fontWeight: FontWeight.w500),),
                                   const SizedBox(height: 7,),
                                   Container(
                                     height: 1,width: MediaQuery.of(context).size.width,
                                     color: Colors.black.withOpacity(0.1),
                                   ),
                                   const SizedBox(height: 7,),
                                   Text(":- ${data['description']}",
                                     style: TextStyle(color: Colors.black87.withOpacity(0.6),fontSize: 16,fontWeight: FontWeight.w400),),
                                   const SizedBox(height: 10,),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.end ,
                                     children: [
                                       Text("${data['appliedAt']}",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15,fontWeight: FontWeight.w500),),
                                     ],
                                   ),
                                 ],
                               ),
                             )
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
     ),
   );
  }

}