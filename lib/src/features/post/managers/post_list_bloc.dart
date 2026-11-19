import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../data/post/models/post.dart';
import '../../../data/post/repositories/post_repositories.dart';

part 'post_list_event.dart';
part 'post_list_state.dart';
part 'post_list_bloc.freezed.dart';

@injectable
class PostListBloc extends Bloc<PostListEvent, PostListState> {
  PostListBloc(this._repository) : super(const _Initial()) {
    on<_Fetched>(_onFetched);
  }

  final PostRepositories _repository;

  Future<void> _onFetched(_Fetched event, Emitter<PostListState> emit) async {
    emit(const _Loading());

    final result = await _repository.getPosts();

    emit(result.fold(onOk: _Loaded.new, onError: _Failure.new));
  }
}
