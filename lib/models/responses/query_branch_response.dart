class QueryBranchResponse {
  String? cabang;
  String? namaCabang;
  String? jenisUsaha;
  String? kode;

  QueryBranchResponse(
      {this.cabang, this.namaCabang, this.jenisUsaha, this.kode});

  QueryBranchResponse.fromJson(Map<String, dynamic> json) {
    cabang = json['Cabang'];
    namaCabang = json['NamaCabang'];
    jenisUsaha = json['JenisUsaha'];
    kode = json['Kode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Cabang'] = cabang;
    data['NamaCabang'] = namaCabang;
    data['JenisUsaha'] = jenisUsaha;
    data['Kode'] = kode;
    return data;
  }
}
