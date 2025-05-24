import '../models/responses/get_staff_position_history_response.dart';
import '../models/responses/get_staff_position_response.dart';
import '../models/responses/get_branch_kc_response.dart';
import '../models/responses/get_staff_response.dart';
import '../repositories/tracking_repository.dart';

class TrackingService {
  final TrackingRepository repository = TrackingRepository();

  Future<GetBranchKCResponse> getBranch() async {
    try {
      return await repository.getBranch();
    } catch (e) {
      rethrow;
    }
  }

  Future<GetStaffResponse> getStaff(String selectedBranch) async {
    try {
      return await repository.getStaff(selectedBranch);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetStaffPositionResponse> getStaffPosition(
      String selectedBranch) async {
    try {
      return await repository.getStaffPosition(selectedBranch);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetStaffPositionHistoryResponse> getStaffPositionHistory(
      String selectedBranch, String staff, String tgl) async {
    try {
      return await repository.getStaffPositionHistory(
          selectedBranch, staff, tgl);
    } catch (e) {
      rethrow;
    }
  }
}
