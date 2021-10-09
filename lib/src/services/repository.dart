import 'package:library_app_sqlite/src/models/author_model.dart';
import 'package:library_app_sqlite/src/models/book_model.dart';
import 'package:library_app_sqlite/src/models/category.model.dart';
import 'package:library_app_sqlite/src/services/services.dart';
import 'package:sqflite/sqflite.dart';

class RepositoryService {
  Future<List<Book>> queryBooks({authorID, categoryID}) async {
    categoryID ??= 'categoryID';
    authorID ??= 'authorID';

    Database db = await DatabaseService.instance.database;
    final response = await db.rawQuery('''SELECT books.id, books.title, 
          authors.name AS author, authors.id AS authorId,
          categories.name AS category, categories.id AS categoryId
         FROM books, authors, categories 
         WHERE books.authorId = authors.id 
          AND books.categoryId = categories.id 
          AND books.authorId = $authorID 
          AND books.categoryId = $categoryID''');
    final List<Book> allBooks =
        response.map((book) => Book.fromJson(book)).toList();
    return allBooks;
  }

  Future<Book> insertBook(Book book) async {
    Database db = await DatabaseService.instance.database;
    await db.insert('books', book.toMap());
    return book;
  }

  Future<String> deleteBook(String id) async {
    Database db = await DatabaseService.instance.database;
    await db.delete('books', where: 'id = ?', whereArgs: [id]);
    return id;
  }

  Future<Book> updateBook(Book book) async {
    Database db = await DatabaseService.instance.database;
    await db
        .update('books', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
    return book;
  }

  Future<List<Author>> queryAuthor() async {
    Database db = await DatabaseService.instance.database;
    final responseAuthor = await db.rawQuery('''
      SELECT * FROM authors
    ''');
    final List<Author> authors =
        responseAuthor.map((author) => Author.fromJson(author)).toList();
    return authors;
  }

  Future<Author> insertAuthor(Author author) async {
    Database db = await DatabaseService.instance.database;
    await db.insert('authors', author.toMap());
    return author;
  }

  Future<Author> updateAuthor(Author author) async {
    Database db = await DatabaseService.instance.database;
    await db.update('authors', author.toMap(),
        where: 'id = ?', whereArgs: [author.id]);
    return author;
  }

  Future<String> deleteAuthor(String id) async {
    Database db = await DatabaseService.instance.database;
    await db.delete('authors', where: 'id = ?', whereArgs: [id]);
    return id;
  }

  Future<List<Category>> queryCategories() async {
    Database db = await DatabaseService.instance.database;
    final responseCategory = await db.rawQuery('''
      SELECT * FROM categories
    ''');
    final List<Category> categories = responseCategory
        .map((category) => Category.fromJson(category))
        .toList();
    return categories;
  }

  Future<String> deleteCategory(String id) async {
    Database db = await DatabaseService.instance.database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
    return id;
  }

  Future<Category> insertCategory(Category category) async {
    Database db = await DatabaseService.instance.database;
    await db.insert('categories', category.toMap());
    return category;
  }
}
