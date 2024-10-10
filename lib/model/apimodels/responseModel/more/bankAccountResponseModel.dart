class BankAccountResponseModel {
  BankAccountResponseModel({
      this.ibannumber, 
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
      this.bank, 
      this.userbankstatus,});

  BankAccountResponseModel.fromJson(dynamic json) {
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
    bank = json['bank'] != null ? Bank.fromJson(json['bank']) : null;
    userbankstatus = json['userbankstatus'] != null ? Userbankstatus.fromJson(json['userbankstatus']) : null;
  }

  String? ibannumber;
  String? authorizationdetails;
  bool? primary;
  int? createdby;
  int? modifiedby;
  int? id;
  int? userId;
  dynamic deletedAt;
  String? created;
  String? modified;
  int? userbankstatusId;
  int? bankId;
  Bank? bank;
  Userbankstatus? userbankstatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic> {};
    map['ibannumber'] = ibannumber;
    map['authorizationdetails'] = authorizationdetails;
    map['primary'] = primary;
    map['createdby'] = createdby;
    map['modifiedby'] = modifiedby;
    map['id'] = id;
    map['userId'] = userId;
    map['deletedAt'] = deletedAt;
    map['created'] = created;
    map['modified'] = modified;
    map['userbankstatusId'] = userbankstatusId;
    map['bankId'] = bankId;
    if (bank != null) {
      map['bank'] = bank?.toJson();
    }
    if (userbankstatus != null) {
      map['userbankstatus'] = userbankstatus?.toJson();
    }
    return map;
  }

}

class Userbankstatus {
  Userbankstatus({
      this.name, 
      this.createdby, 
      this.modifiedby, 
      this.id,});

  Userbankstatus.fromJson(dynamic json) {
    name = json['name'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    id = json['id'];
  }
  String? name;
  dynamic createdby;
  dynamic modifiedby;
  int? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['createdby'] = createdby;
    map['modifiedby'] = modifiedby;
    map['id'] = id;
    return map;
  }

}

class Bank {
  Bank({
      this.name, 
      this.logo, 
      this.status, 
      this.createdby, 
      this.modifiedby, 
      this.ibannumber, 
      this.id, 
      this.deletedAt,});

  Bank.fromJson(dynamic json) {
    name = json['name'];
    logo = json['logo'];
    status = json['status'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    ibannumber = json['ibannumber'];
    id = json['id'];
    deletedAt = json['deletedAt'];
  }
  String? name;
  String? logo;
  bool? status;
  int? createdby;
  int? modifiedby;
  String? ibannumber;
  int? id;
  dynamic deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['logo'] = logo;
    map['status'] = status;
    map['createdby'] = createdby;
    map['modifiedby'] = modifiedby;
    map['ibannumber'] = ibannumber;
    map['id'] = id;
    map['deletedAt'] = deletedAt;
    return map;
  }

}