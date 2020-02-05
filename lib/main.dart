import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_todo/todo.dart';
import 'package:flutter_todo/todo_list.dart';
import 'package:flutter_todo/todos.dart';

void main() => runApp(MyApp());

class MyApp extends HookWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = useMemoized(() => Todos());
    final scrollController = useMemoized(() => ScrollController());

    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        body: TodoList(scrollController: scrollController, model: model),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Todo todo = Todo(
                (model.todos.length + 1).toString(), "New todo", true, false);
            model.addTodo(todo);
            model.setFocused(todo);
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            title: Text("Todos"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Settings"),
          ),
        ]),
      ),
    );
  }
}
