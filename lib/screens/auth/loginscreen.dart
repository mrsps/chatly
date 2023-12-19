import 'dart:developer';
import 'dart:io';

import 'package:chatly/api/apis.dart';
import 'package:chatly/helper/dialogs.dart';
import 'package:chatly/screens/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../main.dart';

class loginscreen extends StatefulWidget {
  const loginscreen({super.key});

  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  bool _isAnimate = false;
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(milliseconds: 500),(){
      setState(() {
        _isAnimate = true;
      });
    });
  }
  _handleGoogleBtnClick(){
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if(user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');
        if((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const homescreen()));
        }else {
          await APIs.createUser().then((value){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const homescreen()));
          });
        }
      }
    });
  }
  Future<UserCredential?> _signInWithGoogle() async {
   try {
     await InternetAddress.lookup('google.com');
     // Trigger the authentication flow
     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

     // Obtain the auth details from the request
     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

     // Create a new credential
     final credential = GoogleAuthProvider.credential(
       accessToken: googleAuth?.accessToken,
       idToken: googleAuth?.idToken,
     );

     // Once signed in, return the UserCredential
     return await APIs.auth.signInWithCredential(credential);
   } catch (e) {
     log('\n_signInWithGoogle: $e');
     Dialogs.showSnackbar(context, 'Something Went Wrong (Check Internet)');
     return null;
   }
  }
  @override
  Widget build(BuildContext context) {
   // mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome To Chatly'),

      ),
     body: Stack(children: [
       AnimatedPositioned(
           top:mq.height * .15,
           width:mq.width * .5,
           right: _isAnimate ? mq.width * .25 : -mq.width * .5,
           duration: Duration(seconds: 1),
           child: Image.asset('images/icon.png')),
       Positioned(
           bottom:mq.height * .15,
           width:mq.width * .9,
           left: mq.width * .05,
           height: mq.height * .06,
           child: ElevatedButton.icon(onPressed: (){
             _handleGoogleBtnClick();
           },
               icon: Image.asset('images/google.png',
                   height:mq.height * .04),
               label: Text('Login with Google', style:TextStyle(fontSize: 20)))),
     ]),

    );
  }
}
