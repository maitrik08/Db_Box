import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:db_box/Controller/todoController.dart';
import 'package:db_box/Model/todoModel.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkTheme;

  HomeScreen({required this.onThemeChanged, required this.isDarkTheme});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _fetchTodosFuture;
  bool _showBookmarked = false;

  @override
  void initState() {
    super.initState();
    _fetchTodosFuture = Provider.of<TodoController>(context, listen: false).fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    final todoController = Provider.of<TodoController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('TODO List'),
        actions: [
          IconButton(
            icon: Icon(_showBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () {
              setState(() {
                _showBookmarked = !_showBookmarked;
              });
            },
          ),
          Switch(
            value: widget.isDarkTheme,
            onChanged: (value) {
              widget.onThemeChanged(value);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fetchTodosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching TODOs: ${snapshot.error}'));
          } else {
            final todos = _showBookmarked
                ? todoController.getBookmarkedTodos()
                : todoController.todos;

            if (todos.isEmpty) {
              return Center(
                child: Text(
                  _showBookmarked ? 'No bookmarked TODOs available' : 'No TODOs available',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: ListTile(
                      title: Text(todo.title, style: TextStyle(fontSize: 18)),
                      subtitle: Text(todo.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(todo.isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                            onPressed: () {
                              setState(() {
                                todo.isBookmarked = !todo.isBookmarked;
                              });
                              todoController.updateTodo(todo);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Delete TODO'),
                                    content: Text('Are you sure you want to delete this TODO?'),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text('Delete'),
                                        onPressed: () {
                                          todoController.deleteTodo(todo.id!);
                                          Navigator.pop(context);
                                          setState(() {
                                            _fetchTodosFuture = todoController.fetchTodos();
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // Edit TODO logic can go here
                      },
                    ),
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddTodoDialog(context);
        },
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add TODO'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(hintText: 'Title'),
                autofocus: true,
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(hintText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                final title = _titleController.text.trim();
                final description = _descriptionController.text.trim();

                if (title.isNotEmpty) {
                  final todo = Todo(
                    title: title,
                    description: description,
                    isBookmarked: false,
                  );
                  Provider.of<TodoController>(context, listen: false).addTodo(todo);
                  Navigator.pop(context);
                  setState(() {
                    _fetchTodosFuture = Provider.of<TodoController>(context, listen: false).fetchTodos();
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Title cannot be empty')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
