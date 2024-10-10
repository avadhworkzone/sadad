class BusinessInfoResponseModel {
  BusinessInfoResponseModel({
    this.businessname,
    this.registeredName,
    this.tradingName,
    this.logo,
    this.buildingnumber,
    this.streetnumber,
    this.zonenumber,
    this.unitnumber,
    this.merchantregisterationnumber,
    this.expirydate,
    this.speciallimit,
    this.createdby,
    this.modifiedby,
    this.website,
    this.secretkey,
    this.isLiveEnabled,
    this.secretCreated,
    this.testWebsite,
    this.testSecretkey,
    this.isTestEnabled,
    this.testSecretCreated,
    this.issubuserallowed,
    this.waitingperiod,
    this.crExpiry,
    this.qidExpiry,
    this.estCardExpiry,
    this.comLicenceExpiry,
    this.bankIndustryCode,
    this.id,
    this.userId,
    this.deletedAt,
    this.created,
    this.modified,
    this.userbusinessstatusId,
    this.businessmedia,
    this.userbusinessstatus,
    this.user,
    this.basicdetailsstatusId,
    this.basicdetailsstatuscommet,
  });

  BusinessInfoResponseModel.fromJson(dynamic json) {
    businessname = json['businessname'];
    registeredName = json['registeredName'];
    tradingName = json['tradingName'];
    logo = json['logo'];
    buildingnumber = json['buildingnumber'];
    streetnumber = json['streetnumber'];
    zonenumber = json['zonenumber'];
    unitnumber = json['unitnumber'];
    merchantregisterationnumber = json['merchantregisterationnumber'];
    expirydate = json['expirydate'];
    speciallimit = json['speciallimit'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    website = json['website'];
    secretkey = json['secretkey'];
    isLiveEnabled = json['isLiveEnabled'];
    secretCreated = json['secretCreated'];
    testWebsite = json['testWebsite'];
    testSecretkey = json['testSecretkey'];
    isTestEnabled = json['isTestEnabled'];
    testSecretCreated = json['testSecretCreated'];
    issubuserallowed = json['issubuserallowed'];
    waitingperiod = json['waitingperiod'];
    crExpiry = json['cr_expiry'];
    qidExpiry = json['qid_expiry'];
    estCardExpiry = json['est_card_expiry'];
    comLicenceExpiry = json['com_licence_expiry'];
    bankIndustryCode = json['bankIndustryCode'];
    id = json['id'];
    userId = json['userId'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    modified = json['modified'];
    userbusinessstatusId = json['userbusinessstatusId'];
    basicdetailsstatusId = json['basicdetailsstatusId'];
    basicdetailsstatuscommet = json['basicdetailsstatuscommet'];

    if (json['businessmedia'] != null) {
      businessmedia = [];
      json['businessmedia'].forEach((v) {
        businessmedia?.add(Businessmedia.fromJson(v));
      });
    }
    userbusinessstatus = json['userbusinessstatus'] != null
        ? Userbusinessstatus.fromJson(json['userbusinessstatus'])
        : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  String? businessname;
  String? registeredName;
  String? tradingName;
  String? logo;
  String? buildingnumber;
  String? streetnumber;
  String? zonenumber;
  String? unitnumber;
  String? merchantregisterationnumber;
  dynamic expirydate;
  int? speciallimit;
  dynamic createdby;
  int? modifiedby;
  dynamic website;
  dynamic secretkey;
  bool? isLiveEnabled;
  dynamic secretCreated;
  dynamic testWebsite;
  dynamic testSecretkey;
  bool? isTestEnabled;
  dynamic testSecretCreated;
  bool? issubuserallowed;
  int? waitingperiod;
  dynamic crExpiry;
  dynamic qidExpiry;
  dynamic estCardExpiry;
  dynamic comLicenceExpiry;
  int? bankIndustryCode;
  int? id;
  int? userId;
  dynamic deletedAt;
  String? created;
  String? modified;
  int? userbusinessstatusId;
  List<Businessmedia>? businessmedia;
  int? basicdetailsstatusId;
  String? basicdetailsstatuscommet;
  // Businessmedia? businessmedia;
  Userbusinessstatus? userbusinessstatus;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['businessname'] = businessname;
    map['registeredName'] = registeredName;
    map['tradingName'] = tradingName;
    map['logo'] = logo;
    map['buildingnumber'] = buildingnumber;
    map['streetnumber'] = streetnumber;
    map['zonenumber'] = zonenumber;
    map['unitnumber'] = unitnumber;
    map['merchantregisterationnumber'] = merchantregisterationnumber;
    map['expirydate'] = expirydate;
    map['speciallimit'] = speciallimit;
    map['createdby'] = createdby;
    map['modifiedby'] = modifiedby;
    map['website'] = website;
    map['secretkey'] = secretkey;
    map['isLiveEnabled'] = isLiveEnabled;
    map['secretCreated'] = secretCreated;
    map['testWebsite'] = testWebsite;
    map['testSecretkey'] = testSecretkey;
    map['isTestEnabled'] = isTestEnabled;
    map['testSecretCreated'] = testSecretCreated;
    map['issubuserallowed'] = issubuserallowed;
    map['waitingperiod'] = waitingperiod;
    map['cr_expiry'] = crExpiry;
    map['qid_expiry'] = qidExpiry;
    map['est_card_expiry'] = estCardExpiry;
    map['com_licence_expiry'] = comLicenceExpiry;
    map['bankIndustryCode'] = bankIndustryCode;
    map['id'] = id;
    map['userId'] = userId;
    map['deletedAt'] = deletedAt;
    map['created'] = created;
    map['modified'] = modified;
    map['userbusinessstatusId'] = userbusinessstatusId;
    map['basicdetailsstatusId'] = basicdetailsstatusId;
    map['basicdetailsstatuscommet'] = basicdetailsstatuscommet;
    if (businessmedia != null) {
      map['businessmedia'] = businessmedia?.map((v) => v.toJson()).toList();
    }
    if (userbusinessstatus != null) {
      map['userbusinessstatus'] = userbusinessstatus?.toJson();
    }
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }
}

class User {
  User({
    this.profilepic,
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
    this.roleId,
    this.role,
    this.usermetapersonals,
  });

  User.fromJson(dynamic json) {
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
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
    usermetapersonals = json['usermetapersonals'] != null
        ? Usermetapersonals.fromJson(json['usermetapersonals'])
        : null;
  }

  dynamic profilepic;
  String? sadadId;
  String? name;
  bool? agreement;
  String? signature;
  bool? partneragreement;
  dynamic partnersignature;
  bool? cellVerified;
  dynamic createdBy;
  dynamic modifiedBy;
  dynamic rememberToken;
  dynamic tokenExpiry;
  dynamic passwordExpiry;
  String? type;
  int? whmcsClientId;
  dynamic username;
  bool? isPartnerUser;
  dynamic partnerUserId;
  dynamic addedUnderPartnerDate;
  dynamic addedUnderPartnerHistory;
  dynamic sadadPartnerID;
  dynamic sadadPartnerIDGeneratedDate;
  dynamic partnerDataUpdatedAt;
  String? businessPhoneNumber;
  bool? isAgreedWithAutoWithdrawalTC;
  bool? isSubUserPublicAccess;
  dynamic realm;
  String? cellnumber;
  String? email;
  dynamic emailVerified;
  int? id;
  dynamic deletedAt;
  String? created;
  String? modified;
  int? roleId;
  Role? role;
  Usermetapersonals? usermetapersonals;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profilepic'] = profilepic;
    map['SadadId'] = sadadId;
    map['name'] = name;
    map['agreement'] = agreement;
    map['signature'] = signature;
    map['partneragreement'] = partneragreement;
    map['partnersignature'] = partnersignature;
    map['cellVerified'] = cellVerified;
    map['createdBy'] = createdBy;
    map['modifiedBy'] = modifiedBy;
    map['remember_token'] = rememberToken;
    map['token_expiry'] = tokenExpiry;
    map['password_expiry'] = passwordExpiry;
    map['type'] = type;
    map['whmcs_client_id'] = whmcsClientId;
    map['username'] = username;
    map['isPartnerUser'] = isPartnerUser;
    map['partnerUserId'] = partnerUserId;
    map['addedUnderPartnerDate'] = addedUnderPartnerDate;
    map['addedUnderPartnerHistory'] = addedUnderPartnerHistory;
    map['sadadPartnerID'] = sadadPartnerID;
    map['SadadPartnerIDGeneratedDate'] = sadadPartnerIDGeneratedDate;
    map['partnerDataUpdatedAt'] = partnerDataUpdatedAt;
    map['businessPhoneNumber'] = businessPhoneNumber;
    map['isAgreedWithAutoWithdrawalTC'] = isAgreedWithAutoWithdrawalTC;
    map['isSubUserPublicAccess'] = isSubUserPublicAccess;
    map['realm'] = realm;
    map['cellnumber'] = cellnumber;
    map['email'] = email;
    map['emailVerified'] = emailVerified;
    map['id'] = id;
    map['deletedAt'] = deletedAt;
    map['created'] = created;
    map['modified'] = modified;
    map['roleId'] = roleId;
    if (role != null) {
      map['role'] = role?.toJson();
    }
    if (usermetapersonals != null) {
      map['usermetapersonals'] = usermetapersonals?.toJson();
    }
    return map;
  }
}

class Usermetapersonals {
  Usermetapersonals({
    this.transfersenabled,
    this.createdby,
    this.modifiedby,
    this.agreementdoc,
    this.partneragreementdoc,
    this.tempemail,
    this.tempcell,
    this.tempname,
    this.mainmerchantid,
    this.autowithdrawfreq,
    this.uniqueIdentity,
    this.shorturl,
    this.id,
    this.userId,
    this.deletedAt,
    this.posdeviceId,
  });

  Usermetapersonals.fromJson(dynamic json) {
    transfersenabled = json['transfersenabled'];

    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    agreementdoc = json['agreementdoc'];
    partneragreementdoc = json['partneragreementdoc'];
    tempemail = json['tempemail'];
    tempcell = json['tempcell'];
    tempname = json['tempname'];
    mainmerchantid = json['mainmerchantid'];
    autowithdrawfreq = json['autowithdrawfreq'];
    uniqueIdentity = json['unique_Identity'];
    shorturl = json['shorturl'];
    id = json['id'];
    userId = json['userId'];
    deletedAt = json['deletedAt'];
    posdeviceId = json['posdeviceId'];
  }

  bool? transfersenabled;

  int? createdby;
  int? modifiedby;
  String? agreementdoc;
  dynamic partneragreementdoc;
  dynamic tempemail;
  dynamic tempcell;
  dynamic tempname;
  dynamic mainmerchantid;
  dynamic autowithdrawfreq;
  String? uniqueIdentity;
  String? shorturl;
  int? id;
  int? userId;
  dynamic deletedAt;
  dynamic posdeviceId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['transfersenabled'] = transfersenabled;
    map['createdby'] = createdby;
    map['modifiedby'] = modifiedby;
    map['agreementdoc'] = agreementdoc;
    map['partneragreementdoc'] = partneragreementdoc;
    map['tempemail'] = tempemail;
    map['tempcell'] = tempcell;
    map['tempname'] = tempname;
    map['mainmerchantid'] = mainmerchantid;
    map['autowithdrawfreq'] = autowithdrawfreq;
    map['unique_Identity'] = uniqueIdentity;
    map['shorturl'] = shorturl;
    map['id'] = id;
    map['userId'] = userId;
    map['deletedAt'] = deletedAt;
    map['posdeviceId'] = posdeviceId;
    return map;
  }
}

