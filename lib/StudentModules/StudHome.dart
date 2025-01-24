import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpass/StudentModules/LeaveRequest.dart';
import 'StudFeedback.dart';

class StudHome extends StatelessWidget {

  final FirebaseAuth _auth=FirebaseAuth.instance;

  Future<String> studDept() async {
    DocumentSnapshot studDoc=await FirebaseFirestore.instance.collection('Students').doc(_auth.currentUser!.uid).get();
    return studDoc['dept'].toString();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListView(
          children: [
            const SizedBox(height: 10,),
            Container(
              height: 100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.grey.withOpacity(0.1)),
              child: ListTile(
                title: const Text("Submit a leave request",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                subtitle: const Text("You can submit a leave request for the gate pass.",style: TextStyle(fontSize: 16,
                fontWeight: FontWeight.w500,color: Color(0xff4F7A94)),),
                trailing: const Icon(Icons.edit_rounded,color: Color(0xff4F7A94),),
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (builder){
                    return LeaveRequest();
                  }));
                },
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              height: 100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.grey.withOpacity(0.1)),
              child: ListTile(
                title: const Text("Give your feedback",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                subtitle: const Text("You can give your feedback about issue an in your department.",style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w500,color: Color(0xff4F7A94)),),
                trailing: const Icon(Icons.feedback_rounded,color: Color(0xff4F7A94),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder){
                    return StudFeedback();
                  }));
                },
              ),
            ),
            const SizedBox(height: 20,),
            Text("Your recent request",style: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w500),),
            const SizedBox(height: 20,),
            Container(
              child: FutureBuilder(
                future: studDept(),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                   } else if(snapshot.hasError){
                    return const Center(child: Text("something went wrong"),);
                  } else {
                    String department=snapshot.data.toString();
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('Leaves_$department')
                          .where('userID',isEqualTo: _auth.currentUser!.uid)
                          .orderBy("appliedAt", descending: true).snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                        if(streamSnapshot.connectionState == ConnectionState.waiting){
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
                          return Container(
                            height: 320,
                            child: ListView.builder(
                              itemCount: 1,
                              itemBuilder: (itemBuilder, index){
                                DocumentSnapshot data=streamSnapshot.data!.docs[index];
                                return Container(
                                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(15)),
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
                                        const SizedBox(height: 10,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Class Teacher",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 17,fontWeight: FontWeight.w600),),
                                              Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: data['classTeacherApproval']=="Approved"?const Icon(Icons.check_circle_rounded,color: Color(0xff16C47F),size: 20,)
                                                            :data['classTeacherApproval']=="Rejected"?const Icon(Icons.cancel_rounded,color: Color(0xffD91656),size: 20,)
                                                            :const Icon(Icons.access_time_filled_rounded,color: Color(0xffF39E60),size: 20,),
                                                      ),
                                                      const SizedBox(width: 5,),
                                                      Container(
                                                        child: data['classTeacherApproval']=="Approved"?const Text("Approved",style: TextStyle(color: Color(0xff16C47F),fontSize: 17,fontWeight: FontWeight.w500),)
                                                            :data['classTeacherApproval']=="Rejected"?const Text("Rejected",style: TextStyle(color: Color(0xffD91656),fontSize: 17,fontWeight: FontWeight.w500),)
                                                            :const Text("Pending",style: TextStyle(color: Color(0xffF39E60),fontSize: 17,fontWeight: FontWeight.w500),),),
                                                      const SizedBox(width: 10,)
                                                    ],
                                                  ))
                                            ],
                                          ),
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
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Final Status",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 17,fontWeight: FontWeight.w600),),
                                              Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: data['finalStatus']=="Approved"?const Icon(Icons.check_circle_rounded,color: Color(0xff16C47F),size: 20,)
                                                            :data['finalStatus']=="Rejected"?const Icon(Icons.cancel_rounded,color: Color(0xffD91656),size: 20,)
                                                            :const Icon(Icons.access_time_filled_rounded,color: Color(0xffF39E60),size: 20,),),
                                                      const SizedBox(width: 5,),
                                                      Container(
                                                        child: data['finalStatus']=="Approved"?const Text("Approved",style: TextStyle(color: Color(0xff16C47F),fontSize: 17,fontWeight: FontWeight.w500),)
                                                            :data['finalStatus']=="Rejected"?const Text("Rejected",style: TextStyle(color: Color(0xffD91656),fontSize: 17,fontWeight: FontWeight.w500),)
                                                            :const Text("Pending",style: TextStyle(color: Color(0xffF39E60),fontSize: 17,fontWeight: FontWeight.w500),),),
                                                      const SizedBox(width: 10,)
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
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
                                );
                              },
                            ),
                          );
                        }
                      },
                    );
                  }
                },

              ),
            )
          ],
        ),
      )
    );
  }

}