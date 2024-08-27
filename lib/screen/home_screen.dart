import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/screen/add_note_screen.dart';
import 'package:note_app/screen/details_screen.dart';

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
                  print(note);
                  return Container(
                    margin: EdgeInsets.fromLTRB(8, index==0 ? 8 : 0, 8, 8),
                    width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade400
                        )
                      ),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DetailsScreen(id : note.id,title: note['title'], description: note['description'])));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(note['title'],style: const TextStyle(color: Colors.deepPurple,fontSize: 16,fontWeight: FontWeight.w700),),
                            const Divider(),
                            Text(note['description'],maxLines: 2)
                          ],
                        ),
                      ),
                    ),
                  );
                }
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddNoteScreen()));
          },
          elevation: 0.5,
          child: const Icon(Icons.add),
      ),
    );
  }
}
