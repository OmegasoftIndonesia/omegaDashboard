class QueryRequest {
  String? token;
  String? db;
  String? action;
  String? query;

  QueryRequest({this.token, this.db, this.action, this.query});

  QueryRequest.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    db = json['db'];
    action = json['action'];
    query = json['query'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['db'] = db;
    data['action'] = action;
    data['query'] = query;
    return data;
  }
}
