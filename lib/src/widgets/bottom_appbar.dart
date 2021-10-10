import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

class BottomAppbar extends StatefulWidget {
  const BottomAppbar({
    Key? key,
    required int currentIndex,
  })  : _currentIndex = currentIndex,
        super(key: key);

  final int _currentIndex;

  @override
  State<BottomAppbar> createState() => _BottomAppbarState();
}

class _BottomAppbarState extends State<BottomAppbar> {
  void _onItemTapped(index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, "/");
        break;
      case 1:
        Navigator.pushNamed(context, "/listbook");
        break;
      case 2:
        Navigator.pushNamed(context, "/listauthor");
        break;
      case 3:
        Navigator.pushNamed(context, "/listcategory");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DotNavigationBar(
      currentIndex: widget._currentIndex,
      onTap: _onItemTapped,
      marginR: const EdgeInsets.symmetric(horizontal: 15),
      backgroundColor: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      dotIndicatorColor: Colors.transparent,
      unselectedItemColor: Colors.grey,
      items: [
        DotNavigationBarItem(icon: const Icon(Icons.home)),
        DotNavigationBarItem(icon: const Icon(Icons.book)),
        DotNavigationBarItem(icon: const Icon(Icons.people)),
        DotNavigationBarItem(icon: const Icon(Icons.category)),
      ],
    );
  }
}
