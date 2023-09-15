import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_all/utils/utils.dart';
import 'package:firebase_all/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddFireStoreDataScreen extends StatefulWidget {
  const AddFireStoreDataScreen({Key? key}) : super(key: key);

  @override
  State<AddFireStoreDataScreen> createState() => _AddFireStoreDataScreenState();
}

class _AddFireStoreDataScreenState extends State<AddFireStoreDataScreen> {

  bool isLoading = false;
  final postController = TextEditingController();
  // collection is just like table in sql
  final fireStore = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add FireStore Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            SizedBox(height: 30,),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "What's in your mind ?",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 30,),
            RoundButton(
                title: 'Add',
                loading: isLoading,
                onTap: (){
                  setState(() {
                    isLoading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  fireStore.doc(id).set({
                    'title' : postController.text.toString(),
                    'id' : id,
                  }).then((value){
                    setState(() {
                      isLoading = false;
                    });
                    Utils.toastMessage("Post Added");
                  }).onError((error, stackTrace){
                    setState(() {
                      isLoading = false;
                    });
                    Utils.toastMessage(error.toString());
                  });
                  
                }),

          ],
        ),
      ),
    );
  }
}
