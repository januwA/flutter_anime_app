import 'package:ajanuw_http/ajanuw_http.dart';

class HeaderInterceptor extends AjanuwHttpInterceptors {
  @override
  Future<AjanuwHttpConfig> request(AjanuwHttpConfig config) async {
    // printf('[[ request url ]] %s', config.url.toString());
    config.url = Uri.parse('http://96.45.181.208:8888/api/nicotv?url=' +
        Uri.encodeComponent(config.url.toString()));
    // printf('[[ request redirect to]] %s', config.url.toString());
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
