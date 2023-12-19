import 'package:flutter/material.dart';
import 'package:todolist/views/todo.dart';
import 'package:todolist/views/rick_and_morty.dart';
import 'package:todolist/views/todo_fetch.dart';

Widget pageBuilder(int selectedIndex) {
  Widget page;
  switch (selectedIndex) {
    case 0:
      page = const TodoList(title: "Flutter Todo List");
      break;
    case 1:
      page = const RickAndMorty();
      break;
    case 2:
      page = const TodoListFetch();
      break;
    default:
      page = const Placeholder();
  }
  return page;
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var selectedIndex = 2;
  @override
  Widget build(BuildContext context) {
    final page = pageBuilder(selectedIndex);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                extended: constraints.maxWidth > 600,
                backgroundColor: Colors.red.shade200,
                selectedIndex: selectedIndex,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.list),
                    label: Text("Todo List"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.science),
                    label: Text("Rick and Morty"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.checklist),
                    label: Text("Todo + Fecth"),
                  ),
                ],
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
