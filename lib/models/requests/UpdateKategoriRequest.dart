class UpdateKategoriRequest {
  String? token;
  String? targetomzetbulan;
  String? cabang;

  UpdateKategoriRequest({this.token, this.targetomzetbulan, this.cabang});

  UpdateKategoriRequest.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    targetomzetbulan = json['targetomzetbulan'];
    cabang = json['cabang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['targetomzetbulan'] = this.targetomzetbulan;
    data['cabang'] = this.cabang;
    return data;
  }
}