import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrinHODApprovedLeaves extends StatelessWidget {
  CollectionReference ref1=FirebaseFirestore.instance.collection('HOD Leaves');

  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("HOD Approved Leaves"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: StreamBuilder(
          stream: ref1.orderBy('appliedAt', descending: true).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
            if(streamSnapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            } else if(streamSnapshot.hasError){
              return Center(child: Text("Something went wrong"),);
            } else if(streamSnapshot.hasData==false || streamSnapshot.data!.docs.isEmpty) {
              return Center(child: Text("No any request"),);
            } else {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (itemBuilder, index){
                  DocumentSnapshot data=streamSnapshot.data!.docs[index];
                  return data['principleApproval']=="Approved"?Padding(
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
                                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/studentpfp.png"),fit: BoxFit.fill),
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Padding(
                                      padding:  EdgeInsets.only(bottom: 5),
                                      child: Text("${data['name']}",style:  TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 19),),
                                    ),
                                    subtitle: Text("Dept. ${data['dept']}",style: TextStyle(color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w500,fontSize: 17),),
                                  ),
                                )
                              ],
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
                                Container(
                                  decoration: BoxDecoration(color: Color(0xff1DB954),borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    child: Text("Approved",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500)),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ):SizedBox();
                },
              );
            }
          },
        ),
      )
    );
  }

}