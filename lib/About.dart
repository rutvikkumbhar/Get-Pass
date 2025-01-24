import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  final Uri uri = Uri.parse('https://www.google.com/');

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: ListView(
          children: [
            Text("Welcome to the Get Pass App!",style: GoogleFonts.alice(fontSize: 22)),
            Text("The Get Pass App is an open-source project designed to simplify and enhance the leave management process for students, teachers, and HODs at V.V.P Polytechnic, Soregaon. This app serves as a comprehensive platform to manage leave requests, provide feedback, and streamline communication within the college.",
              style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15),textAlign: TextAlign.justify,),
            const SizedBox(height: 25,),
            Container(
              height: 1,width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.1),
            ),
            const SizedBox(height: 25,),
            Text("Project Origins",style: GoogleFonts.alegreyaSansSc(fontSize: 20,fontWeight: FontWeight.w400),),
            Text("This app was developed as an open-source project exclusively for V.V.P Polytechnic. It was designed and developed by a single student from the Computer Engineering Department, showcasing the talent and dedication of our college's budding engineers.",
              style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15),textAlign: TextAlign.justify,),
            const SizedBox(height: 25,),
            Container(
              height: 1,width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.1),
            ),
            const SizedBox(height: 25,),
            Text("Contribute to the Project",style: GoogleFonts.alegreyaSansSc(fontSize: 20,fontWeight: FontWeight.w400),),
            Text("As an open-source initiative, we welcome contributions from the community to make this app even better. For more details, visit our:",
              style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15),textAlign: TextAlign.justify,),
            GestureDetector(
              child: Text("$uri",style: const TextStyle(color: Color(0xff769FCD),fontSize: 15,fontWeight: FontWeight.w500),),
              onTap: () async {
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  throw 'Could not launch $uri';
                }
              },
            ),
            const SizedBox(height: 25,),
            Container(
              height: 1,width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.1),
            ),
            const SizedBox(height: 25,),
            Text("About the Developer",style: GoogleFonts.alice(fontSize: 20),),
            Text("This app was designed and developed by Rutvik Kumbhar, a student of Computer Engineering at V.V.P Polytechnic. ",
              style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15),textAlign: TextAlign.justify,),
            const SizedBox(height: 25,),
            Container(
              height: 1,width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.1),
            ),
            const SizedBox(height: 25,),
            Text("Message from the Developer",style: GoogleFonts.alice(fontSize: 20),),
            Text("\"Creating this app was a journey of learning and innovation. My goal was to contribute something meaningful to my college community while honing my technical skills. I hope this app brings value to its users and inspires others to embark on similar projects.\"",
              style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 15,fontStyle: FontStyle.italic),textAlign: TextAlign.justify,),
            const SizedBox(height: 25,),
            const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Version: 1.0.0 | Open Source"),
                Text("Developer: Rutvik Kumbhar"),
                Text("Contact: support@getpass.com"),
              ],
            ),
            const SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }
}