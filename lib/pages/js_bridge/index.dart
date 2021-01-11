import 'dart:convert';
import 'package:intl/intl.dart'; // 需要在pubspec.yaml增加该模块
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:camera/camera.dart';
import 'package:flutter_app_1/pages/camera/camera.dart';



class JSBridgetDemo extends StatefulWidget {
  JSBridgetDemo({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _JSBridgetDemoState createState() => _JSBridgetDemoState();
}

String getCurrentTime(String prefix) {
  DateTime now = DateTime.now();
  var formatter = DateFormat('yy-mm-dd H:m:s');
  String nowTime = formatter.format(now);

  return '$prefix $nowTime';
}



class _JSBridgetDemoState extends State<JSBridgetDemo> {

  WebViewController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Webview')),
      body: WebView(
        initialUrl: 'about:blank',
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: Set.from([
          JavascriptChannel(
              name: 'messageHandler',
              onMessageReceived: (JavascriptMessage message) {
                print('消息来自html {$message}');
                _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                        content: Text(
                            message.message)
                    )
                );
              }),
          JavascriptChannel(
              name: 'takePhoto',
              onMessageReceived: (JavascriptMessage message) {
                print('消息来自照相按钮 {$message}');
                _loadCamera();

              }),
        ]),
        onWebViewCreated: (WebViewController webviewController) {
          _controller = webviewController;
          _loadHtmlFromAssets();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_upward),
        onPressed: () {
           final currentTimeInfo = getCurrentTime('flutter时间');
          _controller.evaluateJavascript('fromFlutter("$currentTimeInfo")');
        },
      ),
    );

  }

   _loadCamera () async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    // 打开`TipRoute`，并等待返回结果
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TakePictureScreen(
            // 路由参数
            camera: firstCamera,
          );
        },
      ),
    );
    //输出`TipRoute`路由返回结果
    print("路由返回值: $result");
  }
  _loadHtmlFromAssets() async {
    String file = await rootBundle.loadString('assets/index.html');
    _controller.loadUrl(Uri.dataFromString(
        file,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')).toString());
  }

}