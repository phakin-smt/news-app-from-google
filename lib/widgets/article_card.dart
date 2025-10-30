import 'package:flutter/material.dart';
import 'package:news_app/model/news_model.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.article,
    required this.isSaved,
    required this.onTap,
    required this.onToggleSave,
  });

  final Item article;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onToggleSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: article.images!.thumbnail.isEmpty ? Container(color: Colors.grey.shade300, child: const Icon(Icons.image_not_supported)) : Image.network(article.images!.thumbnail, fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          article.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(article.snippet, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.schedule, size: 16, color: Theme.of(context).hintColor),
            const SizedBox(width: 4),
            Text(
              _fmtTime(article.timestampDT),
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            const Spacer(),
            IconButton.filledTonal(
              tooltip: isSaved ? 'Unsave' : 'Save',
              onPressed: onToggleSave,
              icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
            ),
          ],
        ),
      ],
    );
  }

  String _fmtTime(DateTime dt) => '${dt.year}-${_2(dt.month)}-${_2(dt.day)} ${_2(dt.hour)}:${_2(dt.minute)}';
  String _2(int v) => v.toString().padLeft(2, '0');
}
