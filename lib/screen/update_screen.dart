import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  const UpdateScreen({super.key, required this.id, required this.title, required this.description});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  @override
  void initState() {
   titleController.text = widget.title;
   descriptionController.text = widget.description;
    super.initState();
  }

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
                    notes.doc(widget.id).update({
                        'title' : titleController.text,
                        'description' : descriptionController.text
                    })
                        .then((value) {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Successfully updated.')));
                        })
                        .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Update Failed'))));
                  }
                },
                child: const Text('Update')
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
