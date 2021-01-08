import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 需要在pubspec.yaml增加该模块
import 'package:webview_flutter/webview_flutter.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;


/// APP 首页入口
///
/// 本模块函数，加载状态类组件HomePageState
class HomePage extends StatefulWidget {
  @override
  createState() => HomePageState();
}

/// 首页有状态组件类
///
/// 主要是获取当前时间，并动态展示当前时间
class HomePageState extends State<HomePage> {
  /// 获取当前时间戳
  ///
  /// [prefix]需要传入一个前缀信息
  /// 返回一个字符串类型的前缀信息：时间戳
  String getCurrentTime(String prefix) {
    DateTime now = DateTime.now();
    var formatter = DateFormat('yy-mm-dd H:m:s');
    String nowTime = formatter.format(now);

    return '$prefix $nowTime';
  }

  /// 有状态类返回组件信息
  @override
  Widget build(BuildContext context) {
    // return Text(
    //     getCurrentTime('当前时间')
    // );
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("差旅链接"),
              textColor: Colors.blue,
              onPressed: () {
                //导航到新路由
                Navigator.push( context,
                    MaterialPageRoute(builder: (context) {
                      return WebViewPage();
                    }));
              },
            ),
           new RaisedButton(
             child: Text('测试路由传参'),
            onPressed: () async {
              // 打开`TipRoute`，并等待返回结果
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return TipRoute(
                      // 路由参数
                      text: "路由参数value",
                    );
                  },
                ),
              );
              //输出`TipRoute`路由返回结果
              print("路由返回值: $result");
            },
           ),
            //     getCurrentTime('当前时间')
            new Text(
                getCurrentTime('当前时间')
            ),
          ],
        ),
      ),

    );
  }
}


class TipRoute extends StatelessWidget {
  TipRoute({
    Key key,
    @required this.text,  // 接收一个text参数
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("提示"),
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(text),
              RaisedButton(
                onPressed: () => Navigator.pop(context, "我是返回值"),
                child: Text("返回"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WebViewPage extends StatefulWidget {
  @override
  _WebViewState createState() => new _WebViewState();

}

class _WebViewState extends State <WebViewPage>{
  var _controller;
  var _title = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text('$_title'),
        ),
        body: Center(
            child: WebView(
              initialUrl: "https://www.baidu.com",
              //JS执行模式 是否允许JS执行
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              onPageFinished: (url) {
                _controller.evaluateJavascript("document.title").then((result){
                  print(result);
                  setState(() {
                    _title = result.replaceAll("\"([^\"]*)\"", "");
                  });
                }
                );
              },
            )
        )
    );
  }
}

