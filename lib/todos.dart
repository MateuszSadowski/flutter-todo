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

  @action
  void editTodoTitle(Todo todoToEdit, String newTitle) {
    todos.firstWhere((todo) => todo == todoToEdit).editTitle(newTitle);
  }

  @action
  void setFocused(Todo todoToFocus) {
    todos.forEach((todo) {
      if (todo == todoToFocus) {
        todo.focusOn();
      } else {
        todo.focusOff();
      }
    });
  }

  @action
  void focusOff(Todo todoToSubmit) {
    todos.firstWhere((todo) => todo == todoToSubmit).focusOff();
  }
}
