import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:weekly_challenge/main.dart';

class BottomNavigationShell extends StatefulWidget {
  final Widget child;
  const BottomNavigationShell({super.key, required this.child});

  @override
  State<BottomNavigationShell> createState() => _BottomNavigationShellState();
}

class _BottomNavigationShellState extends State<BottomNavigationShell> {
  int _currentIndex = 0;
  final List<String> _pages = const [
    "",
    "tasks",
    "challenges",
    "profil",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: widget.child),
      //change borderRadius of bottom bar items
      bottomNavigationBar: SalomonBottomBar(
        itemShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(App.defaultRadius))),
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
          });
          GoRouter.of(context).go("/${_pages[i]}");
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Theme.of(context).colorScheme.onPrimary,
          ),
          SalomonBottomBarItem(
              icon: const Icon(Icons.check_box),
              title: const Text("Tasks"),
              selectedColor: Theme.of(context).colorScheme.onPrimary),
          SalomonBottomBarItem(
            icon: const Icon(Icons.list),
            title: const Text("Challenges"),
            selectedColor: Theme.of(context).colorScheme.onPrimary,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profil"),
            selectedColor: Theme.of(context).colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}
