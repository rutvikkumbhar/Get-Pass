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
              SizedBox(height: 130,),
             Padding(
               padding:  EdgeInsets.all(5),
               child: Container(
                 height: 120,width: 120,
                 decoration: BoxDecoration(image:  DecorationImage(image: AssetImage("assets/images/vvplogo.jpg"),fit: BoxFit.fill),
                 borderRadius: BorderRadius.circular(50)),
               ),
             ),
             Text("College Get Pass",style: GoogleFonts.audiowide(fontSize: 20),),
              SizedBox(height: 30,),
             Text("Welcome to the College Get Pass app.",style: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.5),fontWeight: FontWeight.w600),),
             Text("Select your login type to proceed.",style: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.5),fontWeight: FontWeight.w600),),
              SizedBox(height: 30,),
             Container(
               height: 55,width: 190,
               decoration: BoxDecoration(color:  Color(0xffF26B0F),borderRadius: BorderRadius.circular(30)),
               child: TextButton(
                   child: Text("Login as Student",style: GoogleFonts.albertSans(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600)),
                   onPressed: (){
                     Navigator.push(context, MaterialPageRoute(builder: (builder){
                       return StudentLogin();
                     }));
                   }
               ),
             ),
              SizedBox(height: 20,),
             Container(
               height: 55,width: 190,
               decoration: BoxDecoration(color:  Color(0xff80C4E9),borderRadius: BorderRadius.circular(30)),
               child: TextButton(
                 child: Text("Login as Teacher",style: GoogleFonts.albertSans(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600)),
                 onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (builder){
                     return Teacherlogin();
                   }));
                 },
               ),
             )
           ],
         )
       ],
     ),
   );
  }

}