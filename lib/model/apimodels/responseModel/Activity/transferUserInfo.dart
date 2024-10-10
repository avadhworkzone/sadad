class TransferUserDetailResponse {
  var name;
  var sadadId;
  bool? agreement;
  var roleId;
  var cellnumber;
  bool? verificationStatus;
  Merchant? merchant;

  TransferUserDetailResponse(
      {this.name,
      this.sadadId,
      this.agreement,
      this.roleId,
      this.cellnumber,
      this.verificationStatus,
      this.merchant});

  TransferUserDetailResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sadadId = json['SadadId'];
    agreement = json['agreement'];
    roleId = json['roleId'];
    cellnumber = json['cellnumber'];
    verificationStatus = json['verificationStatus'];
    merchant = json['merchant'] != null
        ? new Merchant.fromJson(json['merchant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['SadadId'] = this.sadadId;
    data['agreement'] = this.agreement;
    data['roleId'] = this.roleId;
    data['cellnumber'] = this.cellnumber;
    data['verificationStatus'] = this.verificationStatus;
    if (this.merchant != null) {
      data['merchant'] = this.merchant!.toJson();
    }
    return data;
  }
}

class Merchant {
  bool? isOwnMerchant;

  Merchant({this.isOwnMerchant});

  Merchant.fromJson(Map<String, dynamic> json) {
    isOwnMerchant = json['isOwnMerchant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isOwnMerchant'] = this.isOwnMerchant;
    return data;
  }
}
