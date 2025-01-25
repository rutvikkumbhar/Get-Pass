import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Help extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Help"),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.only(left: 15,right: 15),
        child: ListView(
          children: [
             SizedBox(height: 10,),
            Text("Welcome to the Get Pass App Help Center!",style: GoogleFonts.alice(fontSize: 22)),
            Text("Here, you'll find answers to common questions and guidance on using the app efficiently.",
            style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15),),
             SizedBox(height: 25,),
            Container(
              height: 1,width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.1),
            ),
             SizedBox(height: 25,),
            Text("Frequently Asked Questions (FAQs)",style: GoogleFonts.alegreyaSansSc(fontSize: 20,fontWeight: FontWeight.w400),),
             ListTile(
              title: Text("Q1: How do I know if my leave request is approved?"),
              subtitle: Text("You will receive a notification when your request is approved or rejected."),
            ),
             SizedBox(height: 5,),
             ListTile(
              title: Text("Q2: Can I edit a submitted leave request?"),
              subtitle: Text("No, you cannot edit a request once submitted. Please contact your Class Teacher or HOD for corrections."),
            ),
             SizedBox(height: 5,),
             ListTile(
              title: Text("Q3: Is my feedback truly anonymous?"),
              subtitle: Text("Yes, your identity will not be shown to anyone, including the HOD or CC."),
            ),
             SizedBox(height: 25,),
            Container(
              height: 1,width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.1),
            ),
             SizedBox(height: 25,),
            Text("Contact Support",style: GoogleFonts.alegreyaSansSc(fontSize: 20,fontWeight: FontWeight.w400),),
            Text("Still need help? Contact us!",
              style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 14),),
             ListTile(
              title: Text("Email: support@getpass.com"),
              leading: Icon(Icons.alternate_email_rounded,size: 22,color: Color(0xff3F72AF),),
            ),
             ListTile(
              title: Text("Phone: +91 96991 69711"),
              leading: Icon(Icons.call_outlined,size: 22,color: Color(0xff3F72AF),),
            ),
          ],
        ),
      ),
    );
  }

}