import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/widgets/nav_buttons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app/controller/news_controller.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({super.key});

  String _fmtTime(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<NewsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Article')),
      body: Obx(() {
        final a = c.current;
        if (a == null) {
          return const Center(child: Text('No article'));
        }

        final imageUrl = a.images?.thumbnail ?? '';
        final openLink = a.newsUrl.isNotEmpty ? a.newsUrl : imageUrl;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
            const SizedBox(height: 12),
            Text(
              a.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Theme.of(context).hintColor),
                const SizedBox(width: 4),
                Text(
                  _fmtTime(a.timestampDT), 
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(a.snippet),
            const SizedBox(height: 16),
            if (openLink.isNotEmpty)
              FilledButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(openLink);
                  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cannot open link')),
                    );
                  }
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open full article'),
              ),
            const SizedBox(height: 24),
            const SizedBox(height: 24),
            Obx(() {
              final c = Get.find<NewsController>();
              return NavButtons(
                canPrev: c.index.value > 0,
                canNext: c.index.value < c.today.length - 1,
                onPrev: c.prev,
                onNext: c.next,
                counterText: '${c.index.value + 1} / ${c.today.length}',
              );
            }),
            const SizedBox(height: 8),
          ],
        );
      }),
    );
  }
}
