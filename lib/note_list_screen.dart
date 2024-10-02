import 'package:flutter/material.dart';
import 'add_notes_screen.dart';
import 'note_database.dart';
import 'note.dart';
import 'edit_note_screen.dart'; // Экран для редактирования заметки

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await NoteDatabase.instance.getAllNotes();
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _deleteNote(int id) async {
    await NoteDatabase.instance.delete(id);
    _loadNotes(); // Обновить список заметок
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Заметки')),
      body: _notes.isEmpty
          ? Center(child: Text('Нет заметок'))
          : ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                note.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                note.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditNoteScreen(note: note),
                )).then((_) {
                  _loadNotes(); // Обновляем список при возвращении
                });
              },
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await _deleteNote(note.id!);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          ).then((_) {
            _loadNotes(); // Обновляем список при возвращении с экрана добавления
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}