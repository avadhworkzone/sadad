
class AddBankAccountModel {
  AddBankAccountModel({
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
      this.bankId,});

  AddBankAccountModel.fromJson(dynamic json) {
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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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
    return map;
  }

}
class AddSetAsDefaultViewModel {
  AddSetAsDefaultViewModel({
    this.primary,
 });
  AddSetAsDefaultViewModel.fromJson(dynamic json) {
    primary = json['primary'];
  }
  bool? primary;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['primary'] = primary;
    return map;
  }

}
