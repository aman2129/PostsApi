class PostsModel {
  final int userId;
  final int id;
  final String title;
  final String body;

  PostsModel(
      {required this.id,
      required this.title,
      required this.body,
      required this.userId});

  factory PostsModel.fromJson(Map<String, dynamic> json) {
    return PostsModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "id": id,
      "title": title,
      "body": body,
    };
  }
}
