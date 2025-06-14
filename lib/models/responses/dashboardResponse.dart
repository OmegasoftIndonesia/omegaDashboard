class dashboardResponse {
  String? status;
  String? message;
  List<DataDahsboard>? data;

  dashboardResponse({this.status, this.message, this.data});

  dashboardResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataDahsboard>[];
      json['data'].forEach((v) {
        data!.add(new DataDahsboard.fromJson(v));
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

class DataDahsboard {
  String? kode;
  String? kodeket;
  String? keterangan;
  String? nilai1;
  String? nilai2;
  String? nilai3;
  String? grandtotalsales;
  String? netsales;
  String? returSales;
  String? grandTotalSalesMinusReturSales;

  DataDahsboard(
      {this.kode,
        this.kodeket,
        this.keterangan,
        this.nilai1,
        this.nilai2,
        this.nilai3,
        this.grandtotalsales,
        this.netsales,
        this.returSales,
        this.grandTotalSalesMinusReturSales});

  DataDahsboard.fromJson(Map<String, dynamic> json) {
    kode = json['kode'];
    kodeket = json['kodeket'];
    keterangan = json['keterangan'];
    nilai1 = json['nilai1'];
    nilai2 = json['nilai2'];
    nilai3 = json['nilai3'];
    grandtotalsales = json['grandtotalsales'];
    netsales = json['netsales'];
    returSales = json['ReturSales'];
    grandTotalSalesMinusReturSales = json['GrandTotalSalesMinusReturSales'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kode'] = this.kode;
    data['kodeket'] = this.kodeket;
    data['keterangan'] = this.keterangan;
    data['nilai1'] = this.nilai1;
    data['nilai2'] = this.nilai2;
    data['nilai3'] = this.nilai3;
    data['grandtotalsales'] = this.grandtotalsales;
    data['netsales'] = this.netsales;
    data['ReturSales'] = this.returSales;
    data['GrandTotalSalesMinusReturSales'] =
        this.grandTotalSalesMinusReturSales;
    return data;
  }
}