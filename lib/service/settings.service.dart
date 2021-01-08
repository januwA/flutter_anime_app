import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final String _key = 'proxyAddress';

  /// 默认代理地址
  final _dProxyAddress = '96.45.181.208:6677';

  SettingsService() {
    proxyAddress = _dProxyAddress;
    SharedPreferences.getInstance().then((value) {
      _prefs ??= value;
      String cache = _prefs.getString(_key);
      if (cache.isNotEmpty) proxyAddress = cache;
    });
  }

  SharedPreferences _prefs;

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
