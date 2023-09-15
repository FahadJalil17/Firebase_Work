import 'package:firebase_all/utils/utils.dart';
import 'package:firebase_all/view/posts/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  String verificationId;
  VerifyCodeScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final verifyCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login With Phone Number"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 80,),
            TextFormField(
              controller: verifyCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter 6 Digit Code",

              ),
            ),

            SizedBox(height: 80,),

            RoundButton(
                title: "Login With Phone Number",
                loading: isLoading,
                onTap: (){
                  setState(() {
                    isLoading = true;
                  });
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: verifyCodeController.text.toString());
                  try{
                    auth.signInWithCredential(credential);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));
                  }catch(e){
                    setState(() {
                      isLoading = false;
                    });
                    Utils.toastMessage(e.toString());
                  }

                }),

          ],
        ),
      ),
    );
  }

}


