import 'package:firebase_all/utils/utils.dart';
import 'package:firebase_all/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  bool isLoading = false;
  final postController = TextEditingController();
  // post is just like table in sql & it is node in firebase
  final databaseRef = FirebaseDatabase.instance.ref("Post");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
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
                  // using dateTime for unique ids
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
              databaseRef.child(id).set({  // set is used to add data
                'id' : id,
                'title' : postController.text.toString(),
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

