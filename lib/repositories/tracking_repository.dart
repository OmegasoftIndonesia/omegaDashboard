import 'package:dio/dio.dart';
import '../models/responses/get_staff_position_history_response.dart';
import '../models/responses/get_staff_position_response.dart';
import '../models/responses/get_branch_kc_response.dart';
import '../models/responses/get_staff_response.dart';
import '../utils/shared_prefs.dart';
import '../models/requests/tracking_request.dart';
import '../constants/constants.dart';
import '../constants/url_constants.dart';
import '../utils/injector.dart';

class TrackingRepository {
  final PreferencesUtil util = PreferencesUtil();
  final Dio dio = locator<Dio>();

  Future<GetBranchKCResponse> getBranch() async {
    try {
      TrackingRequest request = TrackingRequest();
      request.token = Constants.appToken;
      request.branch = util.getString(PreferencesUtil.branch);
      request.pilihanbranch="";


      dio.options.contentType = "application/x-www-form-urlencoded";
      Response response = await dio.post(UrlConstants.trackingGetBranch,
          data: request.toJson());

      return GetBranchKCResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetStaffResponse> getStaff(String selectedBranch) async {
    try {
      TrackingRequest request = TrackingRequest();
      request.token = Constants.appToken;
      request.branch = selectedBranch;

      dio.options.contentType = "application/x-www-form-urlencoded";
      Response response =
          await dio.post(UrlConstants.trackingGetStaff, data: request.toJson());

      return GetStaffResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetStaffPositionResponse> getStaffPosition(
      String selectedBranch) async {
    try {
      TrackingRequest request = TrackingRequest();
      request.token = Constants.appToken;
      request.branch = util.getString(PreferencesUtil.branch);
      request.pilihanbranch = selectedBranch;

      dio.options.contentType = "application/x-www-form-urlencoded";
      Response response = await dio.post(UrlConstants.trackingGetStaffPosition,
          data: request.toJson());

      return GetStaffPositionResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetStaffPositionHistoryResponse> getStaffPositionHistory(
      String selectedBranch, String staff, String tgl) async {
    try {
      TrackingRequest request = TrackingRequest();
      request.token = Constants.appToken;
      request.branch = util.getString(PreferencesUtil.branch);
      request.staff = staff;
      request.tgl = tgl;

      dio.options.contentType = "application/x-www-form-urlencoded";
      Response response = await dio.post(
          UrlConstants.trackingGetStaffPositionHistory,
          data: request.toJson());

      return GetStaffPositionHistoryResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
