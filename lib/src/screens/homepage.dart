import 'package:flutter/material.dart';
import 'package:library_app_sqlite/src/widgets/bottom_appbar.dart';

class HomePage extends StatelessWidget {
  final int _currentIndex = 0;
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('HomePage'),
      ),
      body: const Center(
        child: Text('Home Page Body'),
      ),
      bottomNavigationBar: BottomAppbar(
        currentIndex: _currentIndex,
      ),
    );
  }
}
