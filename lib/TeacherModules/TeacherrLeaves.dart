import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Success.dart';
import 'RequestLeave.dart';

class TeacherLeaves extends StatelessWidget {

  final FirebaseAuth _auth=FirebaseAuth.instance;
  CollectionReference ref=FirebaseFirestore.instance.collection('Campus Leaves');

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Leaves"),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: Container(
        height: 70,width: 70,
        decoration: BoxDecoration(color:  Color(0xff3F72AF),borderRadius: BorderRadius.circular(25)),
        child: IconButton(
          icon:  Icon(Icons.add_rounded,color: Colors.white,size: 40,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (builder){
              return RequestLeave();
            }));
          },
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: StreamBuilder(
          stream: ref.where('userID', isEqualTo: _auth.currentUser!.uid).orderBy('appliedAt', descending: true).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
            if(streamSnapshot.connectionState== ConnectionState.waiting){
              return  Center(child: CircularProgressIndicator(),);
            } else if(streamSnapshot.hasError){
              return  Center(child: Text("Something went wrong"),);
            } else if(streamSnapshot.hasData==false || streamSnapshot.data!.docs.isEmpty){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 200,width: MediaQuery.of(context).size.width>350?350:MediaQuery.of(context).size.width,
                    decoration:  BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/cart.png"),fit: BoxFit.fill)),
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
                    padding:  EdgeInsets.only(top: 7,bottom: 7),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding:  EdgeInsets.all(5),
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
                                      padding:  EdgeInsets.only(top: 3),
                                      child: Row(children: [
                                         Icon(Icons.calendar_today_rounded,color: Color(0xff006BFF),size: 18,),
                                        Text(" ${data['date']} | ${data['time']}",style:  TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.w400),),
                                      ],),
                                    ),
                                  ),
                                ),
                                data['hodApproval']=="Pending"?
                                IconButton(
                                  icon: Icon(Icons.delete_rounded,color: Color(0xffD91656),),
                                  onPressed: (){
                                    showDialog(
                                        context: context,
                                        builder: (context)=>AlertDialog(
                                          title: Text("Confirm Deletion"),
                                          content: Text("Are you sure you want to delete this pass? This action cannot be undone."),
                                          actions: [
                                            ElevatedButton(
                                              child: Text("Delete"),
                                              onPressed: () async {
                                                CollectionReference deleteLeave=FirebaseFirestore.instance.collection('Campus Leaves');
                                                deleteLeave.doc(data.id).delete();
                                                Success().toastMessage("Leave request deleted successfully!");
                                                Navigator.pop(context);
                                                CollectionReference updateLimit=FirebaseFirestore.instance.collection('Teachers');
                                                DocumentSnapshot count=await updateLimit.doc(_auth.currentUser!.uid).get();
                                                updateLimit.doc(_auth.currentUser!.uid).update({
                                                  'totalLeave':(int.parse(count['totalLeave'].toString())-1).toString(),
                                                });
                                              },
                                            ),
                                            ElevatedButton(
                                              child: Text("Cancel"),
                                              onPressed: (){
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        )
                                    );
                                  },
                                ):SizedBox(),
                              ],
                            ),
                             SizedBox(height: 15,),
                            Padding(
                              padding:  EdgeInsets.only(left: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Principle",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 17,fontWeight: FontWeight.w600),),
                                  Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: data['prinApproval']=="Approved"? Icon(Icons.check_circle_rounded,color: Color(0xff16C47F),size: 20,)
                                                :data['prinApproval']=="Rejected"? Icon(Icons.cancel_rounded,color: Color(0xffD91656),size: 20,)
                                                : Icon(Icons.access_time_filled_rounded,color: Color(0xffF39E60),size: 20,),
                                          ),
                                           SizedBox(width: 5,),
                                          Container(
                                            child: data['prinApproval']=="Approved"? Text("Approved",style: TextStyle(color: Color(0xff16C47F),fontSize: 17,fontWeight: FontWeight.w500),)
                                                :data['prinApproval']=="Rejected"? Text("Rejected",style: TextStyle(color: Color(0xffD91656),fontSize: 17,fontWeight: FontWeight.w500),)
                                                : Text("Pending",style: TextStyle(color: Color(0xffF39E60),fontSize: 17,fontWeight: FontWeight.w500),),),
                                           SizedBox(width: 10,)
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: 15,),
                            Padding(
                              padding:  EdgeInsets.only(left: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("HOD",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 17,fontWeight: FontWeight.w600),),
                                  Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: data['hodApproval']=="Approved"? Icon(Icons.check_circle_rounded,color: Color(0xff16C47F),size: 20,)
                                                :data['hodApproval']=="Rejected"? Icon(Icons.cancel_rounded,color: Color(0xffD91656),size: 20,)
                                                : Icon(Icons.access_time_filled_rounded,color: Color(0xffF39E60),size: 20,),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                            child: data['hodApproval']=="Approved"? Text("Approved",style: TextStyle(color: Color(0xff16C47F),fontSize: 17,fontWeight: FontWeight.w500),)
                                                :data['hodApproval']=="Rejected"? Text("Rejected",style: TextStyle(color: Color(0xffD91656),fontSize: 17,fontWeight: FontWeight.w500),)
                                                : Text("Pending",style: TextStyle(color: Color(0xffF39E60),fontSize: 17,fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 10,)
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: 15,),
                            Padding(
                              padding:  EdgeInsets.only(left: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Final Status",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 17,fontWeight: FontWeight.w600),),
                                  Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: data['finalStatus']=="Approved"? Icon(Icons.check_circle_rounded,color: Color(0xff16C47F),size: 20,)
                                                :data['finalStatus']=="Rejected"? Icon(Icons.cancel_rounded,color: Color(0xffD91656),size: 20,)
                                                : Icon(Icons.access_time_filled_rounded,color: Color(0xffF39E60),size: 20,),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                            child: data['finalStatus']=="Approved"? Text("Approved",style: TextStyle(color: Color(0xff16C47F),fontSize: 17,fontWeight: FontWeight.w500),)
                                                :data['finalStatus']=="Rejected"? Text("Rejected",style: TextStyle(color: Color(0xffD91656),fontSize: 17,fontWeight: FontWeight.w500),)
                                                : Text("Pending",style: TextStyle(color: Color(0xffF39E60),fontSize: 17,fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 10,)
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: 15,),
                            Padding(
                              padding:  EdgeInsets.fromLTRB(15, 17, 10, 15),
                              child: Container(
                                height: 1,width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(left: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.format_quote_rounded,color: Colors.black.withOpacity(0.5),size: 26,),
                                   SizedBox(width: 5,),
                                  Expanded(
                                      child: Text(data['reason'].length>40?data['reason'].substring(0,40)+"...":data['reason'],style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 18,fontWeight: FontWeight.w500))),
                                ],
                              ),
                            ),
                             SizedBox(height: 12,),
                            Padding(
                              padding:  EdgeInsets.only(left: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.access_time_rounded,color: Colors.black.withOpacity(0.5),size: 20,),
                                   SizedBox(width: 5,),
                                  Text("Submitted on ${data['appliedAt']}",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 16,fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                             SizedBox(height: 5,),
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