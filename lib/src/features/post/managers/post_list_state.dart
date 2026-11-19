part of 'post_list_bloc.dart';

@freezed
sealed class PostListState with _$PostListState {
  const factory PostListState.initial() = _Initial;
  const factory PostListState.loading() = _Loading;
  const factory PostListState.loaded(List<Post> posts) = _Loaded;
  const factory PostListState.failure(Exception error) = _Failure;
}
