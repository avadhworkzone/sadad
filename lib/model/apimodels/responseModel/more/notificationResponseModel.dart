class NotificationResponseModel {
  NotificationResponseModel({
      this.receivedpaymentpush, 
      this.receivedpaymentsms, 
      this.receivedpaymentemail, 
      this.transferpush, 
      this.transfersms, 
      this.transferemail, 
      this.receivedorderspush, 
      this.receivedordersms, 
      this.receivedorderemail, 
      this.isplayasound, 
      this.isArabic, 
      this.id, 
      this.userId,});

  NotificationResponseModel.fromJson(dynamic json) {
    receivedpaymentpush = json['receivedpaymentpush'];
    receivedpaymentsms = json['receivedpaymentsms'];
    receivedpaymentemail = json['receivedpaymentemail'];
    transferpush = json['transferpush'];
    transfersms = json['transfersms'];
    transferemail = json['transferemail'];
    receivedorderspush = json['receivedorderspush'];
    receivedordersms = json['receivedordersms'];
    receivedorderemail = json['receivedorderemail'];
    isplayasound = json['isplayasound'];
    isArabic = json['isArabic'];
    id = json['id'];
    userId = json['userId'];
  }
  bool? receivedpaymentpush;
  bool? receivedpaymentsms;
  bool? receivedpaymentemail;
  bool? transferpush;
  bool? transfersms;
  bool? transferemail;
  bool? receivedorderspush;
  bool? receivedordersms;
  bool? receivedorderemail;
  String? isplayasound;
  bool? isArabic;
  int? id;
  int? userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['receivedpaymentpush'] = receivedpaymentpush;
    map['receivedpaymentsms'] = receivedpaymentsms;
    map['receivedpaymentemail'] = receivedpaymentemail;
    map['transferpush'] = transferpush;
    map['transfersms'] = transfersms;
    map['transferemail'] = transferemail;
    map['receivedorderspush'] = receivedorderspush;
    map['receivedordersms'] = receivedordersms;
    map['receivedorderemail'] = receivedorderemail;
    map['isplayasound'] = isplayasound;
    map['isArabic'] = isArabic;
    map['id'] = id;
    map['userId'] = userId;
    return map;
  }

}