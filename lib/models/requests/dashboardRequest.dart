class dashboardRequest {
  String? token;
  String? branch;
  String? cabang;
  String? pilih;
  String? email;
  String? tglawal;
  String? tglakhir;

  dashboardRequest(
      {this.token,
        this.branch,
        this.cabang,
        this.pilih,
        this.email,
        this.tglawal,
        this.tglakhir});

  dashboardRequest.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    branch = json['branch'];
    cabang = json['cabang'];
    pilih = json['pilih'];
    email = json['email'];
    tglawal = json['tglawal'];
    tglakhir = json['tglakhir'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['branch'] = this.branch;
    data['cabang'] = this.cabang;
    data['pilih'] = this.pilih;
    data['email'] = this.email;
    data['tglawal'] = this.tglawal;
    data['tglakhir'] = this.tglakhir;
    return data;
  }
}