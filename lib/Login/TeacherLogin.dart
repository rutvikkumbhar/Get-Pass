import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:getpass/HODsModules/hodBottomnNav.dart';
import 'package:getpass/TeacherModules/TeaBottomNav.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getpass/Errro.dart';

class Teacherlogin extends StatefulWidget {
  @override
  State<Teacherlogin> createState() => _TeacherloginState();
}

class _TeacherloginState extends State<Teacherlogin> {

  CollectionReference ref=FirebaseFirestore.instance.collection('Teachers');
  CollectionReference collectionReference=FirebaseFirestore.instance.collection('HODs');
  final FirebaseAuth _auth=FirebaseAuth.instance;

  final emailController=TextEditingController();
  final passController=TextEditingController();
  bool pass=true;
  bool load=false;
  final _key=GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Form(
            key: _key,
            child: Column(
              children: [
                const SizedBox(height: 160,),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    height: 100,width: 100,
                    decoration: BoxDecoration(image: const DecorationImage(image: AssetImage("assets/images/teacherpfp.png"),fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(60)),
                  ),
                ),
                const SizedBox(height: 3,),
                Text("Teacher Login",style: GoogleFonts.albertSans(fontSize: 22, fontWeight: FontWeight.w600),),
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: "Email ID",border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none),filled: true,fillColor: Colors.grey.withOpacity(0.2),
                        hintStyle: TextStyle(fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.5))),
                    controller: emailController,
                    validator: (value){
                      if(value!.isEmpty || value==null){
                        return "Enter valid email";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: pass?true:false,
                    decoration: InputDecoration(hintText: "Password",border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none),filled: true,fillColor: Colors.grey.withOpacity(0.2),
                        hintStyle: TextStyle(fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.5)),
                        suffixIcon:Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            icon: pass?const Icon(Icons.lock_outline_rounded):const Icon(Icons.lock_open_outlined),
                            onPressed: (){
                              setState(() {
                                pass=pass?false:true;
                              });
                            },
                          ),
                        )),
                    controller: passController,
                    validator: (value){
                      if(value!.isEmpty || value==null){
                        return "Enter valid password";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 25,),
                Container(
                  height: 50,width: 200,
                  decoration: BoxDecoration(color: const Color(0xff80C4E9),borderRadius: BorderRadius.circular(30)),
                  child: TextButton(
                    child: load?const CircularProgressIndicator(color: Colors.white,):Text("Login",style: GoogleFonts.albertSans(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w700),),
                    onPressed: (){
                      setState(() {
                        load=true;
                      });
                      if(_key.currentState!.validate()) {
                        _auth.signInWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password: passController.text.toString()
                        ).then((onValue) async {
                            DocumentSnapshot docData=await ref.doc(_auth.currentUser!.uid.toString()).get();
                            Map<String, dynamic>? data=docData.exists?docData.data() as Map<String, dynamic>:null;
                            DocumentSnapshot hodDoc=await collectionReference.doc(_auth.currentUser!.uid).get();
                            Map<String, dynamic>? hodData=hodDoc.exists?hodDoc.data() as Map<String, dynamic>:null;

                            if(emailController.text.toString()==data?['email'] && passController.text.toString()==data?['password']){
                              String? token=await FirebaseMessaging.instance.getToken();
                              await ref.doc(_auth.currentUser!.uid).update({
                                'fcmToken':token.toString()
                              }).then((onValue){
                                Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => TeaBottomNav()),
                                      (Route<dynamic> route) => false,);
                              });
                            } else if(emailController.text.toString()==hodData?['email'] && passController.text.toString()==hodData?['password']){
                              String? token=await FirebaseMessaging.instance.getToken();
                              await collectionReference.doc(_auth.currentUser!.uid).update({
                                'fcmToken':token.toString()
                              }).then((onValue){
                                Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => hodBottomNav()),
                                      (Route<dynamic> route) => false,);
                              });
                            } else {
                              setState(() {
                                load=false;
                              });
                              _auth.signOut();
                              Error().toastMessage("Invalid Email ID and Password");
                            }
                        }).onError((error, stackTrace){
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}