class GetStaffPositionResponse {
  String? status;
  String? message;
  List<Data>? data;

  GetStaffPositionResponse({this.status, this.message, this.data});

  GetStaffPositionResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? kode;
  String? createDate;
  String? latitude;
  String? longitude;
  String? namaAlias;
  String? email;

  Data(
      {this.kode,
        this.createDate,
        this.latitude,
        this.longitude,
        this.namaAlias,
        this.email});

  Data.fromJson(Map<String, dynamic> json) {
    kode = json['Kode'];
    createDate = json['CreateDate'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    namaAlias = json['NamaAlias'];
    email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Kode'] = kode;
    data['CreateDate'] = createDate;
    data['Latitude'] = latitude;
    data['Longitude'] = longitude;
    data['NamaAlias'] = namaAlias;
    data['Email'] = email;
    return data;
  }
}
