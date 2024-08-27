import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/screen/add_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot> _notesStream = FirebaseFirestore.instance.collection('notes').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: Colors.grey.shade200,
      ),
      body: StreamBuilder(
          stream: _notesStream,
          builder: (BuildContext contex, AsyncSnapshot<QuerySnapshot> snapshot){
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                  var note = snapshot.data!.docs[index];
                  return ListTile(
                    title: Text(note['title']),
                    subtitle: Text(note['description']),
                  );
                }
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddNoteScreen()));
          },
          elevation: 0,
          child: const Icon(Icons.add),
      ),
    );
  }
}
