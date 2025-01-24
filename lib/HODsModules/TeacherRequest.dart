import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../SendLeaveNotificastion.dart';

class TeacherRequest extends StatelessWidget {
  Widget build(BuildContext context) {

    FirebaseAuth _auth=FirebaseAuth.instance;
    CollectionReference ref1=FirebaseFirestore.instance.collection('Campus Leaves');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Requests"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: StreamBuilder(
          stream: ref1.orderBy('appliedAt', descending: true).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
            if(streamSnapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            } else if(streamSnapshot.hasError){
              return const Center(child: Text("Something went wrong"),);
            } else if(streamSnapshot.hasData == false || streamSnapshot.data!.docs.isEmpty){
              return const Center(child: Text("No any request"),);
            } else {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (itemBuilder, index){
                  DocumentSnapshot data=streamSnapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
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
                                  decoration: BoxDecoration(image: DecorationImage(image: data['photoURL']==null?const AssetImage("assets/images/studentpfp.png"):NetworkImage(data['photoURL']),fit: BoxFit.contain),
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text("${data['name']}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 19),),
                                    ),
                                    subtitle: Text("Class: ${data['class']}",style: TextStyle(color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w500,fontSize: 17),),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 17,),
                            Container(
                              height: 40,width: 220,
                              decoration: BoxDecoration(color: const Color(0xffC4D9FF),borderRadius: BorderRadius.circular(30)),
                              child: Center(child: Text("${data['dept']}",style: const TextStyle(color: Color(0xff344CB7),fontSize: 17,fontWeight: FontWeight.w500),)),
                            ),
                            const SizedBox(height: 17,),
                            Container(
                              height: 1,width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today_rounded,color: Color(0xff006BFF),size: 20,),
                                    const SizedBox(width: 10,),
                                    Text("${data['date']}",style: const TextStyle(color: Colors.black,fontSize: 17),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_filled_rounded,color: Color(0xff006BFF),size: 20,),
                                    const SizedBox(width: 10,),
                                    Text("${data['time']}",style: const TextStyle(color: Colors.black,fontSize: 17),),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 15,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.info_rounded,color: Color(0xff006BFF),size: 21,),
                                const SizedBox(width: 10,),
                                Expanded(child: Text("${data['reason']}",
                                  style: const TextStyle(color: Colors.black,fontSize: 17),))
                              ],
                            ),
                            const SizedBox(height: 15,),
                            Row(
                              children: [
                                Icon(Icons.access_time_rounded,size: 20,color: Colors.black.withOpacity(0.6),),
                                const SizedBox(width: 10,),
                                Text("Applied on: ${data['appliedAt']}",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15,fontWeight: FontWeight.w500),)
                              ],
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              height: 1,width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                            ),
                            const SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(color: data['hodApproval']=="Pending"?const Color(0xff1DB954)
                                        :data['hodApproval']=="Approved"?const Color(0xff1DB954).withOpacity(0.5)
                                        :const Color(0xff1DB954),borderRadius: BorderRadius.circular(10)),
                                    child: TextButton(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.check_rounded,size: 20,color: Colors.white,),
                                          const SizedBox(width: 5,),
                                          Container(
                                              child: data['hodApproval']=="Pending"?const Text("Approve",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500))
                                                  :data['hodApproval']=="Approved"?const Text("Approved",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500))
                                                  :const Text("Approve Me",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500)))
                                        ],),
                                      onPressed: () async {
                                        CollectionReference ref=FirebaseFirestore.instance.collection('Campus Leaves');
                                        await ref.doc(data.id).update({
                                          'hodApproval':"Approved",
                                        }).then((onValue) async {
                                          String? studToken = (await FirebaseFirestore.instance.collection('Students').doc(data['userID']).get()).data()?['fcmToken'];
                                          await sendNotification(
                                            title: "Leave Request Approved",
                                            body: "HOD sir approved your leave request. Tap to see more.",
                                            fcmToken: studToken.toString(),
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(color: data['hodApproval']=="Pending"?const Color(0xffDC3545)
                                        :data['hodApproval']=="Rejected"?const Color(0xffDC3545).withOpacity(0.5)
                                        :const Color(0xffDC3545),borderRadius: BorderRadius.circular(10)),
                                    child: TextButton(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.close_rounded,size: 20,color: Colors.white),
                                          const SizedBox(width: 5,),
                                          Container(
                                              child: data['hodApproval']=="Pending"?const Text("Reject",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),)
                                                  :data['hodApproval']=="Rejected"?const Text("Rejected",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),)
                                                  :const Text("Cancel",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),))
                                        ],),
                                      onPressed: () async {
                                        CollectionReference ref2=FirebaseFirestore.instance.collection('Campus Leaves');
                                        await ref2.doc(data.id).update({
                                          'hodApproval':"Rejected",
                                        }).then((onValue) async {
                                          String? studToken = (await FirebaseFirestore.instance.collection('Students').doc(data['userID']).get()).data()?['fcmToken'];
                                          await sendNotification(
                                            title: "Leave Request Rejected",
                                            body: "HOD sir rejected your leave request. Tap to see more.",
                                            fcmToken: studToken.toString(),
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