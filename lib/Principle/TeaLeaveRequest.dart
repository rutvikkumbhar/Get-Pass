import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../SendLeaveNotificastion.dart';

class TeaLeaveRequest extends StatefulWidget {

  @override
  State<TeaLeaveRequest> createState() => _TeaLeaveRequestState();
}

class _TeaLeaveRequestState extends State<TeaLeaveRequest> {
  CollectionReference ref1=FirebaseFirestore.instance.collection('Campus Leaves');

  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Staff Leaves"),
     ),
     body:Padding(
       padding:  EdgeInsets.only(left: 15,right: 15),
       child: StreamBuilder(
         stream: ref1.orderBy('appliedAt', descending: true).snapshots(),
         builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
           if(streamSnapshot.connectionState == ConnectionState.waiting){
             return  Center(child: CircularProgressIndicator(),);
           } else if(streamSnapshot.hasError){
             return  Center(child: Text("Something went wrong"),);
           } else if(streamSnapshot.hasData == false || streamSnapshot.data!.docs.isEmpty){
             return  Center(child: Text("No any request"),);
           } else {
             return ListView.builder(
               itemCount: streamSnapshot.data!.docs.length,
               itemBuilder: (itemBuilder, index){
                 DocumentSnapshot data=streamSnapshot.data!.docs[index];
                 return Padding(
                   padding:  EdgeInsets.only(top: 10,bottom: 10),
                   child: Container(
                     decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                     child: Padding(
                       padding:  EdgeInsets.all(15),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Container(
                                 height: 75,width: 75,
                                 decoration: BoxDecoration(image: DecorationImage(image: data['photoURL']==null? AssetImage("assets/images/studentpfp.png"):NetworkImage(data['photoURL']),fit: BoxFit.contain),
                                     borderRadius: BorderRadius.circular(50)),
                               ),
                               Expanded(
                                 child: ListTile(
                                   title: Padding(
                                     padding:  EdgeInsets.only(bottom: 5),
                                     child: Text("${data['name']}",style:  TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 19),),
                                   ),
                                   subtitle: Text("Class: ${data['class']}",style: TextStyle(color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w500,fontSize: 17),),
                                 ),
                               )
                             ],
                           ),
                           SizedBox(height: 17,),
                           Container(
                             height: 40,width: 220,
                             decoration: BoxDecoration(color:  Color(0xffC4D9FF),borderRadius: BorderRadius.circular(30)),
                             child: Center(child: Text("${data['dept']}",style:  TextStyle(color: Color(0xff344CB7),fontSize: 17,fontWeight: FontWeight.w500),)),
                           ),
                           SizedBox(height: 17,),
                           Container(
                             height: 1,width: MediaQuery.of(context).size.width,
                             decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                           ),
                           SizedBox(height: 20,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Row(
                                 children: [
                                   Icon(Icons.calendar_today_rounded,color: Color(0xff006BFF),size: 20,),
                                   SizedBox(width: 10,),
                                   Text("${data['date']}",style:  TextStyle(color: Colors.black,fontSize: 17),),
                                 ],
                               ),
                               Row(
                                 children: [
                                   Icon(Icons.access_time_filled_rounded,color: Color(0xff006BFF),size: 20,),
                                   SizedBox(width: 10,),
                                   Text("${data['time']}",style:  TextStyle(color: Colors.black,fontSize: 17),),
                                 ],
                               )
                             ],
                           ),
                           SizedBox(height: 15,),
                           Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Icon(Icons.info_rounded,color: Color(0xff006BFF),size: 21,),
                               SizedBox(width: 10,),
                               Expanded(child: Text("${data['reason']}",
                                 style:  TextStyle(color: Colors.black,fontSize: 17),))
                             ],
                           ),
                           SizedBox(height: 15,),
                           Row(
                             children: [
                               Icon(Icons.access_time_rounded,size: 20,color: Colors.black.withOpacity(0.6),),
                               SizedBox(width: 10,),
                               Text("Applied on: ${data['appliedAt']}",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15,fontWeight: FontWeight.w500),)
                             ],
                           ),
                           SizedBox(height: 20,),
                           Container(
                             height: 1,width: MediaQuery.of(context).size.width,
                             decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                           ),
                           SizedBox(height: 15,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Expanded(
                                 child: Container(
                                   height: 45,
                                   decoration: BoxDecoration(color: data['prinApproval']=="Pending"? Color(0xff1DB954)
                                       :data['prinApproval']=="Approved"? Color(0xff1DB954).withOpacity(0.5)
                                       : Color(0xff1DB954),borderRadius: BorderRadius.circular(10)),
                                   child: TextButton(
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Icon(Icons.check_rounded,size: 20,color: Colors.white,),
                                         SizedBox(width: 5,),
                                         Container(
                                             child: data['prinApproval']=="Pending"? Text("Approve",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500))
                                                 :data['prinApproval']=="Approved"? Text("Approved",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500))
                                                 : Text("Approve",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500)))
                                       ],),
                                     onPressed: () async {
                                       CollectionReference ref=FirebaseFirestore.instance.collection('Campus Leaves');
                                       await ref.doc(data.id).update({
                                         'prinApproval':"Approved",
                                         'finalStatus':"Approved"
                                       }).then((onValue) async {
                                         print("Updated to approve");
                                         String? teaToken = (await FirebaseFirestore.instance.collection('Teachers').doc(data['userID']).get()).data()?['fcmToken'];
                                         await sendNotification(
                                           title: "Leave Request Approved",
                                           body: "Principle sir approved your leave request. Tap to see more.",
                                           fcmToken: teaToken.toString(),
                                         );
                                       });
                                     },
                                   ),
                                 ),
                               ),
                               SizedBox(width: 10,),
                               Expanded(
                                 child: Container(
                                   height: 45,
                                   decoration: BoxDecoration(color: data['prinApproval']=="Pending"? Color(0xffDC3545)
                                       :data['prinApproval']=="Rejected"? Color(0xffDC3545).withOpacity(0.5)
                                       : Color(0xffDC3545),borderRadius: BorderRadius.circular(10)),
                                   child: TextButton(
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Icon(Icons.close_rounded,size: 20,color: Colors.white),
                                         SizedBox(width: 5,),
                                         Container(
                                             child: data['prinApproval']=="Pending"? Text("Reject",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),)
                                                 :data['prinApproval']=="Rejected"? Text("Rejected",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),)
                                                 : Text("Cancel",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),))
                                       ],),
                                     onPressed: () async {
                                       CollectionReference ref2=FirebaseFirestore.instance.collection('Campus Leaves');
                                       await ref2.doc(data.id).update({
                                         'prinApproval':"Rejected",
                                         'finalStatus':"Rejected"
                                       }).then((onValue) async {
                                         print("Updated to reject");
                                         String? teaToken = (await FirebaseFirestore.instance.collection('Teachers').doc(data['userID']).get()).data()?['fcmToken'];
                                         await sendNotification(
                                           title: "Leave Request Rejected",
                                           body: "Principle sir rejected your leave request. Tap to see more.",
                                           fcmToken: teaToken.toString(),
                                         );
                                       });
                                     },
                                   ),
                                 ),
                               )
                             ],
                           )
                         ],
                       ),
                     ),
                   ),
                 );
               },
             );
           }
         },
       ),
     ),
   );
  }
}