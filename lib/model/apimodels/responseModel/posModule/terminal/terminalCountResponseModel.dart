class TerminalCountResponseModel {
  var count;

  TerminalCountResponseModel({this.count});

  TerminalCountResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}
