class ProductCountResponseModel {
  int? count;

  ProductCountResponseModel({this.count});

  ProductCountResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}
