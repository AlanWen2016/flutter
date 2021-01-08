import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({
    Key key,
    this.initValue: 0
  });
  final int initValue;
  @override
  _CounterWidgetState createState() => new _CounterWidgetState();
}


class _CounterWidgetState extends State<CounterWidget> {
  int _counter;
  @override
  void initState() {
    super.initState();
    _counter = widget.initValue;
    print('initState');
  }
  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('$_counter'),
          //点击后计数器自增
          onPressed:()=>setState(()=> ++_counter,
          ),
        ),
      ),
    );
  }
  @override
  void didUpdateWidget(CounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }

  @override
  void deactivate() {
    super.deactivate();
    print("deactive");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  void reassemble() {
    super.reassemble();
    print("reassemble");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}


class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'http://km.alanwen.online/',
    );
  }
}

// 定义一个新的路由页面
class NewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('网络加载H5页面'),
        ),
        body: Center(
            child: WebView(
              initialUrl: "https://www.baidu.com",
              //JS执行模式 是否允许JS执行
              javascriptMode: JavascriptMode.unrestricted,
            )
        )
    );
  }
}
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image(
                image: AssetImage("images/12.png"),
                width: 100.0
            ),
            new Text(
                'Hello world Hello worldHello worldHello worldHello worldHello worldHello world2222222222222222222222222222222222222222222222222',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 18.0,
                  height: 1.2,
                )
            ),
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            FlatButton(
              child: Text("平台主干"),
              textColor: Colors.blue,
              onPressed: () {
                //导航到新路由
                Navigator.push( context,
                    MaterialPageRoute(builder: (context) {
                      return NewRoute();
                    }));
              },
            ),
            FlatButton(
              child: Text("计数器"),
              textColor: Colors.blue,
              onPressed: () {
                //导航到新路由
                Navigator.push( context,
                    MaterialPageRoute(builder: (context) {
                      return CounterWidget();
                    }));
              },
            ),
            FlatButton(
              child: Text("open new route 2"),
              textColor: Colors.red,
              onPressed: () {
                //导航到新路由
                Navigator.push( context,
                    MaterialPageRoute(builder: (context) {
                      return WebViewExample();
                    }));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}