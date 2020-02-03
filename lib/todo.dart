import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'todo.g.dart';

class Todo = TodoBase with _$Todo;

abstract class TodoBase with Store {
  final String id;

  @observable
  String title;

  @observable
  bool focused;

  @observable
  bool completed;

  TodoBase(this.id, this.title, this.focused, this.completed);

  toggle() {
    completed = !completed;
  }

  editTitle(String newTitle) {
    title = newTitle;
    focusOn();
  }

  focusOn() {
    focused = true;
  }

  focusOff() {
    focused = false;
  }
}
