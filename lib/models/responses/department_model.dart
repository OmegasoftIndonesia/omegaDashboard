class DepartmentModel {
  String? dept;

  DepartmentModel({this.dept});

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    dept = json['Dept'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Dept'] = dept;
    return data;
  }
}
