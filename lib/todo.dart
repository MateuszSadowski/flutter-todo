import 'package:mobx/mobx.dart';

part 'todo.g.dart';

class Todo = TodoBase with _$Todo;

abstract class TodoBase with Store {
  final String id;
  final String title;

  @observable
  bool completed;

  TodoBase(this.id, this.title, this.completed);

  toggle() {
    completed = !completed;
  }
}
