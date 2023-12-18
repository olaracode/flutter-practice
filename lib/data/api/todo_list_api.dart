import 'dart:convert';
import 'package:http/http.dart';

export 'todo_list_api.dart';

final API_URL = 'https://playground.4geeks.com/apis/fake/todos/user/olaracode';

class Todo {
  final String label;
  bool done;
  final String? id;

  Todo({
    required this.label,
    required this.done,
    this.id,
  });

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      label: map['label'],
      done: map['done'],
      id: map['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'done': done,
      'id': id,
    };
  }
}

class TodoList {
  final List<Todo> todos;

  TodoList({
    required this.todos,
  });

  TodoList.fromJson(Map<String, dynamic> json)
      : todos = (json['todos'] as List)
            .map((item) => Todo.fromMap(item as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'todos': todos.map((todo) => todo.toJson()).toList(),
    };
  }
}

Future<void> createTodoList() async {
  final response = await post(
    Uri.parse(API_URL),
    body: jsonEncode([]),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode != 201) {
    throw Exception('Error creating todo');
  }
}

Future<void> updateTodoList(List<Todo> newList) async {
  print(newList);

  final response = await put(
    Uri.parse(API_URL),
    body: jsonEncode(newList.map((todo) => todo.toJson()).toList()),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode != 200) {
    throw Exception('Error creating todo');
  }
}

Future<TodoList> getTodos() async {
  final response = await get(Uri.parse(API_URL));
  if (response.statusCode == 404) {
    await createTodoList();
    return getTodos();
  }
  final json = jsonDecode(response.body);
  // return TodoList.fromJson(todos);
  return TodoList.fromJson({'todos': json});
}
