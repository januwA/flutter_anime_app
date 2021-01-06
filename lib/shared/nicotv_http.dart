import 'package:ajanuw_http/ajanuw_http.dart';
import 'package:flutter_video_app/service/settings.service.dart';

import '../main.dart';

class HeaderInterceptor extends AjanuwHttpInterceptors {
  final settings = getIt<SettingsService>();

  get url => 'http://${settings.proxyAddress.trim()}/api/nicotv?url=';

  @override
  Future<AjanuwHttpConfig> request(AjanuwHttpConfig config) async {
    config.url = Uri.parse(url + Uri.encodeComponent(config.url.toString()));
    return config;
  }

  @override
  Future<BaseResponse> response(
      BaseResponse response, AjanuwHttpConfig config) async {
    return response;
  }
}

var nicotvHttp = AjanuwHttp()
  ..config.baseURL = 'http://www.nicotv.club'
  ..interceptors.add(HeaderInterceptor());
