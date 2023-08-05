import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:posts/models/posts_model.dart';

import '../services/api_services.dart';

part 'posts_event.dart';

part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsApiServices postsApiServices;

  PostsBloc(this.postsApiServices) : super(PostsInitState()) {
    on<PostsLoadedEvent>((event, emit) async {
      emit(PostsLoadingState());
      try {
        List<PostsModel> postsList = [];
        emit(PostsLoadingState());
        postsList = await postsApiServices.fetchPosts();
        emit(PostsLoadedState(postsList: postsList));
      } catch (e) {
        emit(PostsErrorState(errorMessage: e.toString()));
      }
    });
  }
  void addPost(PostsModel newPost) {
    if (state is PostsLoadedState) {
      List<PostsModel> updatedList = [newPost, ...(state as PostsLoadedState).postsList];
      emit(PostsLoadedState(postsList: updatedList));
    }
  }
}
