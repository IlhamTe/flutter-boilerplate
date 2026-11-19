part of 'post_list_bloc.dart';

@freezed
sealed class PostListEvent with _$PostListEvent {
  const factory PostListEvent.fetched() = _Fetched;
}
