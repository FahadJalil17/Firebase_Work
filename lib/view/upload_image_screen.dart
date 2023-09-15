import 'dart:io';
import 'package:firebase_all/utils/utils.dart';
import 'package:firebase_all/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  // when we pick image from gallery it is in file form
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');
  bool isLoading = false;
  
  Future getGalleryImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
   setState(() {
     if(pickedFile != null){
       _image = File(pickedFile.path); // adding path for _image which user pick from gallery
     }
     else{
       Utils.toastMessage("No Image Picked");
     }
   });
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Upload Image Screen"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: (){
                  getGalleryImage();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                  child: _image != null ? Image.file(_image!.absolute) :
                  Center(child: Icon(Icons.image)),
                ),
              ),
            ),

            SizedBox(height: 30,),

            RoundButton(
                title: "Upload Image",
                loading: isLoading,
                onTap: () async{
              setState(() {
                isLoading = true;
              });

//  must add 2 slashs / with folder name and 2nd one is file name
            firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/foldername/' + DateTime.now().millisecondsSinceEpoch.toString());
            // upload task will provide url for an image
              firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);
              Future.value(uploadTask).then((value) async{
              var newUrl = await ref.getDownloadURL();


              databaseRef.child('1').set({
                'id' : '1231',
                'title' : newUrl.toString(),
              }).then((value){
                setState(() {
                  isLoading = false;
                });
                Utils.toastMessage("Uploaded");
              }).onError((error, stackTrace){
                setState(() {
                  isLoading = false;
                });
                Utils.toastMessage(error.toString());
              });

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

