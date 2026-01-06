import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getpass/Principle/hodInformation.dart';
import 'AddHOD.dart';

class allHODs extends StatelessWidget {
  CollectionReference ref=FirebaseFirestore.instance.collection('HODs');
  allHODs({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Container(
          height: 70,width: 70,
          decoration: BoxDecoration(color:  const Color(0xff3F72AF),borderRadius: BorderRadius.circular(25)),
          child: IconButton(
            icon:  const Icon(Icons.add_rounded,color: Colors.white,size: 40,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (builder){
                return const AddHOD();
              }));
            },
          ),
        ),
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
          if(streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else if(streamSnapshot.hasError){
            return const Center(child: Text("Something went wrong"),);
          } else {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (itemBuilder, index){
                DocumentSnapshot data=streamSnapshot.data!.docs[index];
                return Padding(
                  padding:  const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.1),borderRadius: BorderRadius.circular(5)),
                    child: ListTile(
                      title: Text("Prof. ${data['name']}",style:  const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                      subtitle: Text("Dept.: ${data['dept']}",style:  const TextStyle(fontWeight: FontWeight.w500)),
                      leading: Container(
                        height: 55,width: 55,
                        decoration: BoxDecoration(image: DecorationImage(image:data['photoURL']==null? const AssetImage("assets/images/teacherpfp.png") :NetworkImage(data['photoURL']),fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(60)),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right_rounded,color: Color(0xff3F72AF),),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (builder){
                          return hodInformation(document: data.id);
                        }));
                      },
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