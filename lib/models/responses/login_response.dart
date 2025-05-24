class LoginResponse {
  String? pesan;
  String? result;
  String? kodestaff;

  LoginResponse({this.pesan, this.result, this.kodestaff});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    pesan = json['pesan'];
    result = json['result'];
    kodestaff = json['kodestaff'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pesan'] = pesan;
    data['result'] = result;
    data['kodestaff'] = kodestaff;
    return data;
  }
}