class GetBranchKCResponse {
  String? status;
  String? message;
  List<Data>? data;

  GetBranchKCResponse({this.status, this.message, this.data});

  GetBranchKCResponse.fromJson(Map<String, dynamic> json) {
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
  String? branch;
  String? companyHeader;
  String? namaCabang;
  String? alamatHeader;

  Data({this.branch, this.companyHeader, this.namaCabang, this.alamatHeader});

  Data.fromJson(Map<String, dynamic> json) {
    branch = json['Branch'];
    companyHeader = json['CompanyHeader'];
    namaCabang = json['NamaCabang'];
    alamatHeader = json['AlamatHeader'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Branch'] = branch;
    data['CompanyHeader'] = companyHeader;
    data['NamaCabang'] = namaCabang;
    data['AlamatHeader'] = alamatHeader;
    return data;
  }
}