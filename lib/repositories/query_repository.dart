import 'package:dio/dio.dart';
import '../models/responses/dashboard_query_response.dart';
import '../models/responses/query_branch_response.dart';
import '../constants/constants.dart';
import '../models/requests/query_request.dart';
import '../constants/url_constants.dart';
import '../utils/injector.dart';

class QueryRepository {
  final Dio dio = locator<Dio>();

  Future<List<QueryBranchResponse>> getBranch(String query) async {
    try {
      QueryRequest request = QueryRequest();
      request.token = Constants.appToken;
      request.action = "query";
      request.db = "oc";
      request.query = query;

      dio.options.contentType = "application/x-www-form-urlencoded";
      Response response =
          await dio.post(UrlConstants.serviceNoteJS, data: request.toJson());

      return ((response.data) as List)
          .map((data) => QueryBranchResponse.fromJson(data))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DashboardQueryResponse>> getDashboardQuery(String query) async {
    try {
      QueryRequest request = QueryRequest();
      request.token = Constants.appToken;
      request.action = "query";
      request.db = "oc";
      request.query = query;

      dio.options.contentType = "application/x-www-form-urlencoded";
      Response response =
          await dio.post(UrlConstants.serviceNoteJS, data: request.toJson());

      return ((response.data) as List)
          .map((data) => DashboardQueryResponse.fromJson(data))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
