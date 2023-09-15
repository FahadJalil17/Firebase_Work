import 'dart:math';

import 'package:firebase_all/utils/utils.dart';
import 'package:firebase_all/view/auth/login_screen.dart';
import 'package:firebase_all/view/posts/add_posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("Post"); // Table name must be same
  Random random = Random();
  final searchFilterController = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Post Screen"),
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
          // // Showing Data with stream Builder
          // Expanded(child: StreamBuilder(
          //   builder: (context, AsyncSnapshot<DatabaseEvent> snapshot){
          //     if(!snapshot.hasData){
          //       return CircularProgressIndicator();
          //     }
          //     else{
          //       Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
          //       List<dynamic> list = [];
          //       list.clear();
          //       list = map.values.toList();
          //       return ListView.builder(
          //           itemCount: snapshot.data!.snapshot.children.length,
          //           itemBuilder: (context, index){
          //             return ListTile(
          //               title: Text(list[index]['title']),
          //               subtitle: Text(list[index]['id']),
          //             );
          //           });
          //     }
          //
          //   },
          // )),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchFilterController,
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder()
              ),
              onChanged: (String value){
                setState(() {

                });
              },
            ),
          ),

          // Showing Data with Firebase Animated List

          Expanded(
            child: FirebaseAnimatedList(
                defaultChild: Text("Loading"),
                query: ref, // reference from which we will fetch data
                itemBuilder: (context, snapshot, animation, index){

                  final title = snapshot.child('title').value.toString();

                  if(searchFilterController.text.isEmpty){
                    return Card(
                      color: Color.fromRGBO(random.nextInt(256), random.nextInt(256), random.nextInt(256), .5),
                      child: ListTile(
                        title: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        subtitle: Text(snapshot.child('id').value.toString()),

                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  onTap: (){
                                    Navigator.pop(context);
                                    showMyDialog(title, snapshot.child('id').value.toString());
                                  },
                              leading: Icon(Icons.edit),
                                  title: Text("Edit"),
                            )),

                            PopupMenuItem(
                                value: 2,
                                child: ListTile(
                                  onTap: (){
                                    Navigator.pop(context);
                                    ref.child(snapshot.child('id').value.toString()).remove();
                                  },
                              leading: Icon(Icons.delete),
                                  title: Text("Delete"),
                            ))
                          ],

                        ),
                      ),
                    );
                  }
                  else if(title.toLowerCase().contains(searchFilterController.text.toLowerCase())){
                    return Card(
                      color: Color.fromRGBO(random.nextInt(256), random.nextInt(256), random.nextInt(256), .5),
                      child: ListTile(
                        title: Text(snapshot.child('title').value.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        subtitle: Text(snapshot.child('id').value.toString()),
                      ),
                    );
                  }
                  else{
                    return Container();
                  }


            }),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostScreen()));
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
            ref.child(id).update({ // through id we will update title
              'title': editController.text.toString(),
            }).then((value){
              Utils.toastMessage("Updated Successfully");
            }).onError((error, stackTrace){
              Utils.toastMessage(error.toString());
            });
          }, child: Text("Update")),
        ],
      );
    });
  }

}
