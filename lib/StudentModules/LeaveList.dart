import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Success.dart';

class LeaveList extends StatelessWidget {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  LeaveList({super.key});

  Future<String> studDept() async {
    DocumentSnapshot studDoc=await FirebaseFirestore.instance.collection('Students').doc(_auth.currentUser!.uid).get();
    return studDoc['dept'].toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      body: Padding(
        padding:  const EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: FutureBuilder(
          future: studDept(),
          builder: (context, snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return  const Center(child: CircularProgressIndicator(),);
            } else if(snapshot.hasError){
              return  const Center(child: Text("Something went wrong"),);
            } else {
              String department=snapshot.data.toString();
              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Leaves_$department')
                    .where('userID', isEqualTo: _auth.currentUser!.uid)
                    .orderBy("appliedAt", descending: true).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                  if(streamSnapshot.connectionState == ConnectionState.waiting){
                    return  const Center(child: CircularProgressIndicator(),);
                  } else if(streamSnapshot.hasError){
                    return  const Center(child: Text("Something went wrong"),);
                  } if(streamSnapshot.hasData==false || streamSnapshot.data!.docs.isEmpty){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,width: MediaQuery.of(context).size.width>350?350:MediaQuery.of(context).size.width,
                          decoration:  const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/cart.png"),fit: BoxFit.fill)),
                        ),
                        Text("No any request, all looks good",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black87.withValues(alpha: 0.4)),),
                      ],
                    );
                  }  else {
                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (itemBuilder, index){
                        DocumentSnapshot data=streamSnapshot.data!.docs[index];
                        return Padding(
                          padding:  const EdgeInsets.only(top: 7,bottom: 7),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding:  const EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text("Leave Date & Time",style: TextStyle(fontSize: 17,color: Colors.black.withValues(alpha: 0.5),fontWeight: FontWeight.w600),),
                                          subtitle: Padding(
                                            padding:  const EdgeInsets.only(top: 3),
                                            child: Row(children: [
                                               const Icon(Icons.calendar_today_rounded,color: Color(0xff006BFF),size: 18,),
                                              Text(" ${data['date']} | ${data['time']}",style:  const TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.w400),),
                                            ],),
                                          ),
                                        ),
                                      ),
                                      data['finalStatus']=="Pending"?
                                      IconButton(
                                        icon: const Icon(Icons.delete_rounded,color: Color(0xffD91656),),
                                        onPressed: (){
                                          showDialog(
                                              context: context,
                                              builder: (context)=>AlertDialog(
                                                title: const Text("Confirm Deletion"),
                                                content: const Text("Are you sure you want to delete this pass? This action cannot be undone, and your monthly leave count will be reset accordingly."),
                                                actions: [
                                                  ElevatedButton(
                                                    child: const Text("Delete"),
                                                    onPressed: () async {
                                                      CollectionReference deleteLeave=FirebaseFirestore.instance.collection('Leaves_$department');
                                                      deleteLeave.doc(data.id).delete();
                                                      Success().toastMessage("Leave request deleted successfully! Monthly limit restored.");
                                                      Navigator.pop(context);
                                                      CollectionReference updateLimit=FirebaseFirestore.instance.collection('Students');
                                                      DocumentSnapshot count=await updateLimit.doc(_auth.currentUser!.uid).get();
                                                      updateLimit.doc(_auth.currentUser!.uid).update({
                                                        'totalLeave':(int.parse(count['totalLeave'].toString())-1).toString(),
                                                      });
                                                    },
                                                  ),
                                                  ElevatedButton(
                                                    child: const Text("Cancel"),
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              )
                                          );
                                        },
                                      ):const SizedBox(),
                                    ],
                                  ),
                                   const SizedBox(height: 10,),
                                  Padding(
                                    padding:  const EdgeInsets.only(left: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Class Teacher",style: TextStyle(color: Colors.black.withValues(alpha: 0.6),fontSize: 17,fontWeight: FontWeight.w600),),
                                        Row(
                                          children: [
                                            Container(
                                              child: data['classTeacherApproval']=="Approved"? const Icon(Icons.check_circle_rounded,color: Color(0xff16C47F),size: 20,)
                                                  :data['classTeacherApproval']=="Rejected"? const Icon(Icons.cancel_rounded,color: Color(0xffD91656),size: 20,)
                                                  : const Icon(Icons.access_time_filled_rounded,color: Color(0xffF39E60),size: 20,),
                                            ),
                                             const SizedBox(width: 5,),
                                            Container(
                                              child: data['classTeacherApproval']=="Approved"? const Text("Approved",style: TextStyle(color: Color(0xff16C47F),fontSize: 17,fontWeight: FontWeight.w500),)
                                                  :data['classTeacherApproval']=="Rejected"? const Text("Rejected",style: TextStyle(color: Color(0xffD91656),fontSize: 17,fontWeight: FontWeight.w500),)
                                                  : const Text("Pending",style: TextStyle(color: Color(0xffF39E60),fontSize: 17,fontWeight: FontWeight.w500),),),
                                             const SizedBox(width: 10,)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                   const SizedBox(height: 15,),
                                  Padding(
                                    padding:  const EdgeInsets.only(left: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("HOD",style: TextStyle(color: Colors.black.withValues(alpha: 0.6),fontSize: 17,fontWeight: FontWeight.w600),),
                                        Row(
                                          children: [
                                            Container(
                                              child: data['hodApproval']=="Approved"? const Icon(Icons.check_circle_rounded,color: Color(0xff16C47F),size: 20,)
                                                  :data['hodApproval']=="Rejected"? const Icon(Icons.cancel_rounded,color: Color(0xffD91656),size: 20,)
                                                  : const Icon(Icons.access_time_filled_rounded,color: Color(0xffF39E60),size: 20,),
                                            ),
                                             const SizedBox(width: 5,),
                                            Container(
                                              child: data['hodApproval']=="Approved"? const Text("Approved",style: TextStyle(color: Color(0xff16C47F),fontSize: 17,fontWeight: FontWeight.w500),)
                                                  :data['hodApproval']=="Rejected"? const Text("Rejected",style: TextStyle(color: Color(0xffD91656),fontSize: 17,fontWeight: FontWeight.w500),)
                                                  : const Text("Pending",style: TextStyle(color: Color(0xffF39E60),fontSize: 17,fontWeight: FontWeight.w500),),),
                                             const SizedBox(width: 10,)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                   const SizedBox(height: 15,),
                                  Padding(
                                    padding:  const EdgeInsets.only(left: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Final Status",style: TextStyle(color: Colors.black.withValues(alpha: 0.6),fontSize: 17,fontWeight: FontWeight.w600),),
                                        Row(
                                          children: [
                                            Container(
                                              child: data['finalStatus']=="Approved"? const Icon(Icons.check_circle_rounded,color: Color(0xff16C47F),size: 20,)
                                                  :data['finalStatus']=="Rejected"? const Icon(Icons.cancel_rounded,color: Color(0xffD91656),size: 20,)
                                                  : const Icon(Icons.access_time_filled_rounded,color: Color(0xffF39E60),size: 20,),),
                                             const SizedBox(width: 5,),
                                            Container(
                                              child: data['finalStatus']=="Approved"? const Text("Approved",style: TextStyle(color: Color(0xff16C47F),fontSize: 17,fontWeight: FontWeight.w500),)
                                                  :data['finalStatus']=="Rejected"? const Text("Rejected",style: TextStyle(color: Color(0xffD91656),fontSize: 17,fontWeight: FontWeight.w500),)
                                                  : const Text("Pending",style: TextStyle(color: Color(0xffF39E60),fontSize: 17,fontWeight: FontWeight.w500),),),
                                             const SizedBox(width: 10,)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:  const EdgeInsets.fromLTRB(15, 17, 10, 15),
                                    child: Container(
                                      height: 1,width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.1)),
                                    ),
                                  ),
                                  Padding(
                                    padding:  const EdgeInsets.only(left: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.format_quote_rounded,color: Colors.black.withValues(alpha: 0.5),size: 26,),
                                         const SizedBox(width: 5,),
                                        Expanded(
                                            child: Text(data['reason'].length>40?data['reason'].substring(0,40)+"...":data['reason'],style: TextStyle(color: Colors.black.withValues(alpha: 0.6),fontSize: 18,fontWeight: FontWeight.w500))),
                                      ],
                                    ),
                                  ),
                                   const SizedBox(height: 12,),
                                  Padding(
                                    padding:  const EdgeInsets.only(left: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.access_time_rounded,color: Colors.black.withValues(alpha: 0.5),size: 20,),
                                         const SizedBox(width: 5,),
                                        Text("Submitted on ${data['appliedAt']}",style: TextStyle(color: Colors.black.withValues(alpha: 0.6),fontSize: 16,fontWeight: FontWeight.w400)),
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
              );
            }
          },
        ),
      )
    );
  }
}