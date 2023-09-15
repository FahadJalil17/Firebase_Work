import 'package:firebase_all/utils/utils.dart';
import 'package:firebase_all/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Enter Email",
                border: OutlineInputBorder()
              ),
            ),

            SizedBox(height: 30,),
            RoundButton(
              title: 'Forgot',
              loading: isLoading,
              onTap: () {
                setState(() {
                  isLoading = true;
                });
              _auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value){
                setState(() {
                  isLoading = false;
                });
                Utils.toastMessage("we have sent you email to recover password please check email");
              }).onError((error, stackTrace){
                setState(() {
                  isLoading = false;
                });
                Utils.toastMessage(error.toString());
              });
            },

            )

          ],
        ),
      ),
    );
  }
}
