import 'package:flutter/material.dart';
import 'package:posts/models/posts_model.dart';

class DetailsScreen extends StatelessWidget {
  final PostsModel postsModel;

  const DetailsScreen({required this.postsModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.all(15),
        height: MediaQuery.sizeOf(context).height,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Text(
            postsModel.body,
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}
