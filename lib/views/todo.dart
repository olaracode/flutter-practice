import 'package:flutter/material.dart';

export 'todo.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key, required this.title});

  final String title;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  var todoList = <String>[];
  final myController = TextEditingController();
  var todoMessage = "";

  void _addTodo() {
    setState(() {
      todoList.add(myController.text);
      myController.text = "";
    });
  }

  void _removeTodo(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                'Your todo List',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: myController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter your todo',
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    // make squared
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (myController.text.isEmpty ||
                          myController.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Todo can\' be empty')),
                        );
                      } else {
                        _addTodo();
                      }
                    },
                    child: const Text('Add'),
                  )
                ],
              ),
              const SizedBox(height: 20),
              if (todoList.isEmpty) const Text('No todo added yet'),
              if (todoList.isNotEmpty) Text('You have ${todoList.length} todo'),
              Expanded(
                child: ListView(
                  children: [
                    for (var i = 0; i < todoList.length; i++)
                      Column(children: [
                        const SizedBox(height: 10),
                        Card(
                          child: ListTile(
                            title: Text(todoList[i]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _removeTodo(i);
                              },
                            ),
                          ),
                        ),
                      ])
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
