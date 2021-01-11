import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 需要在pubspec.yaml增加该模块
import 'package:webview_flutter/webview_flutter.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';




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
            new RaisedButton(
             child: Text('拍照'),
            onPressed: () async {
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
            },
           ),
            new RaisedButton(
             child: Text('扫码'),
            onPressed: () async {
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

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}

