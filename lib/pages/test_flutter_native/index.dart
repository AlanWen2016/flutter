import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


/// 测试页面
class TestPageIndex extends StatelessWidget {
  /// 构造函数
  const TestPageIndex();

  /// 创建数据传输句柄
  static const platform = MethodChannel('com.example.flutter_app_1');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
        future: _getBatteryLevel(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.error != null) {
            return Container(
              child: Text(
                snapshot.error.toString()
              ),
            );
          }
          return Container(
            child: snapshot.data,
          );
        });
  }

  Future<Widget> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
      print(batteryLevel);
    } on PlatformException catch (e) {
      print(e.message);
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
    return Center(
      child: Text(batteryLevel),
    );
  }
}