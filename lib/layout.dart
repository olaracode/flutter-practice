import 'package:flutter/material.dart';
import 'package:todolist/views/todo.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const TodoList(title: "Flutter Todo List");
        break;

      default:
        page = const Placeholder();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  backgroundColor: Theme.of(context).colorScheme.shadow,
                  selectedIndex: selectedIndex,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.list),
                      label: Text("Todo List"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text("Settings"),
                    ),
                  ],
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
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
