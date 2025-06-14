class getBranchfromEmailRequest {
  String? token;
  String? email;

  getBranchfromEmailRequest({this.token, this.email});

  getBranchfromEmailRequest.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['email'] = this.email;
    return data;
  }
}