import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:news_app/model/news_model.dart';
import 'endpoints.dart';

class NewsApi {
  final String apiKey;
  final String host;
  NewsApi({required this.apiKey, required this.host});

  Future<List<Item>> fetchByEndpoint(NewsEndpoint ep) async {
    final uri = Uri.https(host, ep.path.startsWith('/') ? ep.path.substring(1) : ep.path, {
      'lr': 'en-US'
    });
    log('tFetchByEndpoint: $uri');

    final req = http.Request('GET', uri);
    req.headers.addAll({
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': host,
    });
    final streamed = await req.send();
    final body = await streamed.stream.bytesToString();

    log('HTTP ${streamed.statusCode}');
    // log(body);

    if (streamed.statusCode == 200) {
      final raw = NewsList.fromJson(jsonDecode(body));
      log('Parsed items: ${raw.items.length}');
      return raw.items;
    } else {
      log('Error body: $body');
      return [];
    }
  }
}
