import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_todo/todo.dart';

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
    final textController = useState(TextEditingController());

    useEffect(() {
      return () {
        focus.value.dispose();
        textController.value.dispose();
      };
    }, []);

    return focus;
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final textController = useTextEditingController();

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
              controller: textController,
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
