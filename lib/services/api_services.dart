import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/posts_model.dart';


class PostsApiServices{
  Future<List<PostsModel>> fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((post) => PostsModel.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
  Future<PostsModel> createPost(PostsModel post) async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 201) {
      return PostsModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create post');
    }
  }
}
