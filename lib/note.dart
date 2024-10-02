class Note {
  final int? id;
  final String title;
  final String description;
  final List<String> imagePaths;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.imagePaths,
  });

  // Для преобразования в Map
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'imagePaths': imagePaths.join(','), // Сохранение пути изображений в виде строки
  };

  // Для создания объекта Note из Map
  factory Note.fromMap(Map<String, dynamic> map) => Note(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    imagePaths: (map['imagePaths'] as String).split(','),
  );

  // Метод copyWith для копирования с возможностью изменений
  Note copyWith({
    int? id,
    String? title,
    String? description,
    List<String>? imagePaths,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePaths: imagePaths ?? this.imagePaths,
    );
  }
}