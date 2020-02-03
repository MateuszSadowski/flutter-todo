import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_todo/todo.dart';
import 'package:flutter_todo/todos.dart';

void main() => runApp(MyApp());

class MyApp extends HookWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = useMemoized(() => Todos());

    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        body: Observer(
          builder: (_) => ListView.builder(
            itemBuilder: (context, index) {
              final todo = model.todos[index];
              return TodoCell(
                todo: todo,
                onRemove: () => model.removeTodo(todo),
                onToggle: () => model.toggleTodo(todo),
              );
            },
            itemCount: model.todos.length,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            model.addTodo(
                Todo((model.todos.length + 1).toString(), "New todo", false));
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

class TodoCell extends HookWidget {
  TodoCell({
    @required this.todo,
    @required this.onRemove,
    @required this.onToggle,
  });

  final Todo todo;
  final Function() onRemove;
  final Function() onToggle;

  @override
  Widget build(BuildContext context) {
    // final opacity = useState(0.0);

    return Dismissible(
      key: Key(todo.id),
      child: ListTile(
        leading: Text(todo.id),
        title: Text(todo.title),
        trailing: Observer(
          builder: (_) => Checkbox(
            value: todo.completed,
            onChanged: (bool value) => onToggle(),
          ),
        ),
      ),
      onDismissed: (d) => onRemove(),
    );
  }
}
