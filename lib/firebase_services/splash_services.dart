import 'dart:async';

import 'package:firebase_all/firestore/firestore_list_screen.dart';
import 'package:firebase_all/view/auth/login_screen.dart';
import 'package:firebase_all/view/upload_image_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../view/posts/post_screen.dart';

class SplashServices{
  void isLogin(BuildContext context){

    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    // user already Login
    if(user != null){
      Timer(Duration(seconds: 3), (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));
        // Navigator.push(context, MaterialPageRoute(builder: (context) => UploadImageScreen()));
      });
    }
    else{
      Timer(Duration(seconds: 3), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }

  }
}

