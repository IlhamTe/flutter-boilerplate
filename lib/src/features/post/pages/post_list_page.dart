import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../i18n/strings.g.dart';
import '../../../shared/assets/assets.gen.dart';
import '../../../shared/config/app_di.dart';
import '../../../shared/config/app_router.gr.dart';
import '../../../shared/config/app_text_styles.dart';
import '../managers/post_list_bloc.dart';

@RoutePage()
class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          locator<PostListBloc>()..add(const PostListEvent.fetched()),
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(12),
            // Decorative: the title already names the screen.
            child: Assets.icons.icFlutter.image(excludeFromSemantics: true),
          ),
          title: Text(context.t.post.title),
        ),
        body: BlocBuilder<PostListBloc, PostListState>(
          builder: (context, state) => state.when(
            failure: (_) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.t.common.error),
                  TextButton(
                    onPressed: () => context.read<PostListBloc>().add(
                      const PostListEvent.fetched(),
                    ),
                    child: Text(context.t.common.retry),
                  ),
                ],
              ),
            ),
            loaded: (posts) => posts.isEmpty
                ? Center(child: Text(context.t.post.empty))
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return ListTile(
                        title: Text(post.title, style: AppTextStyles.h3),
                        subtitle: Text(
                          post.body,
                          maxLines: 2,
                          style: AppTextStyles.caption,
                        ),
                        onTap: () =>
                            context.router.push(PostDetailRoute(post: post)),
                      );
                    },
                  ),
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
