import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final String _key = 'proxyAddress';
  SettingsService() {
    proxyAddress = _dProxyAddress;
    SharedPreferences.getInstance().then((value) {
      _prefs ??= value;
      proxyAddress = _prefs.getString(_key);
    });
  }

  SharedPreferences _prefs;

  /// 'http://96.45.181.208:6677/api/nicotv?url='
  /// 小黄鸡服务器: 'http://47.93.223.14:6677/api/nicotv?url='
  /// 默认代理地址
  final _dProxyAddress = '47.93.223.14:6677';

  String proxyAddress;

  // 重置为默认代理
  Future<bool> resetProxy() async {
    proxyAddress = _dProxyAddress;
    return _prefs.setString(_key, proxyAddress);
  }

  Future<bool> setProxy(String newProxyAddress) async {
    proxyAddress = newProxyAddress;
    return _prefs.setString(_key, proxyAddress);
  }
}
