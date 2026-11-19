import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_boilerplate/src/data/post/models/post.dart';
import 'package:flutter_boilerplate/src/data/post/repositories/post_repositories.dart';
import 'package:flutter_boilerplate/src/features/post/managers/post_list_bloc.dart';
import 'package:flutter_boilerplate/src/shared/models/result.dart';
import 'package:flutter_boilerplate/src/shared/network/api_exception.dart';

class _MockPostRepositories extends Mock implements PostRepositories {}

void main() {
  late _MockPostRepositories repository;

  setUp(() => repository = _MockPostRepositories());

  const posts = [Post(id: 1, userId: 1, title: 'a', body: 'b')];
  const error = ApiException('boom', statusCode: 500);

  blocTest<PostListBloc, PostListState>(
    'emits loading then loaded when the repository returns posts',
    setUp: () =>
        when(repository.getPosts)
            .thenAnswer((_) async => const Result.ok(posts)),
    build: () => PostListBloc(repository),
    act: (bloc) => bloc.add(const PostListEvent.fetched()),
    expect: () => const [PostListState.loading(), PostListState.loaded(posts)],
  );

  blocTest<PostListBloc, PostListState>(
    'emits loading then failure when the repository returns an error',
    setUp: () =>
        when(repository.getPosts)
            .thenAnswer((_) async => const Result.error(error)),
    build: () => PostListBloc(repository),
    act: (bloc) => bloc.add(const PostListEvent.fetched()),
    expect: () => const [PostListState.loading(), PostListState.failure(error)],
  );
}
