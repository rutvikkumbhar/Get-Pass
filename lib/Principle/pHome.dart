import 'package:flutter/material.dart';
import 'StafLeaveRequest.dart';

class pHome extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color:  Color(0xffDBE2EF),borderRadius: BorderRadius.circular(5)),
              child: ListTile(
                title:  Text("HODs Leaves Application",style: TextStyle(color: Colors.black,fontSize: 17),),
                subtitle:  Text("View HODs recent leave application"),
                trailing:  Icon(Icons.keyboard_arrow_right_outlined),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder){
                    return StafLeaverequest();
                  }));
                },
              ),
            ),
            SizedBox(height: 15,),
          ],
        ),
      )
    );
  }
}