import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controller/news_controller.dart';
import 'package:news_app/services/endpoints.dart';
import 'package:news_app/view/article_detail.dart';
import 'package:news_app/view/save_article_list.dart';
import 'package:news_app/widgets/article_card.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/widgets/nav_buttons.dart'; // ให้ Item มาจากไฟล์เดียวกัน

class HomepageWidget extends StatelessWidget {
  const HomepageWidget({super.key});

  String _label(NewsEndpoint ep) {
    switch (ep) {
      case NewsEndpoint.latest:
        return 'Latest';
      case NewsEndpoint.world:
        return 'World';
      case NewsEndpoint.business:
        return 'Business';
      case NewsEndpoint.technology:
        return 'Tech';
      case NewsEndpoint.entertainment:
        return 'Entertainment';
      case NewsEndpoint.sports:
        return 'Sports';
      case NewsEndpoint.science:
        return 'Science';
      case NewsEndpoint.health:
        return 'Health';
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<NewsController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Today News — ${_label(c.endpoint())}')),
        actions: [
          Obx(() => PopupMenuButton<NewsEndpoint>(
                tooltip: 'Change endpoint',
                initialValue: c.endpoint(),
                onSelected: (ep) => c.setEndpoint(ep),
                itemBuilder: (_) => NewsEndpoint.values
                    .map((ep) => PopupMenuItem(
                          value: ep,
                          child: Row(
                            children: [
                              if (ep == c.endpoint()) const Icon(Icons.check, size: 18) else const SizedBox(width: 18),
                              const SizedBox(width: 8),
                              Text(_label(ep)),
                            ],
                          ),
                        ))
                    .toList(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Icon(Icons.filter_list),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
              )),
          IconButton(
            tooltip: 'Saved Articles',
            onPressed: () => Get.to(() => const SavedArticleListPage()),
            icon: const Icon(Icons.bookmarks_outlined),
          ),
        ],
      ),
      body: Obx(() {
        if (c.loading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.error.value != null) {
          return ListView(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 12),
              Center(child: Text(c.error.value!)),
              const SizedBox(height: 8),
              Center(
                child: TextButton.icon(
                  onPressed: c.refreshData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ),
            ],
          );
        }

        if (c.today.isEmpty) {
          return ListView(
            children: const [
              SizedBox(height: 160),
              Center(child: Text('No articles found for today')),
            ],
          );
        }

        return RefreshIndicator(
          onRefresh: c.refreshData,
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: c.pageItems.length,
                  separatorBuilder: (_, __) => const Divider(height: 24),
                  itemBuilder: (_, i) {
                    final Item item = c.pageItems[i];
                    final absoluteIndex = c.page.value * NewsController.pageSize + i;

                    return ArticleCard(
                      article: item,
                      isSaved: c.isSaved(item.title),
                      onToggleSave: () {
                        c.openAt(absoluteIndex);
                        c.toggleSave();
                      },
                      onTap: () {
                        c.openAt(absoluteIndex);
                        Get.to(() => const ArticleDetailPage());
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Obx(() {
                  final c = Get.find<NewsController>();
                  return NavButtons(
                    canPrev: c.page.value > 0,
                    canNext: c.page.value < c.totalPages - 1,
                    onPrev: c.prevPage,
                    onNext: c.nextPage,
                    counterText: '${c.page.value + 1} / ${c.totalPages}',
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }
}
