import 'package:flutter/material.dart';
import 'dart:io';
import 'note.dart';
import 'note_database.dart';
import 'package:image_picker/image_picker.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  EditNoteScreen({required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _descriptionController = TextEditingController(text: widget.note.description);
    _loadImages();
  }

  void _loadImages() {
    // Загружаем существующие изображения
    _images = widget.note.imagePaths.map((path) => File(path)).toList();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      return;
    }

    List<String> imagePaths = _images.map((file) => file.path).toList();

    // Обновляем заметку
    Note updatedNote = widget.note.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      imagePaths: imagePaths,
    );
    await NoteDatabase.instance.update(updatedNote);

    Navigator.of(context).pop(); // Возвращаемся на предыдущий экран
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Редактировать заметку')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Поле для редактирования заголовка
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Заголовок',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Поле для редактирования содержания
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Содержание',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20),
            // Отображение и добавление изображений
            Wrap(
              spacing: 8.0,
              children: _images.map((image) {
                return Stack(
                  children: [
                    Image.file(image, width: 100, height: 100, fit: BoxFit.cover),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _images.remove(image); // Удаление изображения
                          });
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Добавить изображение'),
            ),
            SizedBox(height: 20),
            // Кнопка сохранения изменений
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Сохранить изменения'),
            ),
          ],
        ),
      ),
    );
  }
}