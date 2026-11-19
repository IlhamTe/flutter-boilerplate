import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/models/result.dart';
import '../../../shared/network/api_exception.dart';
import '../models/post.dart';
import '../services/post_services.dart';

abstract class PostRepositories {
  Future<Result<List<Post>>> getPosts();
}

@LazySingleton(as: PostRepositories)
class PostRepositoriesImpl implements PostRepositories {
  PostRepositoriesImpl(this._services);

  final PostServices _services;

  @override
  Future<Result<List<Post>>> getPosts() async {
    try {
      return Result.ok(await _services.getPosts());
    } on DioException catch (e) {
      return Result.error(ApiException.fromDio(e));
    }
  }
}
