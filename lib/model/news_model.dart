class NewsList {
  final String status;
  final List<Item> items;

  NewsList({required this.status, required this.items});

  factory NewsList.fromJson(Map<String, dynamic> j) => NewsList(
        status: (j['status'] ?? '').toString(),
        items: ((j['items'] ?? []) as List).map((e) => Item.fromJson(e as Map<String, dynamic>)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'items': items.map((e) => e.toJson()).toList(),
      };
}

class Item {
  final String timestamp;
  final String title;
  final String snippet;
  final Images? images;
  final List<Item>? subnews;
  final bool? hasSubnews;
  final String newsUrl;
  final String publisher;

  Item({
    required this.timestamp,
    required this.title,
    required this.snippet,
    this.images,
    this.subnews,
    this.hasSubnews,
    required this.newsUrl,
    required this.publisher,
  });

  factory Item.fromJson(Map<String, dynamic> j) => Item(
        timestamp: (j['timestamp'] ?? '').toString(),
        title: (j['title'] ?? '').toString(),
        snippet: (j['snippet'] ?? '').toString(),
        images: j['images'] == null ? null : Images.fromJson(j['images']),
        subnews: j['subnews'] == null ? null : ((j['subnews'] as List).map((e) => Item.fromJson(e as Map<String, dynamic>)).toList()),
        hasSubnews: j['hasSubnews'] as bool?,
        newsUrl: (j['newsUrl'] ?? j['link'] ?? '').toString(),
        publisher: (j['publisher'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'title': title,
        'snippet': snippet,
        'images': images?.toJson(),
        'subnews': subnews?.map((e) => e.toJson()).toList(),
        'hasSubnews': hasSubnews,
        'newsUrl': newsUrl,
        'publisher': publisher,
      };
  DateTime get timestampDT {
    final s = timestamp.trim();
    if (RegExp(r'^\d+$').hasMatch(s)) {
      final ms = int.tryParse(s) ?? 0;
      return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).toLocal();
    }
    return DateTime.tryParse(s)?.toLocal() ?? DateTime.now();
  }

  int get timestampMs {
    final s = timestamp.trim();
    if (RegExp(r'^\d+$').hasMatch(s)) {
      return int.tryParse(s) ?? 0;
    }
    final parsed = DateTime.tryParse(s);
    return parsed?.millisecondsSinceEpoch ?? 0;
  }

  String get stableId => newsUrl.isNotEmpty ? newsUrl : '$timestamp|$title';
}

class Images {
  final String thumbnail;
  final String thumbnailProxied;

  Images({required this.thumbnail, required this.thumbnailProxied});

  factory Images.fromJson(Map<String, dynamic> j) => Images(
        thumbnail: (j['thumbnail'] ?? '').toString(),
        thumbnailProxied: (j['thumbnailProxied'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        'thumbnail': thumbnail,
        'thumbnailProxied': thumbnailProxied,
      };
}
