import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts/animations/route_animation.dart';
import 'package:posts/auth_screens/login_screen.dart';
import 'package:posts/models/posts_model.dart';

import '../blocs/posts_bloc.dart';
import '../userInterface/home_ui.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PostsBloc>().add(PostsLoadedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        title: Text(
          'Posts'.toUpperCase(),
          style: const TextStyle(
            letterSpacing: 5.0,
            fontSize: 25.0,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              logoutDialogBox(context);
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (BuildContext context, PostsState state) {
          if (state is PostsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PostsLoadedState) {
            List<PostsModel> postsList = [];
            postsList = state.postsList.reversed.toList();
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              shrinkWrap: true,
              itemCount: postsList.length,
              itemBuilder: ((context, index) =>
                  HomeUi(postsModel: state.postsList[index])),
            );
          } else if (state is PostsErrorState) {
            String error = state.errorMessage;
            return Center(child: Text(error));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(RouteAnimation().createAddPostsRoute());
        },
        child: const Icon(Icons.post_add_outlined),
      ),
    );
  }

  Future<void> logoutDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                          (route) => false);
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

}
