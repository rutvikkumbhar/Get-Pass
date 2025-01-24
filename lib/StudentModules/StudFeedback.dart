import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpass/Errro.dart';
import 'package:getpass/StudentModules/StudBottomNav.dart';
import 'package:getpass/Success.dart';

class StudFeedback extends StatefulWidget {
  @override
  State<StudFeedback> createState() => _StudFeedbackState();
}

class _StudFeedbackState extends State<StudFeedback> {

  bool load=false;
  final _key=GlobalKey<FormState>();
  final titleController=TextEditingController();
  final descriptionController=TextEditingController();
  final FirebaseAuth _auth=FirebaseAuth.instance;

  String currentDateTime(){
    String date=DateTime.now().toString().split(" ")[0];
    TimeOfDay currentTime=TimeOfDay.now();
    String time="${currentTime.hour.toString().split(" ")[0]}:${currentTime.minute.toString().split(" ")[0]} ${currentTime.period.name.toUpperCase()}";
    return "$date $time";
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20,),
        child: Form(
          key: _key,
          child: ListView(
            children: [
              const SizedBox(height: 15,),
              Text("Title",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 17,fontWeight: FontWeight.w500),),
              const SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Title ",border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5)
                )),
                controller: titleController,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Enter valid title";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20,),
              Text("Description",style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 17,fontWeight: FontWeight.w500),),
              const SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.text,
                maxLines: 5,
                decoration: InputDecoration(border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5)
                )),
                controller: descriptionController,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Enter valid description";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20,),
              Text("Your feedback matters! Please share your suggestions or report any issues in your department. Rest assured, your identity will remain anonymous and will not be disclosed to your HOD or CC.",
              style: TextStyle(color: Colors.black87.withOpacity(0.6)),),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 50,right: 50),
                child: Container(
                  height: 55,width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: const Color(0xff4F7A94),borderRadius: BorderRadius.circular(5)),
                  child: TextButton(
                    child:load?const CircularProgressIndicator(color: Colors.white,) :const Text("Send Feedback",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),),
                    onPressed: () async {
                      setState(() {
                        load=true;
                      });
                      if(_key.currentState!.validate()){
                        DocumentSnapshot docData=await FirebaseFirestore.instance.collection('Students').doc(_auth.currentUser!.uid).get();
                        CollectionReference ref=FirebaseFirestore.instance.collection('Feedback_${docData['dept']}');
                        final String unique=DateTime.now().millisecondsSinceEpoch.toString();
                        await ref.doc(unique).set({
                          'title':titleController.text.toString(),
                          'description':descriptionController.text.toString(),
                          'appliedAt':currentDateTime().toString(),
                        }).then((onValue){
                          Success().toastMessage("Feedback Sent Successfully");
                          Navigator.pop(context, MaterialPageRoute(builder: (builder){
                            return StudBottomNav();
                          }));
                        }).onError((stackTrace, error){
                          setState(() {
                            load=false;
                          });
                          Error().toastMessage(error.toString());
                        });
                      } else {
                        setState(() {
                          load=false;
                        });
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}