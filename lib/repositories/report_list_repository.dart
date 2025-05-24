import 'package:dio/dio.dart';
import 'package:omega_dashboard/models/responses/detail_department_model.dart';

import '../constants/query_report_list.dart';
import '../models/responses/dashboard_query_response.dart';
import '../models/responses/department_model.dart';
import '../constants/constants.dart';
import '../models/requests/query_request.dart';
import '../constants/url_constants.dart';
import '../utils/injector.dart';

class ReportListRepository {
  final Dio dio = locator<Dio>();

  Future<List<DepartmentModel>> getDepartment() async {
    try {
      QueryRequest request = QueryRequest();
      request.token = Constants.appToken;
      request.action = "query";
      request.db = "oc";
      request.query = QueryReportList.queryDepartment;

      dio.options.contentType = "application/x-www-form-urlencoded";
      Response response =
          await dio.post(UrlConstants.serviceNoteJS, data: request.toJson());

      return ((response.data) as List)
          .map((data) => DepartmentModel.fromJson(data))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DetailDepartmentModel>> getDetailDepartment(
      String department) async {
    try {
      QueryRequest request = QueryRequest();
      request.token = Constants.appToken;
      request.action = "query";
      request.db = "oc";
      request.query = QueryReportList.queryDetailDepartment(department);

      dio.options.contentType = "application/x-www-form-urlencoded";
      Response response =
          await dio.post(UrlConstants.serviceNoteJS, data: request.toJson());

      return ((response.data) as List)
          .map((data) => DetailDepartmentModel.fromJson(data))
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
