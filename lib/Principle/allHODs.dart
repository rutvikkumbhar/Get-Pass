import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'AddHOD.dart';

class allHODs extends StatelessWidget {

  CollectionReference ref=FirebaseFirestore.instance.collection('HODs');
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Container(
          height: 70,width: 70,
          decoration: BoxDecoration(color:  Color(0xff3F72AF),borderRadius: BorderRadius.circular(25)),
          child: IconButton(
            icon:  Icon(Icons.add_rounded,color: Colors.white,size: 40,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (builder){
                return AddHOD();
              }));
            },
          ),
        ),
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
          if(streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          } else if(streamSnapshot.hasError){
            return Center(child: Text("Something went wrong"),);
          } else {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (itemBuilder, index){
                DocumentSnapshot data=streamSnapshot.data!.docs[index];
                return Padding(
                  padding:  EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(5)),
                    child: ListTile(
                      title: Text("Prof. ${data['name']}",style:  TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                      subtitle: Text("Dept.: ${data['dept']}",style:  TextStyle(fontWeight: FontWeight.w500)),
                      leading: Container(
                        height: 55,width: 55,
                        decoration: BoxDecoration(image: DecorationImage(image:data['photoURL']==null? AssetImage("assets/images/teacherpfp.png") :NetworkImage(data['photoURL']),fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(60)),
                      ),
                      trailing: IconButton(
                        icon:  Icon(Icons.edit,color: Color(0xff3F72AF),),
                        onPressed: (){
                          final msg=SnackBar(content: Text("Currently not available"));
                          ScaffoldMessenger.of(context).showSnackBar(msg);
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      )
    );
  }

}