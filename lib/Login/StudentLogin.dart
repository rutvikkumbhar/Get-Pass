import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:getpass/StudentModules/StudBottomNav.dart';
import 'package:getpass/Errro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentLogin extends StatefulWidget {
  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {

  final FirebaseAuth _auth=FirebaseAuth.instance;
  CollectionReference ref=FirebaseFirestore.instance.collection('Students');
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
                 decoration: BoxDecoration(image: const DecorationImage(image: AssetImage("assets/images/studentpfp.png"),fit: BoxFit.fill),
                     borderRadius: BorderRadius.circular(60)),
               ),
             ),
             const SizedBox(height: 3,),
             Text("Student Login",style: GoogleFonts.albertSans(fontSize: 22, fontWeight: FontWeight.w600),),
             const SizedBox(height: 30,),
             Padding(
               padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
               child: TextFormField(
                 keyboardType: TextInputType.emailAddress,
                 decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),hintText: "Email ID",border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),
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
                 decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),hintText: "Password",border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),
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
               decoration: BoxDecoration(color: const Color(0xffF26B0F),borderRadius: BorderRadius.circular(30)),
               child: TextButton(
                 child: load?const CircularProgressIndicator(color: Colors.white,)
                            :Text("Login",style: GoogleFonts.albertSans(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w700),),
                 onPressed: () async {
                   setState(() {
                     load=true;
                   });
                   if(_key.currentState!.validate()) {
                     await _auth.signInWithEmailAndPassword(
                       email: emailController.text.toString(),
                       password: passController.text.toString()
                     ).then((onValue) async {
                       DocumentSnapshot docData=await ref.doc(_auth.currentUser!.uid.toString()).get();
                       Map<String, dynamic> data=docData.data() as Map<String, dynamic>;
                       if(emailController.text.toString()==data['email'] && passController.text.toString() ==data['password']) {
                         String? token=await FirebaseMessaging.instance.getToken();
                         await ref.doc(_auth.currentUser!.uid).update({
                           'fcmToken':token.toString()
                         });
                         Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => StudBottomNav()),
                               (Route<dynamic> route) => false,);
                       } else {
                         Error().toastMessage("Invalid Email ID and Password");
                         setState(() {
                           load=false;
                         });
                         _auth.signOut();
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