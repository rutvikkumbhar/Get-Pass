import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class hodStudRejectedRequest extends StatelessWidget {
  final FirebaseAuth _auth=FirebaseAuth.instance;

  Future<String> deptsName() async {
    DocumentSnapshot docData=await FirebaseFirestore.instance.collection('HODs').doc(_auth.currentUser!.uid).get();
    return docData['dept'].toString();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rejected Student"),
      ),
      body: Padding(
        padding:  EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: FutureBuilder(
          future: deptsName(),
          builder: (context, snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return  Center(child: CircularProgressIndicator(),);
            } else if(snapshot.hasError){
              return  Center(child: Text("Something went wrong"),);
            } else if(snapshot.hasData==false || snapshot.data!.isEmpty){
              return  Center(child: Text("No any request."),);
            }else {
              String nameOfDept=snapshot.data.toString();
              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Leaves_$nameOfDept').orderBy('appliedAt', descending: true).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                  if(streamSnapshot.connectionState == ConnectionState.waiting){
                    return  Center(child: CircularProgressIndicator(),);
                  } else if(streamSnapshot.hasError){
                    return  Center(child: Text("Something went wrong"),);
                  } else  if(streamSnapshot.hasData==false || streamSnapshot.data!.docs.isEmpty){
                    return  Center(child: Text("No any request."),);
                  } else {
                    return ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (itemBuilder, index){
                          DocumentSnapshot data=streamSnapshot.data!.docs[index];
                          return data['hodApproval']=="Rejected"? Padding(
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
                                            subtitle: Text("En No. ${data['enroll']}",style: TextStyle(color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w500,fontSize: 17),),
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
                                        Container(
                                          decoration: BoxDecoration(color: Color(0xffDC3545),borderRadius: BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                            child: Text("Rejected",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500)),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ):SizedBox();
                        }
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