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
      home: new ScaffoldRoute(),
      routes: enhanceRouter.Router().registerRouter(), // 路由配置
    );
  }
}

class ScaffoldRoute extends StatefulWidget {
  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //导航栏
        title: Text("开发测试"),
        backgroundColor: Color(0xff2b87f3), // 16进制，ff表示16进制的透明度
        actions: <Widget>[
          //导航栏右侧菜单
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
        ],
        leading: Builder(builder: (context) { // //导航栏最左侧Widget，常见为抽屉菜单按钮或返回按钮。
          return IconButton(
            icon: Icon(Icons.dashboard, color: Colors.white), //自定义图标
            onPressed: () {
              // 打开抽屉菜单
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      drawer: new MyDrawer(), //抽屉
      bottomNavigationBar: BottomNavigationBar( // 底部导航
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('个人中心')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      body: Center(
        child: Entrance(),
      ),
      floatingActionButton: FloatingActionButton( //悬浮按钮
          child: Icon(Icons.add),
          onPressed:_onAdd
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void _onAdd(){
  }
}


