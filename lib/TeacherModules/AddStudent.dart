import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpass/Success.dart';
import 'package:getpass/TeacherModules/AllStudents.dart';
import 'package:getpass/Errro.dart';

class AddStudent extends   StatefulWidget {
  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  bool pass=true;
  bool load=false;

  final FirebaseAuth _auth=FirebaseAuth.instance;
  CollectionReference ref=FirebaseFirestore.instance.collection('Teachers');
  CollectionReference collectionReference=FirebaseFirestore.instance.collection('Students');
  final _key=GlobalKey<FormState>();
  final nameController=TextEditingController();
  final enrollController=TextEditingController();
  final contactController=TextEditingController();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final deptController=TextEditingController();
  final classController=TextEditingController();
  final ccController=TextEditingController();
  final hodNameController=TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Form(
          key: _key,
          child: ListView(
            children: [
              Text("Student Details",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.6)),),
              const SizedBox(height: 15,),
              TextFormField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(labelText: "Full name",border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),prefixIcon: const Icon(Icons.person_outline_rounded,size: 23,color: Color(0xff3F72AF),)),
                controller: nameController,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Enter valid name";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "En. No",border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),prefixIcon: const Icon(Icons.numbers_outlined,size: 23,color: Color(0xff3F72AF),)),
                controller: enrollController,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Enter valid enroll.";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Contact ",border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),prefixIcon: const Icon(Icons.call_outlined,size: 23,color: Color(0xff3F72AF),)),
                controller: contactController,
                validator: (value){
                  if(value==null || value.isEmpty || value.length!=10){
                    return "Enter valid number";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email",border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),prefixIcon: const Icon(Icons.alternate_email_rounded,size: 23,color: Color(0xff3F72AF),)),
                controller: emailController,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Enter valid email.";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: pass?true:false,
                decoration: InputDecoration(labelText: "Password",border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),prefixIcon: const Icon(Icons.security_outlined,size: 23,color: Color(0xff3F72AF),),
                suffixIcon: IconButton(
                  icon: pass?const Icon(Icons.lock_outline,size: 23,color: Color(0xff1DB954)):const Icon(Icons.lock_open_rounded,size: 23,color: Color(0xffDC3545)),
                onPressed: (){
                    setState(() {
                        pass=pass?false:true;
                    });
                },),),
                controller: passwordController,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Enter valid password.";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 25,),
              Text("Other Details",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.6)),),
              const SizedBox(height: 15,),
              StreamBuilder(
                stream: ref.doc(_auth.currentUser!.uid).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> streamSnapshot){
                  if(streamSnapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  } else if(streamSnapshot.hasError) {
                    return const Center(child: Text("Something went wrong"),);
                  } else {
                    Map<String, dynamic> data=streamSnapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      children: [
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(hintText: data['dept'],border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),prefixIcon: const Icon(Icons.school_outlined,size: 23,color: Color(0xff3F72AF),)),
                          controller: deptController,
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                readOnly: true,
                                decoration: InputDecoration(hintText: data['class'],border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),prefixIcon: const Icon(Icons.class_outlined,size: 23,color: Color(0xff3F72AF),)),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: TextField(
                                readOnly: true,
                                decoration: InputDecoration(hintText: data['name'],border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),prefixIcon: const Icon(Icons.person_outline_rounded,size: 23,color: Color(0xff3F72AF),)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15,),
                        TextField(
                          keyboardType: TextInputType.name,
                          readOnly: true,
                          decoration: InputDecoration(hintText: data['userID'],border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),prefixIcon: const Icon(Icons.numbers_outlined,size: 23,color: Color(0xff3F72AF),)),
                        ),
                        const SizedBox(height: 15,),
                        TextField(
                          keyboardType: TextInputType.text,
                          readOnly: true,
                          decoration: InputDecoration(hintText: data['hodID'],border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),prefixIcon: const Icon(Icons.numbers_outlined,size: 23,color: Color(0xff3F72AF),)),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 15,),
              TextFormField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(labelText: "HOD name",hintText: "eg. John R.K",border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),prefixIcon: const Icon(Icons.person_outline_rounded,size: 23,color: Color(0xff3F72AF),)),
                controller: hodNameController,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Enter valid name";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 25,),
              Text("Profile Picture",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.6)),),
              const SizedBox(height: 15,),
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.black.withOpacity(0.1))),
                child: GestureDetector(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_upload_outlined,size: 50,color: Color(0xffA6E3E9),),
                      Text("Upload image",style: TextStyle(fontSize: 13,color: Colors.black.withOpacity(0.7),fontWeight: FontWeight.w500),),
                    ],
                  ),
                  onTap: (){
                    const msg=SnackBar(content: Text("Currently not available"));
                    ScaffoldMessenger.of(context).showSnackBar(msg);
                  },
                )
              ),
              const SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 45,width: 150,
                    decoration: BoxDecoration(color: const Color(0xff112D4E),borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                      child: load?const CircularProgressIndicator():Text("Add",style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 18,fontWeight: FontWeight.w500),),
                      onPressed: () async {
                        setState(() {
                          load=true;
                        });
                        if(_key.currentState!.validate()){
                          DocumentSnapshot docData=await FirebaseFirestore.instance.collection('Teachers').doc(_auth.currentUser!.uid).get();
                          CollectionReference ref=FirebaseFirestore.instance.collection('Students');
                          FirebaseAuth stud=FirebaseAuth.instance;
                          await stud.createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString()
                          ).then((onValue){
                            ref.doc(stud.currentUser!.uid).set({
                              'class':docData['class'].toString().toUpperCase(),
                              'contact':contactController.text.toString(),
                              'ctName':docData['name'].toString(),
                              'dept':docData['dept'],
                              'email':emailController.text.toString(),
                              'enroll':enrollController.text.toString(),
                              'hodID':docData['hodID'],
                              'hodName':hodNameController.text.toString(),
                              'name':nameController.text.toString(),
                              'password':passwordController.text.toString(),
                              'photoURL':null,
                              'teaID':docData['userID'],
                              'totalLeave':"0",
                              'userID':stud.currentUser!.uid.toString(),
                              'userType':"Student"
                            }).then((onValue){
                              Success().toastMessage("Student Added To Class Successfully");
                              Navigator.pop(context, MaterialPageRoute(builder: (builder){
                                return AllStudents();
                              }));
                            });
                          }).onError((error, stackTrace){
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
                  const SizedBox(width: 15,),
                  Container(
                    height: 45,width: 150,
                    decoration: BoxDecoration(color: const Color(0xffDBE2EF),borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                      child: Text("Cancel",style: TextStyle(color: const Color(0xff112D4E).withOpacity(0.7),fontSize: 18,fontWeight: FontWeight.w500),),
                      onPressed: (){
                        Navigator.pop(context, MaterialPageRoute(builder: (builder){
                          return AllStudents();
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
      ),
    );
  }
}