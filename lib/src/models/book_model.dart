class Book {
  String id;
  String title;
  String? authorId;
  String? author;
  String? categoryId;
  String? category;
  Book(
      {this.authorId,
      this.categoryId,
      required this.id,
      required this.title,
      this.author,
      this.category});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      author: json["author"],
      category: json["category"],
      id: json['id'],
      title: json['title'],
      authorId: json['authorId'],
      categoryId: json['categoryId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authorId': authorId,
      'categoryId': categoryId
    };
  }
}
