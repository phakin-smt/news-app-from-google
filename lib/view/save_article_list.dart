import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controller/news_controller.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/widgets/article_card.dart';
import 'article_detail.dart';

class SavedArticleListPage extends StatelessWidget {
  const SavedArticleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<NewsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Articles')),
      body: Obx(() {
        final List<Item> list = c.saved;
        if (list.isEmpty) {
          return const Center(child: Text('No saved articles yet'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(height: 32),
          itemBuilder: (_, i) {
            final a = list[i];
            return ArticleCard(
              article: a,
              isSaved: true,
              onTap: () => Get.to(() => const ArticleDetailPage()),
              onToggleSave: () => c.unsave(a),
            );
          },
        );
      }),
    );
  }
}
