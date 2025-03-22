import 'package:flutter/material.dart';
import 'package:getpass/Login/StudentLogin.dart';
import 'package:getpass/Login/TeacherLogin.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginOption extends StatelessWidget {
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.white,
     body: ListView(
       children: [
         Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
              const SizedBox(height: 100,),
             Padding(
               padding:  const EdgeInsets.all(5),
               child: Container(
                 height: 120,width: 120,
                 decoration: BoxDecoration(image:  const DecorationImage(image: AssetImage("assets/images/vvplogo.jpg"),fit: BoxFit.fill),
                 borderRadius: BorderRadius.circular(50)),
               ),
             ),
             Text("VVPPS Get Pass",style: GoogleFonts.audiowide(fontSize: 20),),
              const SizedBox(height: 30,),
             Text("Welcome to the College Get Pass application",style: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.5),fontWeight: FontWeight.w600),),
             // Text("Select your login type to proceed.",style: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.5),fontWeight: FontWeight.w600),),
              const SizedBox(height: 30,),
             Container(
               height: 55,width: 190,
               decoration: BoxDecoration(color:  const Color(0xff80C4E9),borderRadius: BorderRadius.circular(30)),
               child: TextButton(
                   child: Text("Login as Student",style: GoogleFonts.albertSans(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600)),
                   onPressed: (){
                     Navigator.push(context, MaterialPageRoute(builder: (builder){
                       return StudentLogin();
                     }));
                   }
               ),
             ),
              const SizedBox(height: 20,),
             Container(
               height: 55,width: 190,
               decoration: BoxDecoration(color:  const Color(0xff6A9C89),borderRadius: BorderRadius.circular(30)),
               child: TextButton(
                 child: Text("Login as Admin",style: GoogleFonts.albertSans(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600)),
                 onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (builder){
                     return Teacherlogin();
                   }));
                 },
               ),
             ),
             SizedBox(height: 90,),
             Text("Note",style: TextStyle(fontSize: 15,color: Colors.red.withOpacity(0.9),fontWeight: FontWeight.w600),),
             SizedBox(height: 8,),
             Text("This software is developed for only limited users.",style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.w600),),
             SizedBox(height: 5,),
             Text("Registration phase isn't available, to register your id please contact head of department.",textAlign: TextAlign.center,
               style: TextStyle(color: Colors.red.withOpacity(0.6),fontSize: 14,fontWeight: FontWeight.w600),),
             SizedBox(height: 7,),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Icon(Icons.call,color: Colors.black.withOpacity(0.5),size: 20,),
                 SizedBox(width: 8,),
                 Text("9356434349",style: TextStyle(fontSize: 15,color: Colors.blueAccent.withOpacity(0.6),fontWeight: FontWeight.w600),),
               ],
             )
           ],
         )
       ],
     ),
   );
  }

}