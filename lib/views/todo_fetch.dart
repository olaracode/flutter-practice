import 'package:flutter/material.dart';
import 'package:todolist/data/api/todo_list_api.dart' as todo_api;
export 'todo_fetch.dart';

class TodoListFetch extends StatelessWidget {
  const TodoListFetch({Key? key}) : super(key: key);

  static const routeName = "/login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Fetch"),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text("Todo List with fetch", textAlign: TextAlign.center),
              Expanded(child: Todos())
            ],
          ),
        ),
      ),
    );
  }
}

class Todos extends StatefulWidget {
  const Todos({Key? key}) : super(key: key);

  @override
  State<Todos> createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  late Future<todo_api.TodoList> futureTodos;

  var inputController = TextEditingController();

  void addTodo() {
    var newTodo = todo_api.Todo(
      label: inputController.text,
      done: false,
    );

    futureTodos.then((todoList) {
      todoList.todos.add(newTodo);
      todo_api.updateTodoList(todoList.todos).then((res) {
        setState(() {
          inputController.text = "";
          futureTodos = todo_api.getTodos();
        });
      });
    });
  }

  void deleteTodo(String id) {
    futureTodos.then((todoList) {
      todoList.todos.removeWhere((todo) => todo.id == id);
      todo_api.updateTodoList(todoList.todos).then((res) {
        setState(() {
          futureTodos = todo_api.getTodos();
        });
      });
    });
  }

  void checkTodo(String id) {
    futureTodos.then((todoList) {
      var todo = todoList.todos.firstWhere((todo) => todo.id == id);
      todo.done = !todo.done;
      todo_api.updateTodoList(todoList.todos).then((res) {
        setState(() {
          futureTodos = todo_api.getTodos();
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    futureTodos = todo_api.getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: inputController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your todo',
                ),
              ),
            ),
            const SizedBox(width: 20),
            Container(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  addTodo();
                },
                icon: const Icon(Icons.send),
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                  ),
                ),
                label: const Text("Add"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: FutureBuilder<todo_api.TodoList>(
            future: futureTodos,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    for (var todo in snapshot.data!.todos)
                      Card(
                        color: todo.done ? Colors.green : Colors.red.shade100,
                        child: ListTile(
                          title: Text(todo.label),
                          trailing: Container(
                            width: 80, // Adjust this value as needed
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      deleteTodo(todo.id ?? "");
                                    },
                                    icon: const Icon(Icons.delete)),
                                Checkbox(
                                  value: todo.done,
                                  onChanged: (value) {
                                    setState(() {
                                      checkTodo(todo.id ?? "");
                                    });
                                  },
                                ),
                                // Add your delete button here
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}
