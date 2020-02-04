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
    final scrollController = ScrollController();

    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        body: Observer(
          builder: (_) => ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              final todo = model.todos[index];
              return TodoCell(
                todo: todo,
                onRemove: () => model.removeTodo(todo),
                onToggle: () => model.toggleTodo(todo),
                onEdit: (value) => model.editTodoTitle(todo, value),
                onSubmit: () => model.focusOff(todo),
                onTap: () => model.setFocused(todo),
              );
            },
            itemCount: model.todos.length,
          ),
        ),
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

// Example:
// class SomeWidget extends StatefulWidget {
//   SomeWidget({Key key}) : super(key: key);

//   @override
//   _SomeWidgetState createState() => _SomeWidgetState();
// }

// class _SomeWidgetState extends State<SomeWidget> {
//   int x = 0; // 1

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(this.x.toString()),
//         RaisedButton(onPressed: () {
//           setState(() {
//             x = x + 1;
//           });
//         }),
//       ],
//     );
//   }
// }

// class SomeHookWidget extends HookWidget {
//   const SomeHookWidget({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final x = useState(0);

//     useEffect(() {
//       print("Initialize");
//       return () {
//         print("Dispose");
//       };
//     }, []);

//     return Column(
//       children: [
//         Text(x.value.toString()),
//         RaisedButton(onPressed: () {
//           x.value = 1;
//         }),
//       ],
//     );
//   }
// }

class TodoCell extends HookWidget {
  TodoCell({
    //Named parameters:
    @required this.todo,
    @required this.onRemove,
    @required this.onToggle,
    @required this.onEdit,
    @required this.onSubmit,
    @required this.onTap,
  });

  final Todo todo;
  final Function() onRemove;
  final Function() onToggle;
  final Function(String) onEdit;
  final Function() onSubmit;
  final Function() onTap;

  ValueNotifier<FocusNode> useFocusNode() {
    final focus = useState(FocusNode());

    useEffect(() {
      return () {
        focus.value.dispose();
      };
    }, []);

    return focus;
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();

    useEffect(() {
      FocusScope.of(context).requestFocus(focusNode.value);
      return () {};
    }, []);

    return Dismissible(
      key: Key(todo.id),
      child: ListTile(
        leading: Text(todo.id),
        title: Observer(
          builder: (_) {
            return TextField(
              focusNode: focusNode.value,
              decoration: todo.focused ? InputDecoration() : null,
              onChanged: (value) => onEdit(value),
              onSubmitted: (_) => onSubmit(),
              onTap: () => onTap(),
            );
          },
        ),
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
