import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getpass/HODsModules/DeptTeacher.dart';
import 'package:getpass/Errro.dart';
import 'package:getpass/Success.dart';

class AddTeacher extends StatefulWidget {
  @override
  State<AddTeacher> createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {

  bool pass=true;
  bool load=false;
  final _key=GlobalKey<FormState>();
  final nameController=TextEditingController();
  final contactController=TextEditingController();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final classController=TextEditingController();
  final educationController=TextEditingController();

  final FirebaseAuth _auth=FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Teacher"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: Form(
          key: _key,
          child: ListView(
            children: [
              Text("Teacher Details",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.6))),
              const SizedBox(height: 20,),
              TextFormField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(labelText: "Name", hintText: "eg. John R.K",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.person_outline_rounded,size: 22,color: Color(0xff3F72AF),)),
                controller: nameController,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Enter valid name";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15,),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Contact",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.call_outlined,size: 22,color: Color(0xff3F72AF))),
                controller: contactController,
                validator: (value){
                  if(value==null || value.isEmpty || value.length!=10){
                    return "Enter valid number";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15,),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.alternate_email_rounded,size: 22,color: Color(0xff3F72AF))),
                controller: emailController,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Enter valid email";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 15,),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: pass?true:false,
                decoration: InputDecoration(labelText: "Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.security_outlined,size: 22,color: Color(0xff3F72AF)),
                suffixIcon: IconButton(
                  icon: pass?const Icon(Icons.lock_outline,color: Color(0xff1DB954),size: 22,):const Icon(Icons.lock_open_outlined,color: Color(0xffDC3545),size: 22,),
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
              const SizedBox(height: 20,),
              Text("Other Details",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.6))),
              const SizedBox(height: 20,),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('HODs').doc(_auth.currentUser!.uid).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> streamSnapshot){
                  if(streamSnapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  } else if(streamSnapshot.hasError){
                    return const Center(child: Text("Something went wrong"),);
                  } else {
                    Map<String, dynamic> data=streamSnapshot.data!.data() as Map<String, dynamic>;
                    return TextField(
                      keyboardType: TextInputType.name,
                      readOnly: true,
                      decoration: InputDecoration(hintText: "${data['dept']}",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.school_outlined,size: 22,color: Color(0xff3F72AF),)),
                    );
                  }
                },
              ),
              const SizedBox(height: 15,),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(hintText: "eg. TYCO-A",labelText: "Class",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.class_outlined,size: 22,color: Color(0xff3F72AF),)),
                      controller: classController,
                      validator: (value){
                        if(value==null || value.isEmpty){
                          return "Enter valid class";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(labelText: "Education",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.school_outlined,size: 22,color: Color(0xff3F72AF),)),
                      controller: educationController,
                      validator: (value){
                        if(value==null || value.isEmpty){
                          return "Enter valid education";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ],
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
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 45,width: 150,
                    decoration: BoxDecoration(color: const Color(0xff112D4E),borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                      child: load?const CircularProgressIndicator():Text("Add",style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 18,fontWeight: FontWeight.w500)),
                      onPressed: () async {
                        setState(() {
                          load=true;
                        });
                        if(_key.currentState!.validate()){
                          DocumentSnapshot docData=await FirebaseFirestore.instance.collection('HODs').doc(_auth.currentUser!.uid).get();
                          CollectionReference ref=FirebaseFirestore.instance.collection('Teachers');
                          FirebaseAuth tea=FirebaseAuth.instance;
                          await tea.createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString()
                          ).then((onValue) async {
                            await ref.doc(tea.currentUser!.uid).set({
                              'class':classController.text.toUpperCase().toString(),
                              'contact':contactController.text.toString(),
                              'dept':docData['dept'].toString(),
                              'education':educationController.text.toString(),
                              'email':emailController.text.toString(),
                              'name':nameController.text.toString(),
                              'password':passwordController.text.toString(),
                              'photoURL':null,
                              'hodID':_auth.currentUser!.uid.toString(),
                              'userID':tea.currentUser!.uid.toString(),
                              'userType':"Teacher"
                            }).then((onValue){
                              Success().toastMessage("Teacher Added Successfully");
                              Navigator.pop(context, MaterialPageRoute(builder: (builder){
                                return DeptTeacher();
                              }));
                            });
                          }).onError((error, stackTrace){
                            Error().toastMessage(error.toString());
                            setState(() {
                              load=false;
                            });
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
                      child: const Text("Cancel"),
                      onPressed: (){
                        Navigator.pop(context, MaterialPageRoute(builder: (builder){
                          return DeptTeacher();
                        }));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25,),
            ],
          ),
        ),
      ),
    );
  }
}