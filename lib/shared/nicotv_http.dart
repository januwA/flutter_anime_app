import 'package:ajanuw_http/ajanuw_http.dart';
import 'package:anime_app/service/settings.service.dart';

import '../main.dart';

class HeaderInterceptor extends AjanuwHttpInterceptors {
  final settings = getIt<SettingsService>();

  get url => 'http://${settings.proxyAddress.trim()}/proxy/nicotv/';

  @override
  Future<AjanuwHttpConfig> request(AjanuwHttpConfig config) async {
    // 只留下path
    var _uri = config.url.replace(
      host: '',
      scheme: '',
    );

    config.url =
        Uri.parse(url + _uri.toString().replaceFirst(RegExp(r'/*'), ''));
    return config;
  }

  @override
  Future<BaseResponse> response(
      BaseResponse response, AjanuwHttpConfig config) async {
    return response;
  }
}

var nicotvHttp = AjanuwHttp()..interceptors.add(HeaderInterceptor());

var request = AjanuwHttp();
