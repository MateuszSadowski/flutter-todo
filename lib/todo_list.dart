import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_todo/todo_cell.dart';
import 'package:flutter_todo/todos.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    Key key,
    @required this.scrollController,
    @required this.model,
  }) : super(key: key);

  final ScrollController scrollController;
  final Todos model;

  @override
  Widget build(BuildContext context) {
    return Observer(
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
    );
  }
}
