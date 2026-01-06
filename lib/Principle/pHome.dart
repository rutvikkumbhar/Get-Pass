import 'package:flutter/material.dart';
import 'package:getpass/Principle/TeaLeaveRequest.dart';
import 'StafLeaveRequest.dart';

class pHome extends StatelessWidget {
  const pHome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color:  const Color(0xffDBE2EF),borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                title:  const Text("HODs Leaves Application",style: TextStyle(color: Colors.black,fontSize: 17),),
                subtitle:  const Text("View HODs recent leave application"),
                trailing:  const Icon(Icons.keyboard_arrow_right_outlined),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder){
                    return StafLeaverequest();
                  }));
                },
              ),
            ),
            const SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color:  const Color(0xffDBE2EF),borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                title:  const Text("Admin/Staff Leaves Application",style: TextStyle(color: Colors.black,fontSize: 17),),
                subtitle:  const Text("View staff recent leave application"),
                trailing:  const Icon(Icons.keyboard_arrow_right_outlined),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder){
                    return TeaLeaveRequest();
                  }));
                },
              ),
            ),
            const SizedBox(height: 15,),
          ],
        ),
      )
    );
  }
}