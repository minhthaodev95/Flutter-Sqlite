import 'package:flutter/material.dart';
import 'package:library_app_sqlite/src/models/author_model.dart';
import 'package:library_app_sqlite/src/models/category.model.dart';

import 'package:library_app_sqlite/src/widgets/bottom_appbar.dart';
import 'package:library_app_sqlite/src/services/repository.dart';
import 'package:uuid/uuid.dart';

class ListCategory extends StatefulWidget {
  const ListCategory({Key? key}) : super(key: key);

  @override
  State<ListCategory> createState() => _ListCategoryState();
}

class _ListCategoryState extends State<ListCategory> {
  final int _currentIndex = 3;
  final uuid = const Uuid();
  Future<List<Category>> allCategories = RepositoryService().queryCategories();

  void refresh() async {
    allCategories = RepositoryService().queryCategories();
    setState(() {});
  }

  void _showDialog() async {
    final _nameCategory = TextEditingController();
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
                  const Text('INSERT CATEGORY'),
                  TextFormField(
                    controller: _nameCategory,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.person),
                      hintText: 'Category',
                      labelText: 'Category',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Cancel'),
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      ElevatedButton(
                        onPressed: () {
                          final category = Category(
                            id: uuid.v1(),
                            name: _nameCategory.text,
                          );
                          RepositoryService().insertCategory(category);
                          Navigator.pop(context, true);
                          refresh();
                        },
                        child: const Text('Insert Category'),
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

  void _showDialogUpdate({required Category currentCategory}) async {
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
                  const Text('UPDATE AUTHOR'),
                  TextFormField(
                    initialValue: currentCategory.name,
                    onChanged: (text) {
                      currentCategory.name = text;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.person),
                      hintText: 'What is the name of author?',
                      labelText: 'Name',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Cancel'),
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                      ElevatedButton(
                        onPressed: () {
                          // final author = Author(
                          //   id: currentAuthor.id,
                          //   name: currentAuthor.name,
                          //   age: currentAuthor.age,
                          // );
                          // RepositoryService().updateAuthor(author);
                          // Navigator.pop(context, true);
                          // refresh();
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
        title: const Text('List Author'),
      ),
      body: Center(
        child: FutureBuilder<List<Category>>(
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
                              leading: const Icon(Icons.category),
                              title: Text(
                                'Category: ${snapshot.data![index].name}',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.teal),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: const Text('Update'),
                                onPressed: () {
                                  _showDialogUpdate(
                                      currentCategory: snapshot.data![index]);
                                },
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () async {
                                  await RepositoryService()
                                      .deleteCategory(snapshot.data![index].id);
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
          future: allCategories,
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
