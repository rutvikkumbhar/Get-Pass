import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class hodStudApprovedRequest extends StatelessWidget {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  hodStudApprovedRequest({super.key});
  Future<String> deptsName() async {
    DocumentSnapshot docData=await FirebaseFirestore.instance.collection('HODs').doc(_auth.currentUser!.uid).get();
    return docData['dept'].toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Approved Student"),
      ),
      body: Padding(
        padding:  const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: FutureBuilder(
          future: deptsName(),
          builder: (context, snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return  const Center(child: CircularProgressIndicator(),);
            } else if(snapshot.hasError){
              return  const Center(child: Text("Something went wrong"),);
            } else if(snapshot.hasData==false || snapshot.data!.isEmpty){
              return  const Center(child: Text("No any request."),);
            }else {
              String nameOfDept=snapshot.data.toString();
              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Leaves_$nameOfDept').orderBy('appliedAt', descending: true).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                  if(streamSnapshot.connectionState == ConnectionState.waiting){
                    return  const Center(child: CircularProgressIndicator(),);
                  } else if(streamSnapshot.hasError){
                    return  const Center(child: Text("Something went wrong"),);
                  } else  if(streamSnapshot.hasData==false || streamSnapshot.data!.docs.isEmpty){
                    return  const Center(child: Text("No any request."),);
                  } else {
                    return ListView.builder(
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (itemBuilder, index){
                          DocumentSnapshot data=streamSnapshot.data!.docs[index];
                          return data['hodApproval']=="Approved"? Padding(
                            padding:  const EdgeInsets.only(top: 10,bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding:  const EdgeInsets.all(15),
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
                                          decoration: BoxDecoration(image: DecorationImage(image: data['photoURL']==null? const AssetImage("assets/images/studentpfp.png"):NetworkImage(data['photoURL']),fit: BoxFit.contain),
                                              borderRadius: BorderRadius.circular(50)),
                                        ),
                                        Expanded(
                                          child: ListTile(
                                            title: Padding(
                                              padding:  const EdgeInsets.only(bottom: 5),
                                              child: Text("${data['name']}",style:  const TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 19),),
                                            ),
                                            subtitle: Text("En No. ${data['enroll']}",style: TextStyle(color: Colors.black.withValues(alpha: 0.6),fontWeight: FontWeight.w500,fontSize: 17),),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 17,),
                                    Container(
                                      height: 40,width: 220,
                                      decoration: BoxDecoration(color:  const Color(0xffC4D9FF),borderRadius: BorderRadius.circular(30)),
                                      child: Center(child: Text("${data['dept']}",style:  const TextStyle(color: Color(0xff344CB7),fontSize: 17,fontWeight: FontWeight.w500),)),
                                    ),
                                    const SizedBox(height: 17,),
                                    Container(
                                      height: 1,width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.1)),
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today_rounded,color: Color(0xff006BFF),size: 20,),
                                            const SizedBox(width: 10,),
                                            Text("${data['date']}",style:  const TextStyle(color: Colors.black,fontSize: 17),),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time_filled_rounded,color: Color(0xff006BFF),size: 20,),
                                            const SizedBox(width: 10,),
                                            Text("${data['time']}",style:  const TextStyle(color: Colors.black,fontSize: 17),),
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
                                          style:  const TextStyle(color: Colors.black,fontSize: 17),))
                                      ],
                                    ),
                                    const SizedBox(height: 15,),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time_rounded,size: 20,color: Colors.black.withValues(alpha: 0.6),),
                                        const SizedBox(width: 10,),
                                        Text("Applied on: ${data['appliedAt']}",style: TextStyle(color: Colors.black.withValues(alpha: 0.6),fontSize: 15,fontWeight: FontWeight.w500),)
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Container(
                                      height: 1,width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.1)),
                                    ),
                                    const SizedBox(height: 15,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(color: const Color(0xff1DB954),borderRadius: BorderRadius.circular(5)),
                                          child: const Padding(
                                            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                            child: Text("Approved",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500)),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ):const SizedBox();
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