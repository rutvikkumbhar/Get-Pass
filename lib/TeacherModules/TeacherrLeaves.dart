import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'RequestLeave.dart';

class TeacherLeaves extends StatelessWidget {

  final FirebaseAuth _auth=FirebaseAuth.instance;
  CollectionReference ref=FirebaseFirestore.instance.collection('Campus Leaves');

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 70,width: 70,
        decoration: BoxDecoration(color: const Color(0xff3F72AF),borderRadius: BorderRadius.circular(25)),
        child: IconButton(
          icon: const Icon(Icons.add_rounded,color: Colors.white,size: 40,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (builder){
              return RequestLeave();
            }));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: StreamBuilder(
          stream: ref.where('userID', isEqualTo: _auth.currentUser!.uid).orderBy('appliedAt', descending: true).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
            if(streamSnapshot.connectionState== ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            } else if(streamSnapshot.hasError){
              return const Center(child: Text("Something went wrong"),);
            } else if(streamSnapshot.hasData==false || streamSnapshot.data!.docs.isEmpty){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 200,width: MediaQuery.of(context).size.width>350?350:MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/cart.png"),fit: BoxFit.fill)),
                  ),
                  Text("No any request, all looks good",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black87.withOpacity(0.4)),),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (itemBuilder, index){
                  DocumentSnapshot data=streamSnapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 7,bottom: 7),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: Text("Leave Date & Time",style: TextStyle(fontSize: 17,color: Colors.black.withOpacity(0.5),fontWeight: FontWeight.w600),),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Row(children: [
                                        const Icon(Icons.calendar_today_rounded,color: Color(0xff006BFF),size: 18,),
                                        Text(" ${data['date']} | ${data['time']}",style: const TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.w400),),
                                      ],),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("HOD",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 17,fontWeight: FontWeight.w600),),
                                  Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: data['hodApproval']=="Approved"?const Icon(Icons.check_circle_rounded,color: Color(0xff16C47F),size: 20,)
                                                :data['hodApproval']=="Rejected"?const Icon(Icons.cancel_rounded,color: Color(0xffD91656),size: 20,)
                                                :const Icon(Icons.access_time_filled_rounded,color: Color(0xffF39E60),size: 20,),
                                          ),
                                          const SizedBox(width: 5,),
                                          Container(
                                            child: data['hodApproval']=="Approved"?const Text("Approved",style: TextStyle(color: Color(0xff16C47F),fontSize: 17,fontWeight: FontWeight.w500),)
                                                :data['hodApproval']=="Rejected"?const Text("Rejected",style: TextStyle(color: Color(0xffD91656),fontSize: 17,fontWeight: FontWeight.w500),)
                                                :const Text("Pending",style: TextStyle(color: Color(0xffF39E60),fontSize: 17,fontWeight: FontWeight.w500),),),
                                          const SizedBox(width: 10,)
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 17, 10, 15),
                              child: Container(
                                height: 1,width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.format_quote_rounded,color: Colors.black.withOpacity(0.5),size: 26,),
                                  const SizedBox(width: 5,),
                                  Expanded(
                                      child: Text(data['reason'].length>40?data['reason'].substring(0,40)+"...":data['reason'],style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 18,fontWeight: FontWeight.w500))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12,),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.access_time_rounded,color: Colors.black.withOpacity(0.5),size: 20,),
                                  const SizedBox(width: 5,),
                                  Text("Submitted on ${data['appliedAt']}",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 16,fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5,),
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