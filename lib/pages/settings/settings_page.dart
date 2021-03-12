import 'package:flutter/material.dart';
import 'package:anime_app/main.dart';
import 'package:anime_app/service/settings.service.dart';
import 'package:anime_app/utils/open_browser.dart';
import 'package:toast/toast.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/SettingsPage';
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final settings = getIt<SettingsService>();
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = settings.proxyAddress;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _resetProxy() async {
    final ok = await settings.resetProxy();
    if (ok) {
      controller.text = settings.proxyAddress;
      Toast.show('已重置', context);
    } else {
      Toast.show('操作失败', context);
    }
  }

  void _setProxy() async {
    final ok = await settings.setProxy(controller.text);
    if (ok)
      Toast.show('OK', context);
    else
      Toast.show('设置失败', context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: '代理',
                    ),
                  ),
                ),
                SizedBox(width: 4),
                ElevatedButton(
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(
                        TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                  onPressed: _setProxy,
                  child: Text('确定'),
                ),
                SizedBox(width: 4),
                ElevatedButton(
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(
                        TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                  onPressed: _resetProxy,
                  child: Text('重置'),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () =>
                openBrowser('https://github.com/januwA/nicotv-server'),
            child: Text(
              '设置自己的代理服务器',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
