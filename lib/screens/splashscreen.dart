import 'dart:developer';

import 'package:chatly/api/apis.dart';
import 'package:chatly/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'auth/loginscreen.dart';


import '../../main.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {

  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000),(){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: Colors.white));
      if(APIs.auth.currentUser != null){
        log('\nUser: ${APIs.auth.currentUser}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => homescreen()));
      }else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => loginscreen()));
      }

    });
  }
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome To Chatly'),


      ),
      body: Stack(children: [
        Positioned(
            top:mq.height * .15,
            width:mq.width * .5,
            right:mq.width * .25,
            child: Image.asset('images/icon.png')),
        Positioned(
            bottom:mq.height * .15,
            width:mq.width,
            child: Center(
                child: const Text('Sahib Rishikesh Ishita Palak GTBIT CSE-2',
                  style: TextStyle(fontSize: 20,color: Colors.deepPurple),)) ),
      ]),

    );
  }
}