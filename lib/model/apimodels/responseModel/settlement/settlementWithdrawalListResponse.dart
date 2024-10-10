class SettlementWithdrawalListResponseModel {
  var amount;
  bool? verified;
  var verifiedby;
  var verifiedon;
  var message;
  var datetimeoftransfer;
  var bankreferenceno;
  var transferedamount;
  var transferedtoiban;
  var approvedby;
  var modifiedby;
  var withdrawnumber;
  var withdrawalrequeststatusId;
  var withdrawalcommission;
  var transferwithdrawalamount;
  var withdrawalservicecharge;
  var generatedby;
  var withdrawaltype;
  var requestNote;
  var rejectedReason;
  bool? isPartnerRewardWithdrawal;
  var availableFundWhileRequest;
  var payoutId;
  var id;
  var date;
  var userId;
  var userbankId;
  var created;
  var modified;
  var tranasactionId;
  Createdby? createdby;
  Userbank? userbank;
  Payout? payout;
  Payoutstatus? withdrawalrequeststatus;
  Createdby? user;

  SettlementWithdrawalListResponseModel(
      {this.amount,
      this.verified,
      this.verifiedby,
      this.verifiedon,
      this.message,
      this.datetimeoftransfer,
      this.bankreferenceno,
      this.transferedamount,
      this.transferedtoiban,
      this.approvedby,
      this.modifiedby,
      this.withdrawnumber,
      this.withdrawalrequeststatusId,
      this.withdrawalcommission,
      this.transferwithdrawalamount,
      this.withdrawalservicecharge,
      this.generatedby,
      this.withdrawaltype,
      this.requestNote,
      this.rejectedReason,
      this.isPartnerRewardWithdrawal,
      this.availableFundWhileRequest,
      this.payoutId,
      this.id,
      this.date,
      this.userId,
      this.userbankId,
      this.created,
      this.modified,
      this.tranasactionId,
      this.createdby,
      this.userbank,
      this.payout,
      this.withdrawalrequeststatus,
      this.user});

  SettlementWithdrawalListResponseModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    verified = json['verified'];
    verifiedby = json['verifiedby'];
    verifiedon = json['verifiedon'];
    message = json['message'];
    datetimeoftransfer = json['datetimeoftransfer'];
    bankreferenceno = json['bankreferenceno'];
    transferedamount = json['transferedamount'];
    transferedtoiban = json['transferedtoiban'];
    approvedby = json['approvedby'];
    modifiedby = json['modifiedby'];
    withdrawnumber = json['withdrawnumber'];
    withdrawalrequeststatusId = json['withdrawalrequeststatusId'];
    withdrawalcommission = json['withdrawalcommission'];
    transferwithdrawalamount = json['transferwithdrawalamount'];
    withdrawalservicecharge = json['withdrawalservicecharge'];
    generatedby = json['generatedby'];
    withdrawaltype = json['withdrawaltype'];
    requestNote = json['request_note'];
    rejectedReason = json['rejected_reason'];
    isPartnerRewardWithdrawal = json['isPartnerRewardWithdrawal'];
    availableFundWhileRequest = json['availableFundWhileRequest'];
    payoutId = json['payoutId'];
    id = json['id'];
    date = json['date'];
    userId = json['userId'];
    userbankId = json['userbankId'];
    created = json['created'];
    modified = json['modified'];
    tranasactionId = json['TranasactionId'];
    createdby = json['createdby'] != null
        ? new Createdby.fromJson(json['createdby'])
        : null;
    userbank = json['userbank'] != null
        ? new Userbank.fromJson(json['userbank'])
        : null;
    payout =
        json['payout'] != null ? new Payout.fromJson(json['payout']) : null;
    withdrawalrequeststatus = json['withdrawalrequeststatus'] != null
        ? new Payoutstatus.fromJson(json['withdrawalrequeststatus'])
        : null;
    user = json['user'] != null ? new Createdby.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['verified'] = this.verified;
    data['verifiedby'] = this.verifiedby;
    data['verifiedon'] = this.verifiedon;
    data['message'] = this.message;
    data['datetimeoftransfer'] = this.datetimeoftransfer;
    data['bankreferenceno'] = this.bankreferenceno;
    data['transferedamount'] = this.transferedamount;
    data['transferedtoiban'] = this.transferedtoiban;
    data['approvedby'] = this.approvedby;
    data['modifiedby'] = this.modifiedby;
    data['withdrawnumber'] = this.withdrawnumber;
    data['withdrawalrequeststatusId'] = this.withdrawalrequeststatusId;
    data['withdrawalcommission'] = this.withdrawalcommission;
    data['transferwithdrawalamount'] = this.transferwithdrawalamount;
    data['withdrawalservicecharge'] = this.withdrawalservicecharge;
    data['generatedby'] = this.generatedby;
    data['withdrawaltype'] = this.withdrawaltype;
    data['request_note'] = this.requestNote;
    data['rejected_reason'] = this.rejectedReason;
    data['isPartnerRewardWithdrawal'] = this.isPartnerRewardWithdrawal;
    data['availableFundWhileRequest'] = this.availableFundWhileRequest;
    data['payoutId'] = this.payoutId;
    data['id'] = this.id;
    data['date'] = this.date;
    data['userId'] = this.userId;
    data['userbankId'] = this.userbankId;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['TranasactionId'] = this.tranasactionId;
    if (this.createdby != null) {
      data['createdby'] = this.createdby!.toJson();
    }
    if (this.userbank != null) {
      data['userbank'] = this.userbank!.toJson();
    }
    if (this.payout != null) {
      data['payout'] = this.payout!.toJson();
    }
    if (this.withdrawalrequeststatus != null) {
      data['withdrawalrequeststatus'] = this.withdrawalrequeststatus!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Createdby {
  var profilepic;
  var sadadId;
  var name;
  bool? agreement;
  var signature;
  bool? partneragreement;
  var partnersignature;
  bool? cellVerified;
  var createdBy;
  var modifiedBy;
  var rememberToken;
  var tokenExpiry;
  var passwordExpiry;
  var type;
  var whmcsClientId;
  var username;
  bool? isPartnerUser;
  var partnerUserId;
  var addedUnderPartnerDate;
  var addedUnderPartnerHistory;
  var sadadPartnerID;
  var sadadPartnerIDGeneratedDate;
  var partnerDataUpdatedAt;
  var businessPhoneNumber;
  bool? isAgreedWithAutoWithdrawalTC;
  bool? isSubUserPublicAccess;
  var realm;
  var cellnumber;
  var email;
  var emailVerified;
  var id;
  var deletedAt;
  var created;
  var modified;
  var roleId;

  Createdby(
      {this.profilepic,
      this.sadadId,
      this.name,
      this.agreement,
      this.signature,
      this.partneragreement,
      this.partnersignature,
      this.cellVerified,
      this.createdBy,
      this.modifiedBy,
      this.rememberToken,
      this.tokenExpiry,
      this.passwordExpiry,
      this.type,
      this.whmcsClientId,
      this.username,
      this.isPartnerUser,
      this.partnerUserId,
      this.addedUnderPartnerDate,
      this.addedUnderPartnerHistory,
      this.sadadPartnerID,
      this.sadadPartnerIDGeneratedDate,
      this.partnerDataUpdatedAt,
      this.businessPhoneNumber,
      this.isAgreedWithAutoWithdrawalTC,
      this.isSubUserPublicAccess,
      this.realm,
      this.cellnumber,
      this.email,
      this.emailVerified,
      this.id,
      this.deletedAt,
      this.created,
      this.modified,
      this.roleId});

  Createdby.fromJson(Map<String, dynamic> json) {
    profilepic = json['profilepic'];
    sadadId = json['SadadId'];
    name = json['name'];
    agreement = json['agreement'];
    signature = json['signature'];
    partneragreement = json['partneragreement'];
    partnersignature = json['partnersignature'];
    cellVerified = json['cellVerified'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    rememberToken = json['remember_token'];
    tokenExpiry = json['token_expiry'];
    passwordExpiry = json['password_expiry'];
    type = json['type'];
    whmcsClientId = json['whmcs_client_id'];
    username = json['username'];
    isPartnerUser = json['isPartnerUser'];
    partnerUserId = json['partnerUserId'];
    addedUnderPartnerDate = json['addedUnderPartnerDate'];
    addedUnderPartnerHistory = json['addedUnderPartnerHistory'];
    sadadPartnerID = json['sadadPartnerID'];
    sadadPartnerIDGeneratedDate = json['SadadPartnerIDGeneratedDate'];
    partnerDataUpdatedAt = json['partnerDataUpdatedAt'];
    businessPhoneNumber = json['businessPhoneNumber'];
    isAgreedWithAutoWithdrawalTC = json['isAgreedWithAutoWithdrawalTC'];
    isSubUserPublicAccess = json['isSubUserPublicAccess'];
    realm = json['realm'];
    cellnumber = json['cellnumber'];
    email = json['email'];
    emailVerified = json['emailVerified'];
    id = json['id'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    modified = json['modified'];
    roleId = json['roleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profilepic'] = this.profilepic;
    data['SadadId'] = this.sadadId;
    data['name'] = this.name;
    data['agreement'] = this.agreement;
    data['signature'] = this.signature;
    data['partneragreement'] = this.partneragreement;
    data['partnersignature'] = this.partnersignature;
    data['cellVerified'] = this.cellVerified;
    data['createdBy'] = this.createdBy;
    data['modifiedBy'] = this.modifiedBy;
    data['remember_token'] = this.rememberToken;
    data['token_expiry'] = this.tokenExpiry;
    data['password_expiry'] = this.passwordExpiry;
    data['type'] = this.type;
    data['whmcs_client_id'] = this.whmcsClientId;
    data['username'] = this.username;
    data['isPartnerUser'] = this.isPartnerUser;
    data['partnerUserId'] = this.partnerUserId;
    data['addedUnderPartnerDate'] = this.addedUnderPartnerDate;
    data['addedUnderPartnerHistory'] = this.addedUnderPartnerHistory;
    data['sadadPartnerID'] = this.sadadPartnerID;
    data['SadadPartnerIDGeneratedDate'] = this.sadadPartnerIDGeneratedDate;
    data['partnerDataUpdatedAt'] = this.partnerDataUpdatedAt;
    data['businessPhoneNumber'] = this.businessPhoneNumber;
    data['isAgreedWithAutoWithdrawalTC'] = this.isAgreedWithAutoWithdrawalTC;
    data['isSubUserPublicAccess'] = this.isSubUserPublicAccess;
    data['realm'] = this.realm;
    data['cellnumber'] = this.cellnumber;
    data['email'] = this.email;
    data['emailVerified'] = this.emailVerified;
    data['id'] = this.id;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['roleId'] = this.roleId;
    return data;
  }
}

class Userbank {
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

  Userbank(
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

  Userbank.fromJson(Map<String, dynamic> json) {
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

class Payout {
  var payoutId;
  var payoutDateTime;
  var payoutAmount;
  var payoutCommissionAmount;
  var userBankId;
  var createdBy;
  var modifiedBy;
  bool? isPartnerRewardWithdrawal;
  var reasonToReject;
  var id;
  var userId;
  var userbankId;
  var withdrawalrequestId;
  var created;
  var modified;
  var payoutstatusId;
  Payoutstatus? payoutstatus;

  Payout(
      {this.payoutId,
      this.payoutDateTime,
      this.payoutAmount,
      this.payoutCommissionAmount,
      this.userBankId,
      this.createdBy,
      this.modifiedBy,
      this.isPartnerRewardWithdrawal,
      this.reasonToReject,
      this.id,
      this.userId,
      this.userbankId,
      this.withdrawalrequestId,
      this.created,
      this.modified,
      this.payoutstatusId,
      this.payoutstatus});

  Payout.fromJson(Map<String, dynamic> json) {
    payoutId = json['payoutId'];
    payoutDateTime = json['payoutDateTime'];
    payoutAmount = json['payoutAmount'];
    payoutCommissionAmount = json['payoutCommissionAmount'];
    userBankId = json['userBankId'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    isPartnerRewardWithdrawal = json['isPartnerRewardWithdrawal'];
    reasonToReject = json['reasonToReject'];
    id = json['id'];
    userId = json['userId'];
    userbankId = json['userbankId'];
    withdrawalrequestId = json['withdrawalrequestId'];
    created = json['created'];
    modified = json['modified'];
    payoutstatusId = json['payoutstatusId'];
    payoutstatus = json['payoutstatus'] != null
        ? new Payoutstatus.fromJson(json['payoutstatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payoutId'] = this.payoutId;
    data['payoutDateTime'] = this.payoutDateTime;
    data['payoutAmount'] = this.payoutAmount;
    data['payoutCommissionAmount'] = this.payoutCommissionAmount;
    data['userBankId'] = this.userBankId;
    data['createdBy'] = this.createdBy;
    data['modifiedBy'] = this.modifiedBy;
    data['isPartnerRewardWithdrawal'] = this.isPartnerRewardWithdrawal;
    data['reasonToReject'] = this.reasonToReject;
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['userbankId'] = this.userbankId;
    data['withdrawalrequestId'] = this.withdrawalrequestId;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['payoutstatusId'] = this.payoutstatusId;
    if (this.payoutstatus != null) {
      data['payoutstatus'] = this.payoutstatus!.toJson();
    }
    return data;
  }
}

class Payoutstatus {
  var name;
  var createdby;
  var modifiedby;
  var id;

  Payoutstatus({this.name, this.createdby, this.modifiedby, this.id});

  Payoutstatus.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['id'] = this.id;
    return data;
  }
}
