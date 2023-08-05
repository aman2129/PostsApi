part of 'posts_bloc.dart';

@immutable
abstract class PostsState {}

class PostsInitState extends PostsState {}

class PostsLoadingState extends PostsState {}

class PostsLoadedState extends PostsState {
  final List<PostsModel> postsList;
  PostsLoadedState({required this.postsList});
}

class PostsErrorState extends PostsState {
  final String errorMessage;
  PostsErrorState({required this.errorMessage});
}