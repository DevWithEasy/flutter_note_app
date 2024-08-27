import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/screen/update_screen.dart';

class DetailsScreen extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  DetailsScreen({super.key, required this.id,required this.title, required this.description});

  CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpdateScreen(id: id, title: title, description: description)));
              }, 
              icon: const Icon(Icons.edit)
          ),
          IconButton(
              onPressed: (){
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('It will be deleted permanently.It cant back.'),
                    actions: [
                      ElevatedButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,
                              foregroundColor: Colors.grey.shade900
                          ),
                          child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                          onPressed: (){
                            notes.doc(id).delete()
                                .then((value){
                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                })
                                .catchError((error){
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delete Failed')));
                                });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade50,
                              foregroundColor: Colors.red
                          ),
                          child: const Text('Delete'),
                      ),
                    ],
                  );
                });
              },
              icon: const Icon(Icons.delete)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(description),
        ),
      ),
    );
  }
}
