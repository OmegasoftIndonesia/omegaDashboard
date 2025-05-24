class GetStaffResponse {
  String? status;
  String? message;
  List<Data>? data;

  GetStaffResponse({this.status, this.message, this.data});

  GetStaffResponse.fromJson(Map<String, dynamic> json) {
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
  String? email;

  Data({this.kode, this.email});

  Data.fromJson(Map<String, dynamic> json) {
    kode = json['Kode'];
    email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Kode'] = kode;
    data['Email'] = email;
    return data;
  }
}
