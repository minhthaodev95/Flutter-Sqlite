import 'package:flutter/material.dart';
import 'package:library_app_sqlite/src/screens/homepage.dart';
import 'package:library_app_sqlite/src/screens/list_author.dart';
import 'package:library_app_sqlite/src/screens/list_book.dart';
import 'package:library_app_sqlite/src/screens/list_category.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      routes: {
        '/': (context) => const HomePage(),
        '/listbook': (context) => const ListBook(),
        '/listauthor': (context) => const ListAuthor(),
        '/listcategory': (context) => const ListCategory(),
      },
    );
  }
}
