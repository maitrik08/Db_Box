import 'package:db_box/Helper/databaseHelper.dart';
import 'package:db_box/Model/todoModel.dart';
import 'package:flutter/material.dart';

class TodoController with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<void> fetchTodos() async {
    print('Fetching todos...');
    _todos = await DatabaseHelper.instance.queryAllTodos();
    print('Todos fetched: ${_todos.length}');
    notifyListeners();
  }


  Future<void> addTodo(Todo todo) async {
    await DatabaseHelper.instance.insert(todo);
    fetchTodos();
  }

  Future<void> updateTodo(Todo todo) async {
    await DatabaseHelper.instance.update(todo);
    fetchTodos();
  }

  Future<void> deleteTodo(int id) async {
    await DatabaseHelper.instance.delete(id);
    fetchTodos();
  }
  List<Todo> getBookmarkedTodos() {
    return _todos.where((todo) => todo.isBookmarked).toList();
  }
}
