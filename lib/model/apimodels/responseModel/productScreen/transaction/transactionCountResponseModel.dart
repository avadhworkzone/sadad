class TransactionCountResponseModel {
  var count;
  var totaltransferAmount;

  TransactionCountResponseModel({this.count, this.totaltransferAmount});

  TransactionCountResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totaltransferAmount = json['totaltransferAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['totaltransferAmount'] = this.totaltransferAmount;
    return data;
  }
}
