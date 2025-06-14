class getBranchfromEmailResponse {
  String? status;
  String? message;
  List<DataBranch>? data;

  getBranchfromEmailResponse({this.status, this.message, this.data});

  getBranchfromEmailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataBranch>[];
      json['data'].forEach((v) {
        data!.add(new DataBranch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataBranch {
  String? cabang;
  String? namaCabang;
  String? jenisUsaha;
  String? kode;

  DataBranch({this.cabang, this.namaCabang, this.jenisUsaha, this.kode});

  DataBranch.fromJson(Map<String, dynamic> json) {
    cabang = json['Cabang'];
    namaCabang = json['NamaCabang'];
    jenisUsaha = json['JenisUsaha'];
    kode = json['Kode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Cabang'] = this.cabang;
    data['NamaCabang'] = this.namaCabang;
    data['JenisUsaha'] = this.jenisUsaha;
    data['Kode'] = this.kode;
    return data;
  }
}