import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'logging_interceptors.dart';
import 'shared_prefs.dart';

GetIt locator = GetIt.instance;

Future baseDio() async {
  final options = BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  );

  var dio = Dio(options);

  dio.interceptors.add(DioLoggingInterceptor(level: Level.body));

  locator.registerSingleton<Dio>(dio);
}

Future setupLocator() async {
  PreferencesUtil? util = await PreferencesUtil.getInstance();
  locator.registerSingleton<PreferencesUtil>(util!);
}
