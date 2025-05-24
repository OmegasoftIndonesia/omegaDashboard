class TrackingRequest {
  String? token;
  String? branch;
  String? pilihanbranch;
  String? staff;
  String? tgl;

  TrackingRequest(
      {this.token, this.branch, this.pilihanbranch, this.staff, this.tgl});

  TrackingRequest.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    branch = json['branch'];
    pilihanbranch = json['pilihanbranch'];
    staff = json['staff'];
    tgl = json['tgl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['branch'] = branch;
    data['pilihanbranch'] = pilihanbranch;
    data['staff'] = staff;
    data['tgl'] = tgl;
    return data;
  }
}
