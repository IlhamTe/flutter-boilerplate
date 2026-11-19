import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_boilerplate/src/data/post/models/post.dart';
import 'package:flutter_boilerplate/src/data/post/repositories/post_repositories.dart';
import 'package:flutter_boilerplate/src/data/post/services/post_services.dart';
import 'package:flutter_boilerplate/src/shared/models/result.dart';
import 'package:flutter_boilerplate/src/shared/network/api_exception.dart';

class _MockPostServices extends Mock implements PostServices {}

void main() {
  late _MockPostServices services;
  late PostRepositories repository;

  setUp(() {
    services = _MockPostServices();
    repository = PostRepositoriesImpl(services);
  });

  test('returns Ok with the posts from the service', () async {
    const posts = [Post(id: 1, userId: 1, title: 'a', body: 'b')];
    when(services.getPosts).thenAnswer((_) async => posts);

    final result = await repository.getPosts();

    expect(result, isA<Ok<List<Post>>>());
    expect((result as Ok<List<Post>>).value, posts);
  });

  test(
    'maps a DioException to Error(ApiException) with the status code',
    () async {
      final options = RequestOptions(path: '/posts');
      when(services.getPosts).thenThrow(
        DioException(
          requestOptions: options,
          response: Response(requestOptions: options, statusCode: 500),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await repository.getPosts();

      expect(result, isA<Error<List<Post>>>());
      final error = (result as Error<List<Post>>).error;
      expect(error, isA<ApiException>());
      expect((error as ApiException).statusCode, 500);
    },
  );
}
