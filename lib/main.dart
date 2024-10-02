import 'package:flutter/material.dart';
import 'note_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Заметки с изображениями',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteListScreen(), // Экран списка заметок
    );
  }
}
