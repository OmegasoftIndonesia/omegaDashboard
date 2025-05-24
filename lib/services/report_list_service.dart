import '../models/responses/dashboard_query_response.dart';
import '../models/responses/department_model.dart';
import '../models/responses/detail_department_model.dart';
import '../repositories/report_list_repository.dart';

class ReportListService {
  final ReportListRepository repository = ReportListRepository();

  Future<List<DepartmentModel>> getDepartement() async {
    try {
      return await repository.getDepartment();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DetailDepartmentModel>> getDetailDepartement(
      String department) async {
    try {
      return await repository.getDetailDepartment(department);
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
}
