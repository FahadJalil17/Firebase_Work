import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_all/firestore/add_firestore_data.dart';
import 'package:firebase_all/utils/utils.dart';
import 'package:firebase_all/view/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({Key? key}) : super(key: key);

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final _auth = FirebaseAuth.instance;
  Random random = Random();
  final editController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();  // it returns query snapshots
  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("FireStore"),
        actions: [
          IconButton(onPressed: (){
            _auth.signOut().then((value){
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              Utils.toastMessage("Logged Out");
            }).onError((error, stackTrace){
              Utils.toastMessage(error.toString());
            });
          }, icon: Icon(Icons.logout_outlined)),
          SizedBox(width: 10,)
        ],
      ),

      body: Column(
        children: [
          SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();

                else if(snapshot.hasError)
                  return Text("Some Error");

            return  Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      final title = snapshot.data!.docs[index]['title'].toString();
                      return Card(
                        color: Color.fromRGBO(random.nextInt(256), random.nextInt(256), random.nextInt(256), .6),
                        child: ListTile(
                          // onTap: (){
                          //   // through id we will update and delete data in firestore
                          //   ref.doc(snapshot.data!.docs[index]['id'].toString()).update(
                          //       {
                          //         'title' : 'Hello subscribe plz',
                          //       });
                          // },

                          // title: Text(snapshot.data!.docs[index]['title'].toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                          title: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                          subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                                child: ListTile(
                                  title: Text("Edit"),
                              leading: Icon(Icons.edit),
                              onTap: (){
                                Navigator.pop(context);
                                showMyDialog(title, snapshot.data!.docs[index]['id'].toString());
                              },
                            )),

                              PopupMenuItem(
                                  value: 2,
                                  child: ListTile(
                                title: Text("Delete"),
                                    leading: Icon(Icons.delete),
                                    onTap: (){
                                  Navigator.pop(context);
                                  ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                                    },
                              ))
                          ],

                          ),
                        ),
                      );
                    })
            );
          }),

        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddFireStoreDataScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async{
    editController.text = title;
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Update"),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(
                    hintText: "Edit"
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel")),
              TextButton(onPressed: (){
                Navigator.pop(context);
                ref.doc(id).update({
                  'title' : editController.text.toString(),
                }).then((value){
                  Utils.toastMessage("Updated");
                }).onError((error, stackTrace){
                  Utils.toastMessage(error.toString());
                });
              }, child: Text("Update")),
            ],
          );
        });
  }

}
