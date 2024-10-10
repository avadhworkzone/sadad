class UserBankListResponseModel {
  var ibannumber;
  var authorizationdetails;
  bool? primary;
  var createdby;
  var modifiedby;
  var id;
  var userId;
  var deletedAt;
  var created;
  var modified;
  var userbankstatusId;
  var bankId;
  Bank? bank;

  UserBankListResponseModel(
      {this.ibannumber,
      this.authorizationdetails,
      this.primary,
      this.createdby,
      this.modifiedby,
      this.id,
      this.userId,
      this.deletedAt,
      this.created,
      this.modified,
      this.userbankstatusId,
      this.bankId,
      this.bank});

  UserBankListResponseModel.fromJson(Map<String, dynamic> json) {
    ibannumber = json['ibannumber'];
    authorizationdetails = json['authorizationdetails'];
    primary = json['primary'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    id = json['id'];
    userId = json['userId'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    modified = json['modified'];
    userbankstatusId = json['userbankstatusId'];
    bankId = json['bankId'];
    bank = json['bank'] != null ? new Bank.fromJson(json['bank']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ibannumber'] = this.ibannumber;
    data['authorizationdetails'] = this.authorizationdetails;
    data['primary'] = this.primary;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['userbankstatusId'] = this.userbankstatusId;
    data['bankId'] = this.bankId;
    if (this.bank != null) {
      data['bank'] = this.bank!.toJson();
    }
    return data;
  }
}

class Bank {
  var name;
  var logo;
  bool? status;
  var createdby;
  var modifiedby;
  var ibannumber;
  var id;
  var deletedAt;

  Bank(
      {this.name,
      this.logo,
      this.status,
      this.createdby,
      this.modifiedby,
      this.ibannumber,
      this.id,
      this.deletedAt});

  Bank.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    logo = json['logo'];
    status = json['status'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    ibannumber = json['ibannumber'];
    id = json['id'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['status'] = this.status;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['ibannumber'] = this.ibannumber;
    data['id'] = this.id;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}
