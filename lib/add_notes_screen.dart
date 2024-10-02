import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'note_database.dart';
import 'note.dart';
import 'package:image/image.dart' as img;

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<File> _images = [];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      for (var pickedFile in pickedFiles) {
        File imageFile = File(pickedFile.path);
        File compressedImage = await _compressImage(imageFile);
        setState(() {
          _images.add(compressedImage);
        });
      }
    }
  }

  Future<File> _compressImage(File file) async {
    final rawImage = img.decodeImage(await file.readAsBytes())!;
    final resizedImage = img.copyResize(rawImage, width: 600);
    final compressedImage =
    File(file.path)..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85));
    return compressedImage;
  }

  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      return;
    }

    List<String> imagePaths = _images.map((file) => file.path).toList();
    Note newNote = Note(
      title: _titleController.text,
      description: _descriptionController.text,
      imagePaths: imagePaths,
    );
    await NoteDatabase.instance.create(newNote);

    Navigator.of(context).pop(); // Вернуться на главный экран
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Добавить заметку')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Заголовок'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Описание'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              children: _images
                  .map((image) => Image.file(image, width: 100, height: 100, fit: BoxFit.cover))
                  .toList(),
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Добавить изображения'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Сохранить заметку'),
            ),
          ],
        ),
      ),
    );
  }
}
