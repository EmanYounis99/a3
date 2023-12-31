import 'dart:convert';

import 'package:dio/dio.dart';

import '../../featues/common_utils/log_utils.dart';


class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["Accept"] = "application/json";
    super.onRequest(options, handler);
  }
}

///Log interceptor settings
class LoggingInterceptor extends Interceptor {
  DateTime? startTime;
  DateTime? endTime;

  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    startTime = DateTime.now();
    Log.d("----------Request Start---------");
    Log.i(" path :${options.path}");

    // if(options.path.contains(Api.getCountriesListApiCall)){
    //   options.baseUrl=Api.nartaqiBaseUrl;
    // }

    ///print full path request
    if (options.queryParameters.isEmpty) {
      if (options.path.contains(options.baseUrl)) {
        Log.i("RequestUrl:${options.path}");
      } else {
        Log.i("RequestUrl:${options.baseUrl}${options.path}");
      }
    } else {
      ///If queryParameters is not empty, splice into a complete URl
      Log.i(
          "RequestUrl:${options.baseUrl}${options.path}?${Transformer.urlEncodeMap(options.queryParameters)}");
    }

    Log.w("RequestMethod:${options.method}");
    Log.w("RequestHeaders:${options.headers}");
    Log.w("RequestContentType:${options.contentType}");
    Log.w("RequestDataOptions:${options.data is FormData ? (options.data as FormData).fields.toString() : options.data.toString()}");

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    endTime = DateTime.now();
    //Request duration
    int duration = endTime!.difference(startTime!).inMilliseconds;
    Log.i("----------Response Data ${jsonDecode(response.data)} ---------");
    handleStatus(response, handler);
    Log.i("----------End Request $duration millisecond---------");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Log.e("--------------Error-----------");
    Log.e('${err.message}');
    super.onError(err, handler);
  }

  void handleStatus(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    switch (response.statusCode) {

    }
  }
}
