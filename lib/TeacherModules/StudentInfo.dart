import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class StudentInformation extends StatefulWidget {
  @override
  State<StudentInformation> createState() => _StudentInformationState();
  String? document;
  StudentInformation({super.key, required this.document});
}

class _StudentInformationState extends State<StudentInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Information"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Students').doc(widget.document).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> streamSnapshot){
          if(streamSnapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          } else if(streamSnapshot.hasError){
            return const Center(child: Text("Something went wrong"),);
          } else {
            Map<String, dynamic> data=streamSnapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 90,width: 90,
                        decoration: BoxDecoration(image: DecorationImage(image:data['photoURL']==null? const AssetImage("assets/images/studentpfp.png")
                            :NetworkImage(data['photoURL']),fit: BoxFit.contain),
                            borderRadius: BorderRadius.circular(60)),
                      ),
                      const SizedBox(width: 20,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${data['name']}",style:  const TextStyle(fontSize: 19,fontWeight: FontWeight.w500),),
                          Text("${data['email']}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.black87.withValues(alpha: 0.7)),),
                          Text("EnNo. ${data['enroll']}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.black87.withValues(alpha: 0.7)),)
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text("Class",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black.withValues(alpha: 0.5)),),
                          subtitle: Text("${data['class']}",style:  const TextStyle(color: Color(0xFF074799),fontWeight: FontWeight.w600),),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text("Department",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black.withValues(alpha: 0.5))),
                          subtitle: Text("${data['dept']}",style:  const TextStyle(color: Color(0xFF074799),fontWeight: FontWeight.w600),),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text("Class coordinator",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black.withValues(alpha: 0.5)),),
                          subtitle: Text("Prof. ${data['ctName']}",style:  const TextStyle(color: Color(0xFF074799),fontWeight: FontWeight.w600),),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text("HOD",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black.withValues(alpha: 0.5))),
                          subtitle: Text("Prof. ${data['hodName']}",style:  const TextStyle(color: Color(0xFF074799),fontWeight: FontWeight.w600),),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text("Contact",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black.withValues(alpha: 0.5)),),
                          subtitle: Text("+91 ${data['contact']}",style:  const TextStyle(color: Color(0xFF074799),fontWeight: FontWeight.w600),),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text("Student ID",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black.withValues(alpha: 0.5))),
                          subtitle: Text("${data['userID']}",style:  const TextStyle(color: Color(0xFF074799),fontWeight: FontWeight.w600),),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 175,
                        child: ListTile(
                          title: Text("Total leaves",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black.withValues(alpha: 0.5)),),
                          subtitle: Text("${data['totalLeave']}",style:  const TextStyle(color: Color(0xFF074799),fontWeight: FontWeight.w600),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      )
    );
  }
}