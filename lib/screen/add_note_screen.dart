import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNoteScreen extends StatelessWidget {
  AddNoteScreen({super.key});

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Add new note'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ElevatedButton(
                  onPressed: (){
                    if(formKey.currentState!.validate()){
                      notes.add({
                        'title' : titleController.text,
                        'description' : descriptionController.text
                      })
                          .then((value)=>ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note Created.'))))
                          .catchError((error) => print("Failed to add user: $error"));
                      titleController.clear();
                      descriptionController.clear();
                    }
                  },
                  child: const Text('Save')
              ),
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Title is required.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Title'
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: descriptionController,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Description is required.';
                    }
                    return null;
                  },
                  maxLines: null,
                  decoration: const InputDecoration(
                      labelText: 'Description'
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
