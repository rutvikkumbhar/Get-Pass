import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpass/Principle/allHODs.dart';
import 'package:getpass/Errro.dart';
import 'package:getpass/Success.dart';

class AddHOD extends StatefulWidget {

  @override
  State<AddHOD> createState() => _AddHODState();
}

class _AddHODState extends State<AddHOD> {
  FirebaseAuth _auth=FirebaseAuth.instance;
  CollectionReference ref=FirebaseFirestore.instance.collection('HODs');

  final _key=GlobalKey<FormState>();
  final nameController=TextEditingController();
  final contactController=TextEditingController();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final departmentController=TextEditingController();
  final educationController=TextEditingController();
  bool pass=true;
  bool load=false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add HOD"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Form(
          key: _key ,
          child: ListView(
            children: [
              SizedBox(height: 10,),
              Text("Teacher Details",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.6))),
              SizedBox(height: 20,),
              TextFormField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(labelText: "Name", hintText: "eg. John R.K",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    prefixIcon:  Icon(Icons.person_outline_rounded,size: 22,color: Color(0xff3F72AF),)),
                controller: nameController,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Enter valid name";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15,),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Contact",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    prefixIcon:  Icon(Icons.call_outlined,size: 22,color: Color(0xff3F72AF),)),
                controller: contactController,
                validator: (value){
                  if(value==null || value.isEmpty || value.length!=10){
                    return "Enter valid number";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15,),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    prefixIcon:  Icon(Icons.alternate_email_outlined,size: 22,color: Color(0xff3F72AF),)),
                controller: emailController,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Enter valid email";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15,),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: pass?true:false,
                decoration: InputDecoration(labelText: "Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    prefixIcon:  Icon(Icons.security,size: 22,color: Color(0xff3F72AF),),
                suffixIcon: IconButton(
                  icon: pass? Icon(Icons.lock_outline,color: Color(0xff1DB954),size: 22,): Icon(Icons.lock_open_outlined,color: Color(0xffDC3545),size: 22,),
                  onPressed: (){
                    setState(() {
                      pass=pass?false:true;
                    });
                  },
                )),
                controller: passwordController,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Enter valid password";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 25,),
              Text("Other Details",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.6))),
              SizedBox(height: 20,),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Department",hintText: "eg. Computer Engineering",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    prefixIcon:  Icon(Icons.school_outlined,size: 22,color: Color(0xff3F72AF),)),
                controller: departmentController,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Enter valid department";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15,),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Education",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    prefixIcon:  Icon(Icons.school_outlined,size: 22,color: Color(0xff3F72AF),)),
                controller: educationController,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Enter valid education";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,width: 150,
                    decoration: BoxDecoration(color:  Color(0xff112D4E),borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                      child:load?CircularProgressIndicator() :Text("Add",style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 18,fontWeight: FontWeight.w500)),
                      onPressed: () async {
                        setState(() {
                          load=true;
                        });
                        if(_key.currentState!.validate()){
                          DocumentSnapshot docData=await FirebaseFirestore.instance.collection('Principle').doc(_auth.currentUser!.uid).get();
                          String pEmail=docData['email'].toString();
                          String pPass=docData['password'].toString();
                          String pID=docData['userID'].toString();
                          FirebaseAuth hod=FirebaseAuth.instance;
                          await hod.createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString(),
                          ).then((onValue){
                            ref.doc(hod.currentUser!.uid).set({
                              'contact':contactController.text.toString(),
                              'dept':departmentController.text.toString(),
                              'education':educationController.text.toString(),
                              'email':emailController.text.toString(),
                              'name':nameController.text.toString(),
                              'password':passwordController.text.toString(),
                              'photoURL':null,
                              'principleID':pID,
                              'userID':hod.currentUser!.uid.toString(),
                              'userType':"HOD"
                            }).then((onValue) async {
                              hod.signOut();
                              await _auth.signInWithEmailAndPassword(
                                email: pEmail,password: pPass,
                              ).then((onValue){
                                Success().toastMessage("HOD Added Successfully");
                                Navigator.pop(context, MaterialPageRoute(builder: (builder){
                                  return allHODs();
                                }));
                              });
                            });
                          }).onError((stackTrace, error){
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
                  SizedBox(width: 15,),
                  Container(
                    height: 50,width: 150,
                    decoration: BoxDecoration(color:  Color(0xffDBE2EF),borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                      child: Text("Cancel",style: TextStyle(fontSize: 18),),
                      onPressed: (){
                        Navigator.pop(context, MaterialPageRoute(builder: (builder){
                          return allHODs();
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
      ),
    );
  }
}