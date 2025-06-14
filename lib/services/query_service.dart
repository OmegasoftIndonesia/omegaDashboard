import 'package:omega_dashboard/models/responses/dashboardResponse.dart';
import 'package:omega_dashboard/models/responses/getBranchfromEmailResponse.dart';

import '../models/responses/dashboard_query_response.dart';
import '../repositories/query_repository.dart';
import '../models/responses/query_branch_response.dart';

class QueryService {
  final QueryRepository repository = QueryRepository();

  Future<List<QueryBranchResponse>> getBranch(String query) async {
    try {
      return await repository.getBranch(query);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DashboardQueryResponse>> getDashboardQuery(String query) async {
    try {
      return await repository.getDashboardQuery(query);
    } catch (e) {
      rethrow;
    }
  }

  Future<dashboardResponse> getDashboardData(String pilihan, branch, cabang, tglawal, tglakhir) async {
    try {
      return await repository.getDashboardData(pilihan, branch, cabang, tglawal, tglakhir);
    } catch (e) {
      rethrow;
    }
  }

  Future<getBranchfromEmailResponse> getBranchAPI() async {
    try {
      return await repository.getBranchAPI();
    } catch (e) {
      rethrow;
    }
  }
}
