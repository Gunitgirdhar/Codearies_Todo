import 'dart:async';

import 'package:flutter/material.dart';

import 'Page_01.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTasksPage(),));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Notes App",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
          SizedBox(height: 30,),
          Container(

              height: 100,
              width: 100,
              child: Image.asset("assets/images/note.png",fit: BoxFit.fill,)),
        ],
      ),),
    );
  }
}
