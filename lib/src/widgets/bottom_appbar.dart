import 'package:flutter/material.dart';

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
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 4,
      clipBehavior: Clip.antiAlias,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: widget._currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.yellowAccent,
        unselectedItemColor: Colors.brown,
        backgroundColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Book'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Author'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Category'),
        ],
      ),
    );
  }
}
