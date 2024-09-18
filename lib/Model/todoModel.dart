import 'package:db_box/Helper/databaseHelper.dart';

class Todo {
  int? id;
  String title;
  String description;
  bool isBookmarked;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.isBookmarked,
  });

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnTitle: title,
      DatabaseHelper.columnDescription: description,
      DatabaseHelper.columnIsBookmarked: isBookmarked ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map[DatabaseHelper.columnId] as int?,
      title: map[DatabaseHelper.columnTitle] as String,
      description: map[DatabaseHelper.columnDescription] as String,
      isBookmarked: (map[DatabaseHelper.columnIsBookmarked] as int) == 1,
    );
  }
}
