import 'package:firebase_all/utils/utils.dart';
import 'package:firebase_all/view/auth/verify_code_screen.dart';
import 'package:firebase_all/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  final phoneNumberController = TextEditingController();
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
              controller: phoneNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "+1 234 4533 453",

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
              auth.verifyPhoneNumber(
                phoneNumber: phoneNumberController.text,
                  verificationCompleted: (_){
                    setState(() {
                      isLoading = false;
                    });
                  },
                  verificationFailed: (e){
                    setState(() {
                      isLoading = false;
                    });
                  Utils.toastMessage(e.toString());
                  },
                  // when firebase will send and code there will be a verification id and second thing is token
// through verifId user will be verified and token will be taken at frontend and both will be combined
                  codeSent: (String verificationId, int? token){  // token => 6 digit code
                    setState(() {
                      isLoading = false;
                    });
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => VerifyCodeScreen(verificationId: verificationId,)));
                  },
                  codeAutoRetrievalTimeout: (e){
                    setState(() {
                      isLoading = false;
                    });
                  Utils.toastMessage(e.toString());
                  });
            }),
            
          ],
        ),
      ),
    );
  }
}


