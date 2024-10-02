import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'note.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();

  static Database? _database;

  NoteDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    return await openDatabase(
      join(await getDatabasesPath(), filePath),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            imagePaths TEXT
          )
        ''');
      },
    );
  }

  Future<void> update(Note note) async {
    final db = await instance.database;

    await db.update(
      'notes',
      {
        'title': note.title,
        'description': note.description,
        'imagePaths': note.imagePaths.join(','), // Преобразуем список путей в строку
      },
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }


  Future<void> create(Note note) async {
    final db = await instance.database;
    await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getAllNotes() async {
    final db = await instance.database;
    final maps = await db.query('notes');
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  Future<void> delete(int id) async {
    final db = await instance.database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
