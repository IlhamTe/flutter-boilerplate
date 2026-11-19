import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';

import '../../../data/post/models/post.dart';
import '../../../shared/assets/assets.gen.dart';
import '../../../shared/assets/colors.gen.dart';
import '../../../shared/config/app_text_styles.dart';

@RoutePage()
class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ColoredBox(
            color: ColorName.illustrationBackground,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Assets.images.flutterBirdIllustration.image(
                fit: BoxFit.contain,
                excludeFromSemantics: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.title, style: AppTextStyles.h1),
                const SizedBox(height: 12),
                Text(post.body, style: AppTextStyles.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
