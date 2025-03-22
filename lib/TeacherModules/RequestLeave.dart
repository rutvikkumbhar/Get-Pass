import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpass/TeacherModules/TeacherrLeaves.dart';
import '../SendLeaveNotificastion.dart';
import '../Success.dart';

class RequestLeave extends StatefulWidget {
  @override
  State<RequestLeave> createState() => _RequestLeaveState();
}

class _RequestLeaveState extends State<RequestLeave> {

  bool load=false;
  DateTime? pickedDate;
  TimeOfDay? pickedTime;
  final TimeOfDay minTime = TimeOfDay(hour: 8, minute: 35);
  final TimeOfDay maxTime = TimeOfDay(hour: 15, minute: 45);
  final _key=GlobalKey<FormState>();
  final reasonController=TextEditingController();
  final dateController=TextEditingController();
  final timeController=TextEditingController();

  final FirebaseAuth _auth=FirebaseAuth.instance;
  CollectionReference ref=FirebaseFirestore.instance.collection('Teachers');

  String currentDateTime(){
    String date=DateTime.now().toString().split(" ")[0];
    TimeOfDay currentTime=TimeOfDay.now();
    String time="${currentTime.hour.toString().split(" ")[0]}:${currentTime.minute.toString().split(" ")[0]} ${currentTime.period.name.toUpperCase()}";
    return "$date $time";
  }
  bool _isTimeInRange(TimeOfDay time) {
    return (time.hour>minTime.hour|| (time.hour==minTime.hour &&time.minute>=minTime.minute))&&
        (time.hour<maxTime.hour||(time.hour==maxTime.hour&&time.minute<=maxTime.minute));
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Apply Leave"),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.only(left: 20,right: 20),
        child: ListView(
          children: [
             SizedBox(height: 10,),
            Text("Your Details",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.6)),),
             SizedBox(height: 10,),

            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color:  Color(0xffF4EEFF),borderRadius: BorderRadius.circular(15)),
              child: StreamBuilder(
                stream: ref.doc(_auth.currentUser!.uid).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> streamSnapshot){
                  if(false){
                    return  Center(child: CircularProgressIndicator(),);
                  } else if(streamSnapshot.hasError){
                    return  Center(child: Text("Something went wrong"),);
                  } else {
                    Map<String, dynamic> data=streamSnapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      children: [
                        ListTile(
                          title: Text("Name",style: TextStyle(fontSize: 15,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.w400),),
                          subtitle: Text("Prof. ${data['name']}",style:  TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),
                        ),
                        ListTile(
                          title: Text("Class",style: TextStyle(fontSize: 15,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.w400),),
                          subtitle: Text("${data['class']}",style:  TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),
                        ),
                        ListTile(
                          title: Text("ID",style: TextStyle(fontSize: 15,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.w400),),
                          subtitle: Text("${data['userID']}",style:  TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   SizedBox(height: 25,),
                  Text("Leave Details",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.6)),),
                   SizedBox(height: 10,),
                   Text("Reason",style: TextStyle(fontSize: 16),),
                   SizedBox(height: 4,),
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
                   SizedBox(height: 15,),
                   Text("Date",style: TextStyle(fontSize: 16),),
                   SizedBox(height: 4,),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1
                        )),),
                        suffixIcon: IconButton(
                          icon:  Icon(Icons.calendar_today_rounded,size: 20,color: Color(0xff3F72AF),),
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
                   SizedBox(height: 15,),
                   Text("Time",style: TextStyle(fontSize: 16),),
                   SizedBox(height: 4,),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black.withOpacity(0.1
                        )),),
                        suffixIcon: IconButton(
                          icon:  Icon(Icons.access_time_filled_rounded,size: 20,color: Color(0xff3F72AF),),
                          onPressed: () async {
                            pickedTime=await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if(pickedTime!=null && _isTimeInRange(pickedTime!)){
                              setState(() {
                                timeController.text="${pickedTime!.hour}:${pickedTime!.minute} ${pickedTime!.period.name.toUpperCase()}";
                              });
                            } else if(_isTimeInRange(pickedTime!)==false) {
                              showDialog(
                                  context: context,
                                  builder: (context)=>AlertDialog(
                                    title: Text("Invalid Time"),
                                    content: Text("Please select a time between 8:35 AM and 3:45 PM."),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("OK"),
                                      ),
                                    ],
                                  )
                              );
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
                ],
              ),
            ),
             SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,width: 150,
                  decoration: BoxDecoration(color:  Color(0xff112D4E),borderRadius: BorderRadius.circular(5)),
                  child: TextButton(
                    child:load?  CircularProgressIndicator():Text("Apply Leave",style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 18,fontWeight: FontWeight.w500)),
                    onPressed: () async {
                      setState(() {
                        load=true;
                      });
                      if(_key.currentState!.validate()){
                        DocumentSnapshot docData=await FirebaseFirestore.instance.collection('Teachers').doc(_auth.currentUser!.uid).get();
                        CollectionReference ref=FirebaseFirestore.instance.collection('Campus Leaves');
                        final String unique=DateTime.now().millisecondsSinceEpoch.toString();
                        final int totalLeave=int.parse(docData['totalLeave'].toString())+1;
                        await ref.doc(unique).set({
                          'name':docData['name'],
                          'dept':docData['dept'],
                          'class':docData['class'],
                          'photoURL':docData['photoURL'],
                          'hodID':docData['hodID'],
                          'reason':reasonController.text.toString(),
                          'date':dateController.text.toString(),
                          'time':timeController.text.toString(),
                          'userID':docData['userID'],
                          'hodApproval':"Pending",
                          'finalStatus':"Pending",
                          'prinApproval':"Pending",
                          'appliedAt':currentDateTime().toString()
                        }).then((onValue) async {
                          Success().toastMessage("Request Submitted Successfully");
                          Navigator.pop(context);
                          CollectionReference updateleave=FirebaseFirestore.instance.collection('Teachers');
                          updateleave.doc(_auth.currentUser!.uid).update({
                            'totalLeave':totalLeave.toString(),
                          });
                          FirebaseFirestore firestore = FirebaseFirestore.instance;
                          String? hodToken = (await firestore.collection('HODs').doc(docData['hodID']).get()).data()?['fcmToken'];
                          String? prinID = (await firestore.collection('HODs').doc(docData['hodID']).get()).data()?['principleID'];
                          String? prinToken = (await firestore.collection("Principle").doc(prinID).get()).data()?['fcmToken'];
                          List<String> fcmTokens = [if (hodToken != null) hodToken, if (prinToken != null) prinToken];
                          for (String token in fcmTokens) {
                            await sendNotification(
                              title: "New Leave Request",
                              body: "${docData['name']} has requested leave for: "
                                  "${reasonController.text.length>25?"${reasonController.text.substring(0,25)}..."
                                  :reasonController.text.toString()}",
                              fcmToken: token,
                            );
                          }
                        });
                      } else {
                        setState(() {
                          load=false;
                        });
                      }
                    },
                  ),
                ),
                 SizedBox(width: 15,),
                Container(
                  height: 50,width: 150,
                  decoration: BoxDecoration(color:  Color(0xffDBE2EF),borderRadius: BorderRadius.circular(5)),
                  child: TextButton(
                    child: Text("Cancel",style: TextStyle(color:  Color(0xff112D4E).withOpacity(0.7),fontSize: 18,fontWeight: FontWeight.w500),),
                    onPressed: (){
                      Navigator.pop(context, MaterialPageRoute(builder: (builder){
                        return TeacherLeaves();
                      }));
                    },
                  ),
                )
              ],
            ),
             SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}