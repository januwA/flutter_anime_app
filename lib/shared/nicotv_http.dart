import 'package:flutter_video_app/shared/globals.dart';
import 'package:http_interceptor/http_interceptor.dart';

HttpClientWithInterceptor nicoTvHttp = HttpClientWithInterceptor.build(
  interceptors: [
    BaseUrlInterceptor(),
  ],
);

class BaseUrlInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    String url = data.url.toString();
    if (url.startsWith('/')) {
      data.url = Uri.parse(nicoTvBaseUrl + url);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    return data;
  }
}
