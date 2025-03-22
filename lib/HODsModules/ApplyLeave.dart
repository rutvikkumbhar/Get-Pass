import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpass/HODsModules/HODsHome.dart';
import '../SendLeaveNotificastion.dart';
import '../Success.dart';

class ApplyLeave extends StatefulWidget {
  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {

  bool load=false;
  DateTime? pickedDate;
  TimeOfDay? pickedTime;
  final TimeOfDay minTime = const TimeOfDay(hour: 8, minute: 35);
  final TimeOfDay maxTime = const TimeOfDay(hour: 15, minute: 45);
  final _key=GlobalKey<FormState>();
  final reasonController=TextEditingController();
  final dateController=TextEditingController();
  final timeController=TextEditingController();

  final FirebaseAuth _auth=FirebaseAuth.instance;
  CollectionReference ref=FirebaseFirestore.instance.collection('HODs');

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
        title:  const Text("Apply Leave"),
        centerTitle: true,
      ),
      body: Padding(
        padding:  const EdgeInsets.only(left: 20,right: 20),
        child: ListView(
          children: [
            const SizedBox(height: 10,),
            Text("Your Details",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.6)),),
            const SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color:  const Color(0xffF4EEFF),borderRadius: BorderRadius.circular(15)),
              child: StreamBuilder(
                stream: ref.doc(_auth.currentUser!.uid).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> streamSnapshot){
                  if(streamSnapshot.connectionState ==ConnectionState.waiting){
                    return  const Center(child: CircularProgressIndicator(),);
                  } else if(streamSnapshot.hasError){
                    return  const Center(child: Text("Something went wrong"),);
                  } else {
                    Map<String, dynamic> data=streamSnapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      children: [
                        ListTile(
                          title: Text("Name",style: TextStyle(fontSize: 15,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.w400),),
                          subtitle: Text("Prof. ${data['name']}",style:  const TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),
                        ),
                        ListTile(
                          title: Text("Department",style: TextStyle(fontSize: 15,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.w400),),
                          subtitle: Text("${data['dept']}",style:  const TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),
                        ),
                        ListTile(
                          title: Text("ID",style: TextStyle(fontSize: 15,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.w400),),
                          subtitle: Text("${data['userID']}",style:  const TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),
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
                  const SizedBox(height: 25,),
                  Text("Leave Details",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.6)),),
                  const SizedBox(height: 10,),
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
                          icon:  const Icon(Icons.calendar_today_rounded,size: 20,color: Color(0xff3F72AF),),
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
                          icon:  const Icon(Icons.access_time_filled_rounded,size: 20,color: Color(0xff3F72AF),),
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
                                    title: const Text("Invalid Time"),
                                    content: const Text("Please select a time between 8:35 AM and 3:45 PM."),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK"),
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
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,width: 150,
                  decoration: BoxDecoration(color:  const Color(0xff112D4E),borderRadius: BorderRadius.circular(5)),
                  child: TextButton(
                    child:load?  const CircularProgressIndicator():Text("Apply Leave",style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 18,fontWeight: FontWeight.w500)),
                    onPressed: () async {
                      setState(() {
                        load=true;
                      });
                      if(_key.currentState!.validate()){
                        DocumentSnapshot docData=await FirebaseFirestore.instance.collection('HODs').doc(_auth.currentUser!.uid).get();
                        CollectionReference ref=FirebaseFirestore.instance.collection('HOD Leaves');
                        final String unique=DateTime.now().millisecondsSinceEpoch.toString();
                        await ref.doc(unique).set({
                          'name':docData['name'],
                          'dept':docData['dept'],
                          'photoURL':docData['photoURL'],
                          'reason':reasonController.text.toString(),
                          'date':dateController.text.toString(),
                          'time':timeController.text.toString(),
                          'userID':docData['userID'],
                          'principleApproval':"Pending",
                          'appliedAt':currentDateTime().toString()
                        }).then((onValue) async {
                          Success().toastMessage("Request Submitted Successfully");
                          Navigator.pop(context, MaterialPageRoute(builder: (builder){
                            return HODsHome();
                          }));
                          FirebaseFirestore firestore = FirebaseFirestore.instance;
                          String? hodToken = (await firestore.collection('Principle').doc(docData['principleID']).get()).data()?['fcmToken'];
                          await sendNotification(
                            title: "New Leave Request",
                            body: "Prof. ${docData['name']} has requested leave for: "
                                "${reasonController.text.length>25?"${reasonController.text.substring(0,25)}..."
                                :reasonController.text.toString()}",
                            fcmToken: hodToken.toString(),
                          );
                        });
                      } else {
                        setState(() {
                          load=false;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 15,),
                Container(
                  height: 50,width: 150,
                  decoration: BoxDecoration(color:  const Color(0xffDBE2EF),borderRadius: BorderRadius.circular(5)),
                  child: TextButton(
                    child: Text("Cancel",style: TextStyle(color:  const Color(0xff112D4E).withOpacity(0.7),fontSize: 18,fontWeight: FontWeight.w500),),
                    onPressed: (){
                      Navigator.pop(context, MaterialPageRoute(builder: (builder){
                        return HODsHome();
                      }));
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}