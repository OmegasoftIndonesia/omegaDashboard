class DashboardQueryResponse {
  String? kode;
  String? kodeket;
  String? keterangan;
  var nilai1,
      nilai2,
      nilai3,
      grandtotalsales,
      netsales,
      returSales,
      grandTotalSalesMinusReturSales;

  DashboardQueryResponse(
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

  DashboardQueryResponse.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kode'] = kode;
    data['kodeket'] = kodeket;
    data['keterangan'] = keterangan;
    data['nilai1'] = nilai1;
    data['nilai2'] = nilai2;
    data['nilai3'] = nilai3;
    data['grandtotalsales'] = grandtotalsales;
    data['netsales'] = netsales;
    data['ReturSales'] = returSales;
    data['GrandTotalSalesMinusReturSales'] = grandTotalSalesMinusReturSales;
    return data;
  }
}