class Role {
  Role({
    this.createdBy,
    this.modifiedBy,
    this.id,
    this.name,
    this.description,
  });

  Role.fromJson(dynamic json) {
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  dynamic createdBy;
  dynamic modifiedBy;
  int? id;
  String? name;
  String? description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createdBy'] = createdBy;
    map['modifiedBy'] = modifiedBy;
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    return map;
  }
}

class Userbusinessstatus {
  Userbusinessstatus({
    this.name,
    this.createdby,
    this.modifiedby,
    this.id,
  });

  Userbusinessstatus.fromJson(dynamic json) {
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

class Businessmedia {
  Businessmedia({
    this.name,
    this.createdby,
    this.modifiedby,
    this.id,
    this.userbusinessId,
    this.deletedAt,
    this.created,
    this.doc_expiry,
    this.modified,
    this.businessmediatypeId,
    this.title,
    this.status,
    this.unique_id,
    this.metadata,
    this.businessmediastatusId,
    this.comment,
  });

  Businessmedia.fromJson(dynamic json) {
    name = json['name'];
    title = "";
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    id = json['id'];
    userbusinessId = json['userbusinessId'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    modified = json['modified'];
    doc_expiry = json['doc_expiry'];
    businessmediatypeId = json['businessmediatypeId'];
    unique_id = json['unique_id'];
    metadata = json['metadata'];
    businessmediastatusId = json['businessmediastatusId'];
    comment = json['comment'];
  }

  String? name;
  bool? status;
  int? createdby;
  dynamic modifiedby;
  int? id;
  int? userbusinessId;
  dynamic deletedAt;
  String? created;
  String? doc_expiry;
  String? modified;
  dynamic businessmediatypeId;
  String? title;
  String? unique_id;
  String? metadata;
  int? businessmediastatusId;
  String? comment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['createdby'] = createdby;
    map['modifiedby'] = modifiedby;
    map['id'] = id;
    map['userbusinessId'] = userbusinessId;
    map['deletedAt'] = deletedAt;
    map['created'] = created;
    map['doc_expiry'] = doc_expiry;
    map['modified'] = modified;
    map['businessmediatypeId'] = businessmediatypeId;
    map['unique_id'] = unique_id;
    map['metadata'] = metadata;
    map['businessmediastatusId'] = businessmediastatusId;
    map['comment'] = comment;
    return map;
  }
}

class BusinessmediaMultiPage {
  BusinessmediaMultiPage({
    this.name,
    this.createdby,
    this.modifiedby,
    this.id,
    this.userbusinessId,
    this.deletedAt,
    this.created,
    this.doc_expiry,
    this.modified,
    this.businessmediatypeId,
    this.title,
    this.status,
    this.unique_id,
    this.metadata,
    this.docStatus,
    this.businessmediastatusId,
    this.comment,
  });

  BusinessmediaMultiPage.fromJson(dynamic json) {
    name = json['name'];
    title = "";
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    id = json['id'];
    userbusinessId = json['userbusinessId'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    modified = json['modified'];
    doc_expiry = json['doc_expiry'];
    businessmediatypeId = json['businessmediatypeId'];
    unique_id = json['unique_id'];
    metadata = json['metadata'];
    docStatus  = json['docStatus'];
    businessmediastatusId = json['businessmediastatusId'];
    comment = json['comment'];
  }

  List<String>? name;
  bool? status;
  int? createdby;
  dynamic modifiedby;
  List<int>? id;
  int? userbusinessId;
  dynamic deletedAt;
  String? created;
  String? doc_expiry;
  String? modified;
  dynamic businessmediatypeId;
  String? title;
  String? unique_id;
  List<String>? metadata;
  List<String>? docStatus;
  int? businessmediastatusId;
  String? comment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['createdby'] = createdby;
    map['modifiedby'] = modifiedby;
    map['id'] = id;
    map['userbusinessId'] = userbusinessId;
    map['deletedAt'] = deletedAt;
    map['created'] = created;
    map['doc_expiry'] = doc_expiry;
    map['modified'] = modified;
    map['businessmediatypeId'] = businessmediatypeId;
    map['unique_id'] = unique_id;
    map['metadata'] = metadata;
    map['docStatus'] = docStatus;
    map['businessmediastatusId'] = businessmediastatusId;
    map['comment'] = comment;
    return map;
  }
}

class OwnerIdUploadModel {
  List<int>? id = [];
  List<String>? image = [];
  List<String>? onlineImage = [];
  List<String>? metaData = [];
  String? mediaStatus = '';
  List<String>? localDocStatus = [];
  String? uniqueId;
  String? currentDocType;
  bool? isDocVerified = true;
  String? errorMessage = "";
  bool? docUploadedSucess = false;
  List<String>? ownerIdList = [];
  List<String>? expiryDateList = [];

  init(List<int>? id,List<String>? image, List<String>? onlineImage, List<String>? metaData, String? mediaStatus,
      List<String>? localDocStatus, String? uniqueId, String? currentDocType) {
    this.id = id;
    this.image = image;
    this.onlineImage = onlineImage;
    this.metaData = metaData;
    this.mediaStatus = mediaStatus;
    this.localDocStatus = localDocStatus;
    this.uniqueId = uniqueId;
    this.currentDocType = currentDocType;
  }

  OwnerIdUploadModel({
    this.id,
    this.image,
    this.onlineImage,
    this.metaData,
    this.mediaStatus,
    this.localDocStatus,
    this.uniqueId,
    this.currentDocType,
    this.isDocVerified,
    this.errorMessage,
  });

// OwnerIdUploadModel.fromJson(Map<String, dynamic> json) {
//   upload = json['Upload'].cast<String>();
//   id = json['id'];
// }
//
// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['Upload'] = this.upload;
//   data['id'] = this.id;
//   return data;
// }
}