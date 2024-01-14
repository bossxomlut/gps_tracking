import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LogResponseInterceptor extends Interceptor {
  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (!kReleaseMode) {
      try {
        log('HTTP response logging - start');
        log("---statusCode: ${response.statusCode}");
        log("---data:\n${jsonEncode(response.data)}");
        log('HTTP response logging - complete');
      } catch (e) {}
    }

    return super.onResponse(response, handler);
  }
}
