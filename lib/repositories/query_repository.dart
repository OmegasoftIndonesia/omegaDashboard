import 'package:dio/dio.dart';
import 'package:omega_dashboard/models/requests/dashboardRequest.dart';
import 'package:omega_dashboard/models/responses/dashboardResponse.dart';
import '../models/responses/dashboard_query_response.dart';
import '../models/responses/query_branch_response.dart';
import '../constants/constants.dart';
import '../models/requests/query_request.dart';
import '../constants/url_constants.dart';
import '../utils/injector.dart';
import '../utils/shared_prefs.dart';

class QueryRepository {
  final Dio dio = locator<Dio>();
  PreferencesUtil util = PreferencesUtil();

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

  Future<dashboardResponse> getDashboardData(String pilihan, tglawal, tglakhir) async {
    try {
      dashboardRequest request = dashboardRequest();
      request.token = Constants.appToken;
      request.branch = util.getString(PreferencesUtil.branch);
      request.cabang = util.getString(PreferencesUtil.cabang);
      request.pilih = pilihan;
      request.email = util.getString(PreferencesUtil.email);
      request.tglawal = tglawal;
      request.tglakhir = tglakhir;

      dio.options.contentType = "application/json";
      Response response =
      await dio.post(UrlConstants.dashboardAPI, data: request.toJson());

      return dashboardResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
