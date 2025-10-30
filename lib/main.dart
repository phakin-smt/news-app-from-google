import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/view/homepage.dart';
import 'controller/news_controller.dart';
import 'services/news_api.dart';
import 'services/local_store.dart';

void main() {
  const apiKey = 'api-key-goes-here';
  const host = 'host-goes-here';

  runApp(GetMaterialApp(
    title: 'News App',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    initialBinding: BindingsBuilder(() {
      Get.put(NewsApi(apiKey: apiKey, host: host), permanent: true);
      Get.put(LocalStore(), permanent: true);
      Get.put(NewsController(Get.find(), Get.find()), permanent: true);
    }),
    home: const HomepageWidget(),
  ));
}
