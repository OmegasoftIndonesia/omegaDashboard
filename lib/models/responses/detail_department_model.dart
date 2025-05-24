class DetailDepartmentModel {
  String? title;
  int? iD;

  DetailDepartmentModel({this.title, this.iD});

  DetailDepartmentModel.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    iD = json['ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Title'] = title;
    data['ID'] = iD;
    return data;
  }
}
