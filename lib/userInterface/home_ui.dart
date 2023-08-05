import 'package:flutter/material.dart';
import 'package:posts/animations/route_animation.dart';
import 'package:posts/models/posts_model.dart';

class HomeUi extends StatelessWidget {
  PostsModel postsModel;

  HomeUi({super.key, required this.postsModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onTap: () {
          Navigator.of(context).push(RouteAnimation().createDetailsRoute(postsModel));
        },
        leading: Image.asset(
          'assets/images/post.png',
          height: 45,
          width: 50,
        ),
        title: Text(
          postsModel.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
