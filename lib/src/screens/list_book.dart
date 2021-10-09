import 'package:flutter/material.dart';
import 'package:library_app_sqlite/src/models/author_model.dart';
import 'package:library_app_sqlite/src/models/book_model.dart';
import 'package:library_app_sqlite/src/models/category.model.dart';
import 'package:library_app_sqlite/src/widgets/bottom_appbar.dart';
import 'package:library_app_sqlite/src/services/repository.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ListBook extends StatefulWidget {
  const ListBook({Key? key}) : super(key: key);

  @override
  State<ListBook> createState() => _ListBookState();
}

class _ListBookState extends State<ListBook> {
  final int _currentIndex = 1;
  final uuid = const Uuid();
  Future<List<Book>> allBooks = RepositoryService().queryBooks();

  void refresh() async {
    allBooks = RepositoryService().queryBooks();
    setState(() {});
  }

  void _showDialog() async {
    final authors = await RepositoryService().queryAuthor();
    final categories = await RepositoryService().queryCategories();
    RxString currentAuthor = authors[0].id.obs;
    RxString currentCategory = categories[0].id.obs;
    final _title = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: SingleChildScrollView(
          child: Dialog(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text('INSERT BOOK'),
                  TextFormField(
                    controller: _title,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.book_online),
                      hintText: 'What is the title of the book?',
                      labelText: 'Title',
                    ),
                  ),
                  Obx(
                    () => Row(
                      children: [
                        const Text('Author : '),
                        DropdownButton<String>(
                          items: authors.map((Author author) {
                            return DropdownMenuItem<String>(
                              value: author.id,
                              child: Text(author.name),
                            );
                          }).toList(),
                          hint: const Text('Author'),
                          onChanged: (selectedAuthor) {
                            currentAuthor.value = selectedAuthor!;
                          },
                          value: currentAuthor.value,
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Row(
                      children: [
                        const Text('Category : '),
                        DropdownButton<String>(
                          items: categories.map((Category category) {
                            return DropdownMenuItem<String>(
                              value: category.id,
                              child: Text(category.name),
                            );
                          }).toList(),
                          hint: const Text('Category'),
                          onChanged: (selectedCategory) {
                            currentCategory.value = selectedCategory!;
                          },
                          value: currentCategory.value,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text('Cancel'),
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      ElevatedButton(
                        onPressed: () {
                          final book = Book(
                            id: uuid.v1(),
                            title: _title.text,
                            authorId: currentAuthor.value,
                            categoryId: currentCategory.value,
                          );
                          RepositoryService().insertBook(book);
                          Navigator.pop(context, true);
                          refresh();
                        },
                        child: const Text('Insert'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
      },
    );
  }

  void _showDialogUpdate({required Book currentBook}) async {
    final authors = await RepositoryService().queryAuthor();
    final categories = await RepositoryService().queryCategories();
    RxString currentAuthor = currentBook.authorId!.obs;
    RxString currentCategory = currentBook.categoryId!.obs;
    final _title = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: SingleChildScrollView(
          child: Dialog(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text('INSERT BOOK'),
                  TextFormField(
                    initialValue: currentBook.title,
                    onChanged: (text) {
                      currentBook.title = text;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.book_online),
                      hintText: 'What is the title of the book?',
                      labelText: 'Title',
                    ),
                  ),
                  Obx(
                    () => Row(
                      children: [
                        const Text('Author : '),
                        DropdownButton<String>(
                          items: authors.map((Author author) {
                            return DropdownMenuItem<String>(
                              value: author.id,
                              child: Text(author.name),
                            );
                          }).toList(),
                          hint: const Text('Author'),
                          onChanged: (selectedAuthor) {
                            currentAuthor.value = selectedAuthor!;
                          },
                          value: currentAuthor.value,
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Row(
                      children: [
                        const Text('Category : '),
                        DropdownButton<String>(
                          items: categories.map((Category category) {
                            return DropdownMenuItem<String>(
                              value: category.id,
                              child: Text(category.name),
                            );
                          }).toList(),
                          hint: const Text('Category'),
                          onChanged: (selectedCategory) {
                            currentCategory.value = selectedCategory!;
                          },
                          value: currentCategory.value,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text('Cancel'),
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      ElevatedButton(
                        onPressed: () {
                          final book = Book(
                            id: currentBook.id,
                            title: currentBook.title,
                            authorId: currentAuthor.value,
                            categoryId: currentCategory.value,
                          );
                          RepositoryService().updateBook(book);
                          Navigator.pop(context, true);
                          refresh();
                        },
                        child: const Text('Update'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('List Book'),
      ),
      body: Center(
        child: FutureBuilder<List<Book>>(
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                              isThreeLine: true,
                              leading: const Icon(Icons.access_alarm),
                              title: Text(
                                'Title: ${snapshot.data![index].title}',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.teal),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Author : ${snapshot.data![index].author!}'),
                                  Text(
                                      'Gener : ${snapshot.data![index].category!}'),
                                ],
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: const Text('Update'),
                                onPressed: () {
                                  _showDialogUpdate(
                                      currentBook: snapshot.data![index]);
                                },
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () async {
                                  await RepositoryService()
                                      .deleteBook(snapshot.data![index].id);
                                  refresh();
                                },
                              ),
                              const SizedBox(width: 8),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: snapshot.data!.length);
            }
          },
          future: allBooks,
        ),
      ),
      bottomNavigationBar: BottomAppbar(
        currentIndex: _currentIndex,
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            _showDialog();
          }),
    );
  }
}
