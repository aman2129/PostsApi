import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/posts_bloc.dart';
import '../models/posts_model.dart';
import '../services/api_services.dart';


class AddPosts extends StatefulWidget {
  final BuildContext
      context;

  const AddPosts({super.key, required this.context});

  @override
  State<AddPosts> createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts> {
  final PostsApiServices api = PostsApiServices();

  late TextEditingController titleController;
  late TextEditingController bodyController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    titleController = TextEditingController();
    bodyController = TextEditingController();
    super.initState();
  }

  void _postNewData() async {
    if (_formKey.currentState!.validate()) {
      String title = titleController.text;
      String body = bodyController.text;
      PostsModel newPost = PostsModel(
        id: 101,
        title: title,
        body: body,
        userId: 1,
      );

      try {
        PostsModel postedPost = await api.createPost(newPost);
        widget.context.read<PostsBloc>().addPost(postedPost);
      } catch (e) {
        print('Error creating post: $e');
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a post'),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 30, left: 15, right: 15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Add a title';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  fillColor: Colors.white70,
                  filled: true,
                  labelText: 'Write a title',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.lightBlueAccent,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: bodyController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Add description';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  fillColor: Colors.white70,
                  filled: true,
                  labelText: 'Write description',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.lightBlueAccent,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 15,),
              SizedBox(
                height: 50,
                width: MediaQuery.sizeOf(context).width,
                child: ElevatedButton(
                  onPressed: _postNewData,
                  child: const Text('Add'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
