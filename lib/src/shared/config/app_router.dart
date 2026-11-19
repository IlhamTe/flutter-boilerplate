import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

final appRouter = AppRouter();

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/posts', page: PostListRoute.page, initial: true),
    AutoRoute(path: '/posts/detail', page: PostDetailRoute.page),
  ];
}
