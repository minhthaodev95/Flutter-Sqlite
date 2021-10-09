import 'package:flutter/material.dart';
import 'package:library_app_sqlite/src/models/author_model.dart';

import 'package:library_app_sqlite/src/widgets/bottom_appbar.dart';
import 'package:library_app_sqlite/src/services/repository.dart';
import 'package:uuid/uuid.dart';

class ListAuthor extends StatefulWidget {
  const ListAuthor({Key? key}) : super(key: key);

  @override
  State<ListAuthor> createState() => _ListAuthorState();
}

class _ListAuthorState extends State<ListAuthor> {
  final int _currentIndex = 2;
  final uuid = const Uuid();
  Future<List<Author>> allAuthors = RepositoryService().queryAuthor();

  void refresh() async {
    allAuthors = RepositoryService().queryAuthor();
    setState(() {});
  }

  void _showDialog() async {
    final _nameAuthor = TextEditingController();
    final _ageAuthor = TextEditingController();
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
                  const Text('INSERT AUTHOR'),
                  TextFormField(
                    controller: _nameAuthor,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.person),
                      hintText: 'What is the name of author?',
                      labelText: 'Name',
                    ),
                  ),
                  TextFormField(
                    controller: _ageAuthor,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.person),
                      hintText: "Author's age?",
                      labelText: 'Age',
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
                          final author = Author(
                              id: uuid.v1(),
                              name: _nameAuthor.text,
                              age: int.parse(_ageAuthor.text));
                          RepositoryService().insertAuthor(author);
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

  void _showDialogUpdate({required Author currentAuthor}) async {
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
                    initialValue: currentAuthor.name,
                    onChanged: (text) {
                      currentAuthor.name = text;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.person),
                      hintText: 'What is the name of author?',
                      labelText: 'Name',
                    ),
                  ),
                  TextFormField(
                    initialValue: currentAuthor.age.toString(),
                    onChanged: (text) => {currentAuthor.age = int.parse(text)},
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.person),
                      hintText: "Author's age?",
                      labelText: 'Age',
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
                          final author = Author(
                            id: currentAuthor.id,
                            name: currentAuthor.name,
                            age: currentAuthor.age,
                          );
                          RepositoryService().updateAuthor(author);
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
        title: const Text('List Author'),
      ),
      body: Center(
        child: FutureBuilder<List<Author>>(
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
                            leading: const Icon(Icons.person),
                            title: Text(
                              'Author: ${snapshot.data![index].name}',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.teal),
                            ),
                            subtitle:
                                Text('Age : ${snapshot.data![index].age}'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: const Text('Update'),
                                onPressed: () {
                                  _showDialogUpdate(
                                      currentAuthor: snapshot.data![index]);
                                },
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () async {
                                  await RepositoryService()
                                      .deleteAuthor(snapshot.data![index].id);
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
          future: allAuthors,
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
