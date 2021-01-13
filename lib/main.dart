import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/pages/drawer/drawer.dart';
import 'package:flutter_app_1/pages/entrance.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_app_1/pages/home_page/index.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_app_1/router.dart' as enhanceRouter;

void main() {
  // it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

  // rest of your app code
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '开发平台',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Entrance(),
      routes: enhanceRouter.Router().registerRouter(), // 路由配置
    );
  }
}
