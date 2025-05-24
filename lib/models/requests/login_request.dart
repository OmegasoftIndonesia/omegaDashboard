class LoginRequest {
  String? token;
  String? email;
  String? pass;

  LoginRequest({this.token, this.email, this.pass});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    email = json['email'];
    pass = json['pass'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['email'] = email;
    data['pass'] = pass;
    return data;
  }
}
