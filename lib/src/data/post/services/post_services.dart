import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../models/post.dart';

part 'post_services.g.dart';

@lazySingleton
@RestApi()
abstract class PostServices {
  @factoryMethod
  factory PostServices(Dio dio) = _PostServices;

  @GET('/posts')
  Future<List<Post>> getPosts();
}
