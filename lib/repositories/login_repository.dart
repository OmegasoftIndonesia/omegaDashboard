import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/requests/login_request.dart';
import '../models/responses/login_response.dart';
import '../constants/constants.dart';
import '../constants/url_constants.dart';
import '../utils/injector.dart';

class LoginRepository {
  final Dio dio = locator<Dio>();

  Future<List<LoginResponse>> login(String email, String pass) async {
    try {
      LoginRequest request = LoginRequest();
      request.token = Constants.appToken;
      request.email = email;
      request.pass = pass;

      dio.options.contentType = "application/x-www-form-urlencoded";
      Response response =
          await dio.post(UrlConstants.loginEndpoint, data: request.toJson());

      return ((jsonDecode(response.data)) as List)
          .map((data) => LoginResponse.fromJson(data))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
