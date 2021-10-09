class Author {
  String id;
  String name;
  int age;

  Author({required this.age, required this.id, required this.name});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(age: json['age'], id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }
}
