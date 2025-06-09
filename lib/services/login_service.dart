import '../utils/shared_prefs.dart';
import '../repositories/login_repository.dart';
import '../models/responses/login_response.dart';

class LoginService {
  PreferencesUtil util = PreferencesUtil();
  final LoginRepository repository = LoginRepository();

  Future<List<LoginResponse>> doLogin(String email, password) async {
    try {
      List<LoginResponse> response = await repository.login(email, password);
      if (response[0].result == "100") {
        util.putString(PreferencesUtil.email, email);
        util.putString(PreferencesUtil.kodestaff, response[0].kodestaff!);
        util.putString(
            PreferencesUtil.branch, response[0].kodestaff!.substring(0, 5));
        util.putString(
            PreferencesUtil.cabang, response[0].kodestaff!.substring(0, 5));
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
