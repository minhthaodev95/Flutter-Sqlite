import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  DatabaseService._privateContructor();
  static final DatabaseService instance = DatabaseService._privateContructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDb();
    return _database!;
  }

  initDb() async {
    var databasePath = await getDatabasesPath();
    // ignore: avoid_print
    print(databasePath);
    String path = join(databasePath, 'library.db');
    var database = await openDatabase(path, version: 1, onCreate: onCreate);
    return database;
  }

  Future onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE authors(
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      age INTEGER
     )
    ''');
    await db.execute('''
    CREATE TABLE categories(
      id TEXT PRIMARY KEY,
      name  TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE books(
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      authorId TEXT,
      categoryId TEXT,
      FOREIGN KEY(authorId) REFERENCES authors(id),
      FOREIGN KEY(categoryId) REFERENCES categories(id)
    )
    ''');
  }

// CRUB books :

  // Future<Book> insertBook(Book book) async {
  //   Database db = await instance.database;
  //   await db.insert('books', book.toMap());
  //   return book;
  // }

  // Future<Book> deleteBook(Book book) async {
  //   Database db = await instance.database;
  //   await db.delete('books', where: 'id = ?', whereArgs: [book.id]);
  //   return book;
  // }

  // Future<Book> updateBook(Book book) async {
  //   Database db = await instance.database;
  //   await db
  //       .update('books', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
  //   return book;
  // }

  // Future<List<Book>> queryBooks(int? authorID) async {
  //   Database db = await instance.database;
  //   final response = await db.rawQuery(
  //       'select books.id, books.title, authors.name as author, categories.name as category  from books, authors, categories where books.authorId = authors.id and books.categoryId = categories.id and books.authorId = $authorID');
  //   print(response);
  //   final List<Book> allBooks =
  //       response.map((book) => Book.fromJson(book)).toList();
  //   return allBooks;
  // }
}
