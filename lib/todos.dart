import 'package:flutter_todo/todo.dart';
import 'package:mobx/mobx.dart';

part 'todos.g.dart';

class Todos = TodosBase with _$Todos;

abstract class TodosBase with Store {
  @observable
  ObservableList<Todo> todos = ObservableList<Todo>();

  @action
  void addTodo(Todo todo) {
    todos.add(todo);
  }

  @action
  void toggleTodo(Todo todoToToggle) {
    todos.firstWhere((todo) => todo == todoToToggle).toggle();
  }

  @action
  void removeTodo(Todo todoToRemove) {
    todos.remove(todoToRemove);
  }
}
