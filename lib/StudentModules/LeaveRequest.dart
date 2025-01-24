import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpass/StudentModules/StudBottomNav.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getpass/Errro.dart';
import 'package:getpass/Success.dart';
import '../SendLeaveNotificastion.dart';


class LeaveRequest extends StatefulWidget {
  @override
  State<LeaveRequest> createState() => _LeaveRequestState();
}

class _LeaveRequestState extends State<LeaveRequest> {

  final FirebaseAuth _auth=FirebaseAuth.instance;
  CollectionReference ref=FirebaseFirestore.instance.collection('Students');

  bool load=false;
  final _key=GlobalKey<FormState>();
  String? studClass;
  DateTime? pickedDate;
  TimeOfDay? pickedTime;
  bool isAgree=false;
  final dateController=TextEditingController();
  final timeController=TextEditingController();
  final reasonController=TextEditingController();
  final guardianController=TextEditingController();
  final guardianContactController=TextEditingController();

  String currentDateTime(){
    String date=DateTime.now().toString().split(" ")[0];
    TimeOfDay currentTime=TimeOfDay.now();
    String time="${currentTime.hour.toString().split(" ")[0]}:${currentTime.minute.toString().split(" ")[0]} ${currentTime.period.name.toUpperCase()}";
    return "$date $time";
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
        child: Form(
          key: _key,
          child: ListView(
            children: [
              Container(
                decoration: const BoxDecoration(color: Color(0xff006BFF),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("Leave Request Form",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 22),),
                    subtitle: Text("Apply for a gate pass to leave the college campus.",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 15)),
                  ),
                ),
              ),
              Container(
                // height: 300,
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      Text("Student Details",style: GoogleFonts.arimo(color: Colors.black,fontSize: 19,fontWeight: FontWeight.w600),),
                      const SizedBox(height: 10),
                      StreamBuilder(
                        stream: ref.doc(_auth.currentUser!.uid).snapshots(),
                        builder: (context, AsyncSnapshot<DocumentSnapshot> streamSnapshot){
                          if(streamSnapshot.connectionState == ConnectionState.waiting){
                            return const Center(child: CircularProgressIndicator(),);
                          } else if(streamSnapshot.hasError){
                            return const Center(child: Text("Something went wrong"));
                          } else {
                            Map<String, dynamic> data=streamSnapshot.data!.data() as Map<String, dynamic>;
                            studClass=data['class'];
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: const Color(0xffF4F6FF),borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    title: Text("Name",style: TextStyle(fontSize: 15,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.w400),),
                                    subtitle: Text("${data['name']}",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Container(
                                  decoration: BoxDecoration(color: const Color(0xffF4F6FF),borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    title: Text("Enrollment No.",style: TextStyle(fontSize: 15,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.w400),),
                                    subtitle: Text("${data['enroll']}",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Container(
                                  decoration: BoxDecoration(color: const Color(0xffF4F6FF),borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    title: Text("Class",style: TextStyle(fontSize: 15,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.w400),),
                                    subtitle: Text("${data['class']}",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30,),
                          Text("Leave Details",style: GoogleFonts.arimo(color: Colors.black,fontSize: 19,fontWeight: FontWeight.w600),),
                          const SizedBox(height: 10),
                          const Text("Reason",style: TextStyle(fontSize: 16),),
                          const SizedBox(height: 4,),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            maxLines: 4,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1
                              )),),),
                            controller: reasonController,
                            validator: (value){
                              if(value!.isEmpty || value==null){
                                return "Reason is required";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 15,),
                          const Text("Date",style: TextStyle(fontSize: 16),),
                          const SizedBox(height: 4,),
                          TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1
                                )),),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today_rounded,size: 20,),
                                  onPressed: ()async {
                                    pickedDate=await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2100)
                                    );
                                    if(pickedDate!=null) {
                                      setState(() {
                                        dateController.text=pickedDate.toString().split(" ")[0];
                                      });
                                    }
                                  },)),
                            readOnly: true,
                            controller: dateController,
                            validator: (value){
                              if(value!.isEmpty || value==null){
                                return "Date is required";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 15,),
                          const Text("Time",style: TextStyle(fontSize: 16),),
                          const SizedBox(height: 4,),
                          TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1
                                )),),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.access_time_filled_rounded,size: 20,),
                                  onPressed: () async {
                                    pickedTime=await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if(pickedTime!=null){
                                      setState(() {
                                        timeController.text="${pickedTime!.hour}:${pickedTime!.minute} ${pickedTime!.period.name.toUpperCase()}";
                                      });
                                    }
                                  },
                                )),
                            controller: timeController,
                            readOnly: true,
                            validator: (value){
                              if(value!.isEmpty || value==null){
                                return "Time is required";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 30,),
                          Text("Emergency Contact (optional)",style: GoogleFonts.arimo(color: Colors.black,fontSize: 19,fontWeight: FontWeight.w600),),
                          const SizedBox(height: 10),
                          const Text("Guardian Name",style: TextStyle(fontSize: 16),),
                          const SizedBox(height: 4,),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1
                              )),),),
                            controller: guardianController,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 10),
                          const Text("Contact Number",style: TextStyle(fontSize: 16),),
                          const SizedBox(height: 4,),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1
                              )),),),
                            controller: guardianContactController,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: isAgree,
                            onChanged:(bool? value){
                              setState(() {
                                isAgree=value ?? false;
                              });
                            },
                          ),
                          const Expanded(
                            child: Text("I confirm that i have informed my guardian about this leave request",
                                style: TextStyle(fontSize: 16,),),
                          )
                        ],
                      ),
                      const SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 55,width: 260,
                            decoration: BoxDecoration(color: isAgree?const Color(0xff006BFF):const Color(0xffD4EBF8),borderRadius: BorderRadius.circular(5)),
                            child: TextButton(
                              child: load?const CircularProgressIndicator(color: Colors.white,):const Text("Submit Request",style: TextStyle(color: Colors.white,fontSize: 19,fontWeight: FontWeight.w500),),
                              onPressed: () async {
                                setState(() {
                                  load=true;
                                });
                                if(_key.currentState!.validate()){
                                  if(isAgree){
                                    DocumentSnapshot studDoc=await FirebaseFirestore.instance.collection('Students').doc(_auth.currentUser!.uid).get();
                                    Map<String, dynamic> studData=studDoc.data() as Map<String, dynamic>;
                                    final String unique=DateTime.now().millisecondsSinceEpoch.toString();
                                    CollectionReference leaveDept=FirebaseFirestore.instance.collection('Leaves_${studData['dept']}');
                                    
                                    await leaveDept.doc(unique).set({
                                      'name':studData['name'].toString(),
                                      'enroll':studData['enroll'],
                                      'dept':studData['dept'],
                                      'class':studData['class'],
                                      'ctName':studData['ctName'],
                                      'photoURL':studData['photoURL'],
                                      'teaID':studData['teaID'],
                                      'hodID':studData['hodID'],
                                      'reason':reasonController.text.toString(),
                                      'date':dateController.text.toString(),
                                      'time':timeController.text.toString(),
                                      'guardianName':guardianContactController.text.toString(),
                                      'guardianNumber':guardianContactController.text.toString(),
                                      'userID':studData['userID'],
                                      'classTeacherApproval':"Pending",
                                      'hodApproval':"Pending",
                                      'finalStatus':"Pending",
                                      'appliedAt': currentDateTime().toString()
                                    }).then((onValue) async {
                                      Success().toastMessage("Request Submitted Successfully");
                                      Navigator.pop(context, MaterialPageRoute(builder: (builder){
                                        return StudBottomNav();
                                      }));
                                      FirebaseFirestore firestore = FirebaseFirestore.instance;
                                      String? teacherToken = (await firestore.collection('Teachers').doc(studData['teaID']).get()).data()?['fcmToken'];
                                      String? hodToken = (await firestore.collection('HODs').doc(studData['hodID']).get()).data()?['fcmToken'];

                                      List<String> fcmTokens = [if (teacherToken != null) teacherToken, if (hodToken != null) hodToken];
                                      for (String token in fcmTokens) {
                                        await sendNotification(
                                          title: "New Leave Request",
                                          body: "${studData['name']} has requested leave for: "
                                              "${reasonController.text.length>25?"${reasonController.text.substring(0,25)}..."
                                              :reasonController.text.toString()}",
                                          fcmToken: token,
                                        );
                                      }
                                    });
                                  } else {
                                    Error().toastMessage("Check parent confirmation box");
                                    setState(() {
                                      load=false;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    load=false;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30,),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}