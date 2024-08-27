import 'package:flutter/material.dart';
import 'package:note_app/screen/home_screen.dart';

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
