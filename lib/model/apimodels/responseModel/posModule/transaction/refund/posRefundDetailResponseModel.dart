// // To parse this JSON data, do
// //
// //     final posRefundDetailResponseModel = posRefundDetailResponseModelFromJson(jsonString);
//
// import 'dart:convert';
//
import 'dart:convert';

PosRefundDetailResponseModel posRefundDetailResponseModelFromJson(String str) =>
    PosRefundDetailResponseModel.fromJson(json.decode(str));

String posRefundDetailResponseModelToJson(PosRefundDetailResponseModel data) =>
    json.encode(data.toJson());

class PosRefundDetailResponseModel {
  PosRefundDetailResponseModel({
    this.entityid,
    this.ipnId,
    this.invoicenumber,
    this.verificationstatus,
    this.isRefund,
    this.isPartialRefund,
    this.refundamount,
    this.verifiedby,
    this.verifiedbysystem,
    this.verifiedon,
    this.amount,
    this.createdby,
    this.modifiedby,
    this.cardnumber,
    this.fundsprocessed,
    this.servicecharge,
    this.servicechargedescription,
    this.audittype,
    this.auditcomment,
    this.websiteRefNo,
    this.transactionSummary,
    this.cardholdername,
    this.cardsixdigit,
    this.bincardstatusvalue,
    this.txniptrackervalue,
    this.inprocess,
    this.verified,
    this.updatetxnby,
    this.refundTicketNotes,
    this.isSuspicious,
    this.suspiciousNote,
    this.isFraud,
    this.osHistory,
    this.creditcardpaymentmodeid,
    this.debitcardpaymentmodeid,
    this.refundcharge,
    this.refundchargedescription,
    this.refundType,
    this.partialRefundRemainAmount,
    this.isTechnicalRefund,
    this.technicalRefundComment,
    this.debitRefundBankPending,
    this.debitRefundResponsePun,
    this.debitRefundBankRequestDate,
    this.refundStatusUpdatedBy,
    this.transactionNote,
    this.txnBankStatus,
    this.partialServiceCharge,
    this.partialServiceChargeDescription,
    this.subscriptionInvoiceId,
    this.cardtype,
    this.sourceofTxn,
    this.isDisputed,
    this.id,
    this.transactiondate,
    this.deletedAt,
    this.created,
    this.modified,
    this.disputeId,
    this.transactionentityId,
    this.transactionmodeId,
    this.transactionstatusId,
    this.guestuserId,
    this.postransactionId,
    this.cardschemeid,
    this.entityId,
    this.actualTxn,
    this.refundTxn,
    this.priorRefundAmount,
    this.priorRefundRequestedAmount,
    this.senderId,
    this.receiverId,
    this.salesUserId,
    this.posUserId,
    this.transactionentity,
    this.transactionmode,
    this.transactionstatus,
    this.postransaction,
  });

  var entityid;
  dynamic ipnId;
  var invoicenumber;
  var verificationstatus;
  var isRefund;
  var isPartialRefund;
  dynamic refundamount;
  dynamic verifiedby;
  dynamic verifiedbysystem;
  dynamic verifiedon;
  var amount;
  dynamic createdby;
  dynamic modifiedby;
  dynamic cardnumber;
  dynamic fundsprocessed;
  dynamic servicecharge;
  dynamic servicechargedescription;
  var audittype;
  dynamic auditcomment;
  dynamic websiteRefNo;
  dynamic transactionSummary;
  dynamic cardholdername;
  dynamic cardsixdigit;
  dynamic bincardstatusvalue;
  var txniptrackervalue;
  var inprocess;
  var verified;
  dynamic updatetxnby;
  dynamic refundTicketNotes;
  var isSuspicious;
  dynamic suspiciousNote;
  var isFraud;
  var osHistory;
  dynamic creditcardpaymentmodeid;
  var debitcardpaymentmodeid;
  var refundcharge;
  dynamic refundchargedescription;
  dynamic refundType;
  dynamic partialRefundRemainAmount;
  var isTechnicalRefund;
  dynamic technicalRefundComment;
  dynamic debitRefundBankPending;
  dynamic debitRefundResponsePun;
  dynamic debitRefundBankRequestDate;
  dynamic refundStatusUpdatedBy;
  dynamic transactionNote;
  dynamic partialServiceCharge;
  dynamic partialServiceChargeDescription;
  var subscriptionInvoiceId;
  var cardtype;
  var sourceofTxn;
  var isDisputed;
  var id;
  var transactiondate;
  dynamic deletedAt;
  var created;
  var modified;
  dynamic disputeId;
  var transactionentityId;
  var transactionmodeId;
  var transactionstatusId;
  dynamic guestuserId;
  var postransactionId;
  dynamic cardschemeid;
  EntityId? entityId;
  ActualTxn? actualTxn;
  List<Txn_bank_status>? txnBankStatus;
  List<dynamic>? refundTxn;
  var priorRefundAmount;
  var priorRefundRequestedAmount;
  SenderId? senderId;
  ReceiverId? receiverId;
  dynamic salesUserId;
  dynamic posUserId;
  Transaction? transactionentity;
  Transaction? transactionmode;
  Transaction? transactionstatus;
  Postransaction? postransaction;

  factory PosRefundDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      PosRefundDetailResponseModel(
        entityid: json["entityid"],
        ipnId: json["IPN_id"],
        invoicenumber: json["invoicenumber"],
        verificationstatus: json["verificationstatus"],
        isRefund: json["isRefund"],
        isPartialRefund: json["isPartialRefund"],
        refundamount: json["refundamount"],
        verifiedby: json["verifiedby"],
        verifiedbysystem: json["verifiedbysystem"],
        verifiedon: json["verifiedon"],
        amount: json["amount"],
        createdby: json["createdby"],
        modifiedby: json["modifiedby"],
        cardnumber: json["cardnumber"],
        fundsprocessed: json["fundsprocessed"],
        servicecharge: json["servicecharge"],
        servicechargedescription: json["servicechargedescription"],
        audittype: json["audittype"],
        auditcomment: json["auditcomment"],
        websiteRefNo: json["website_ref_no"],
        transactionSummary: json["transaction_summary"],
        cardholdername: json["cardholdername"],
        cardsixdigit: json["cardsixdigit"],
        bincardstatusvalue: json["bincardstatusvalue"],
        txniptrackervalue: json["txniptrackervalue"],
        inprocess: json["inprocess"],
        verified: json["verified"],
        updatetxnby: json["updatetxnby"],
        refundTicketNotes: json["refund_ticket_notes"],
        isSuspicious: json["is_suspicious"],
        suspiciousNote: json["suspicious_note"],
        isFraud: json["isFraud"],
        osHistory: json["os_history"],
        creditcardpaymentmodeid: json["creditcardpaymentmodeid"],
        debitcardpaymentmodeid: json["debitcardpaymentmodeid"],
        refundcharge: json["refundcharge"],
        refundchargedescription: json["refundchargedescription"],
        refundType: json["refund_type"],
        partialRefundRemainAmount: json["partialRefundRemainAmount"],
        isTechnicalRefund: json["isTechnicalRefund"],
        technicalRefundComment: json["technicalRefundComment"],
        debitRefundBankPending: json["debit_refund_bank_pending"],
        debitRefundResponsePun: json["debit_refund_response_pun"],
        debitRefundBankRequestDate: json["debit_refund_bank_request_date"],
        refundStatusUpdatedBy: json["refund_status_updated_by"],
        transactionNote: json["transaction_note"],
        txnBankStatus: json['txn_bank_status'] != null
            ? (jsonDecode(json['txn_bank_status']) as List<dynamic>)
                .map((e) => Txn_bank_status.fromJson(e))
                .toList()
            : null,
        partialServiceCharge: json["partialServiceCharge"],
        partialServiceChargeDescription:
            json["partialServiceChargeDescription"],
        subscriptionInvoiceId: json["subscriptionInvoiceId"],
        cardtype: json["cardtype"],
        sourceofTxn: json["sourceofTxn"],
        isDisputed: json["isDisputed"],
        id: json["id"],
        transactiondate: DateTime.parse(json["transactiondate"]),
        deletedAt: json["deletedAt"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        disputeId: json["disputeId"],
        transactionentityId: json["transactionentityId"],
        transactionmodeId: json["transactionmodeId"],
        transactionstatusId: json["transactionstatusId"],
        guestuserId: json["guestuserId"],
        postransactionId: json["postransactionId"],
        cardschemeid: json["cardschemeid"],
        entityId: json["entityId"] == null
            ? null
            : EntityId.fromJson(json["entityId"]),
        actualTxn: json["actualTxn"] == null
            ? null
            : ActualTxn.fromJson(json["actualTxn"]),
        refundTxn: (json["refundTxn"] == [] || json["refundTxn"] == null)
            ? []
            : List<dynamic>.from(json["refundTxn"].map((x) => x)),
        priorRefundAmount: json["priorRefundAmount"],
        priorRefundRequestedAmount: json["priorRefundRequestedAmount"],
        senderId: json['senderId'] != null
            ? json['senderId'] is int
                ? null
                : SenderId.fromJson(json["senderId"])
            : null,
        receiverId: json['receiverId'] != null
            ? json['receiverId'] is int
                ? null
                : new ReceiverId.fromJson(json['receiverId'])
            : null,
        // receiverId: json['receiverId'] is int ? null : json['receiverId'],
        salesUserId: json["sales_userId"],
        posUserId: json["pos_userId"],
        transactionentity: Transaction.fromJson(json["transactionentity"]),
        transactionmode: json["transactionmode"] == null
            ? null
            : Transaction.fromJson(json["transactionmode"]),
        transactionstatus: Transaction.fromJson(json["transactionstatus"]),
        postransaction: Postransaction.fromJson(json["postransaction"]),
      );

  Map<String, dynamic> toJson() => {
        "entityid": entityid,
        "IPN_id": ipnId,
        "invoicenumber": invoicenumber,
        "verificationstatus": verificationstatus,
        "isRefund": isRefund,
        "isPartialRefund": isPartialRefund,
        "refundamount": refundamount,
        "verifiedby": verifiedby,
        "verifiedbysystem": verifiedbysystem,
        "verifiedon": verifiedon,
        "amount": amount,
        "createdby": createdby,
        "modifiedby": modifiedby,
        "cardnumber": cardnumber,
        "fundsprocessed": fundsprocessed,
        "servicecharge": servicecharge,
        "servicechargedescription": servicechargedescription,
        "audittype": audittype,
        "auditcomment": auditcomment,
        "website_ref_no": websiteRefNo,
        "transaction_summary": transactionSummary,
        "cardholdername": cardholdername,
        "cardsixdigit": cardsixdigit,
        "bincardstatusvalue": bincardstatusvalue,
        "txniptrackervalue": txniptrackervalue,
        "inprocess": inprocess,
        "verified": verified,
        "updatetxnby": updatetxnby,
        "refund_ticket_notes": refundTicketNotes,
        "is_suspicious": isSuspicious,
        "suspicious_note": suspiciousNote,
        "isFraud": isFraud,
        "os_history": osHistory,
        "creditcardpaymentmodeid": creditcardpaymentmodeid,
        "debitcardpaymentmodeid": debitcardpaymentmodeid,
        "refundcharge": refundcharge,
        "refundchargedescription": refundchargedescription,
        "refund_type": refundType,
        "partialRefundRemainAmount": partialRefundRemainAmount,
        "isTechnicalRefund": isTechnicalRefund,
        "technicalRefundComment": technicalRefundComment,
        "debit_refund_bank_pending": debitRefundBankPending,
        "debit_refund_response_pun": debitRefundResponsePun,
        "debit_refund_bank_request_date": debitRefundBankRequestDate,
        "refund_status_updated_by": refundStatusUpdatedBy,
        "transaction_note": transactionNote,
        "txn_bank_status": txnBankStatus,
        "partialServiceCharge": partialServiceCharge,
        "partialServiceChargeDescription": partialServiceChargeDescription,
        "subscriptionInvoiceId": subscriptionInvoiceId,
        "cardtype": cardtype,
        "sourceofTxn": sourceofTxn,
        "isDisputed": isDisputed,
        "id": id,
        "transactiondate":
            "${transactiondate.year.toString().padLeft(4, '0')}-${transactiondate.month.toString().padLeft(2, '0')}-${transactiondate.day.toString().padLeft(2, '0')}",
        "deletedAt": deletedAt,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
        "disputeId": disputeId,
        "transactionentityId": transactionentityId,
        "transactionmodeId": transactionmodeId,
        "transactionstatusId": transactionstatusId,
        "guestuserId": guestuserId,
        "postransactionId": postransactionId,
        "cardschemeid": cardschemeid,
        "entityId": entityId!.toJson(),
        "actualTxn": actualTxn!.toJson(),
        "refundTxn": List<dynamic>.from(refundTxn!.map((x) => x)),
        "priorRefundAmount": priorRefundAmount,
        "priorRefundRequestedAmount": priorRefundRequestedAmount,
        "senderId": senderId!.toJson(),
        "receiverId": receiverId!.toJson(),
        "sales_userId": salesUserId,
        "pos_userId": posUserId,
        "transactionentity": transactionentity!.toJson(),
        "transactionmode": transactionmode!.toJson(),
        "transactionstatus": transactionstatus!.toJson(),
        "postransaction": postransaction!.toJson(),
      };
}

class ReceiverId {
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

  ReceiverId(
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

  ReceiverId.fromJson(Map<String, dynamic> json) {
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

class ActualTxn {
  ActualTxn({this.invoicenumber, this.entityid});

  var invoicenumber;
  var entityid;
  factory ActualTxn.fromJson(Map<String, dynamic> json) => ActualTxn(
      invoicenumber: json["invoicenumber"],
      entityid: json['entityid'] == null ? null : json['entityid']);

  Map<String, dynamic> toJson() =>
      {"invoicenumber": invoicenumber, 'entityid': entityid};
}

class EntityId {
  EntityId({
    this.entityid,
    this.ipnId,
    this.invoicenumber,
    this.verificationstatus,
    this.isRefund,
    this.isPartialRefund,
    this.refundamount,
    this.verifiedby,
    this.verifiedbysystem,
    this.verifiedon,
    this.amount,
    this.createdby,
    this.modifiedby,
    this.cardnumber,
    this.fundsprocessed,
    this.servicecharge,
    this.servicechargedescription,
    this.audittype,
    this.auditcomment,
    this.websiteRefNo,
    this.transactionSummary,
    this.txnip,
    this.cardholdername,
    this.cardsixdigit,
    this.bincardstatusvalue,
    this.txniptrackervalue,
    this.inprocess,
    this.verified,
    this.updatetxnby,
    this.refundTicketNotes,
    this.isSuspicious,
    this.suspiciousNote,
    this.isFraud,
    this.osHistory,
    this.creditcardpaymentmodeid,
    this.debitcardpaymentmodeid,
    this.refundcharge,
    this.refundchargedescription,
    this.refundType,
    this.partialRefundRemainAmount,
    this.isTechnicalRefund,
    this.technicalRefundComment,
    this.debitRefundBankPending,
    this.debitRefundResponsePun,
    this.debitRefundBankRequestDate,
    this.refundStatusUpdatedBy,
    this.transactionNote,
    this.txnBankStatus,
    this.partialServiceCharge,
    this.partialServiceChargeDescription,
    this.subscriptionInvoiceId,
    this.cardtype,
    this.sourceofTxn,
    this.isDisputed,
    this.id,
    this.transactiondate,
    this.deletedAt,
    this.created,
    this.modified,
    this.disputeId,
    this.transactionentityId,
    this.transactionmodeId,
    this.transactionstatusId,
    this.guestuserId,
    this.postransactionId,
    this.cardschemeid,
    this.senderId,
    this.receiverId,
    this.salesUserId,
    this.posUserId,
  });

  dynamic entityid;
  dynamic ipnId;
  var invoicenumber;
  bool? verificationstatus;
  bool? isRefund;
  bool? isPartialRefund;
  dynamic refundamount;
  dynamic verifiedby;
  dynamic verifiedbysystem;
  dynamic verifiedon;
  var amount;
  dynamic createdby;
  dynamic modifiedby;
  dynamic cardnumber;
  dynamic fundsprocessed;
  var servicecharge;
  dynamic servicechargedescription;
  var audittype;
  dynamic auditcomment;
  dynamic websiteRefNo;
  dynamic transactionSummary;
  var txnip;
  dynamic cardholdername;
  dynamic cardsixdigit;
  dynamic bincardstatusvalue;
  var txniptrackervalue;
  var inprocess;
  var verified;
  dynamic updatetxnby;
  dynamic refundTicketNotes;
  var isSuspicious;
  dynamic suspiciousNote;
  bool? isFraud;
  var osHistory;
  dynamic creditcardpaymentmodeid;
  var debitcardpaymentmodeid;
  var refundcharge;
  dynamic refundchargedescription;
  dynamic refundType;
  dynamic partialRefundRemainAmount;
  var isTechnicalRefund;
  dynamic technicalRefundComment;
  dynamic debitRefundBankPending;
  dynamic debitRefundResponsePun;
  dynamic debitRefundBankRequestDate;
  dynamic refundStatusUpdatedBy;
  dynamic transactionNote;
  var txnBankStatus;
  dynamic partialServiceCharge;
  dynamic partialServiceChargeDescription;
  var subscriptionInvoiceId;
  var cardtype;
  var sourceofTxn;
  bool? isDisputed;
  var id;
  var transactiondate;
  dynamic deletedAt;
  var created;
  var modified;
  dynamic disputeId;
  var transactionentityId;
  var transactionmodeId;
  var transactionstatusId;
  dynamic guestuserId;
  var postransactionId;
  dynamic cardschemeid;
  var senderId;
  var receiverId;
  dynamic salesUserId;
  dynamic posUserId;

  factory EntityId.fromJson(Map<String, dynamic> json) => EntityId(
        entityid: json["entityid"],
        ipnId: json["IPN_id"],
        invoicenumber: json["invoicenumber"],
        verificationstatus: json["verificationstatus"],
        isRefund: json["isRefund"],
        isPartialRefund: json["isPartialRefund"],
        refundamount: json["refundamount"],
        verifiedby: json["verifiedby"],
        verifiedbysystem: json["verifiedbysystem"],
        verifiedon: json["verifiedon"],
        amount: json["amount"].toDouble(),
        createdby: json["createdby"],
        modifiedby: json["modifiedby"],
        cardnumber: json["cardnumber"],
        fundsprocessed: json["fundsprocessed"],
        servicecharge: json["servicecharge"],
        servicechargedescription: json["servicechargedescription"],
        audittype: json["audittype"],
        auditcomment: json["auditcomment"],
        websiteRefNo: json["website_ref_no"],
        transactionSummary: json["transaction_summary"],
        txnip: json["txnip"],
        cardholdername: json["cardholdername"],
        cardsixdigit: json["cardsixdigit"],
        bincardstatusvalue: json["bincardstatusvalue"],
        txniptrackervalue: json["txniptrackervalue"],
        inprocess: json["inprocess"],
        verified: json["verified"],
        updatetxnby: json["updatetxnby"],
        refundTicketNotes: json["refund_ticket_notes"],
        isSuspicious: json["is_suspicious"],
        suspiciousNote: json["suspicious_note"],
        isFraud: json["isFraud"],
        osHistory: json["os_history"],
        creditcardpaymentmodeid: json["creditcardpaymentmodeid"],
        debitcardpaymentmodeid: json["debitcardpaymentmodeid"],
        refundcharge: json["refundcharge"],
        refundchargedescription: json["refundchargedescription"],
        refundType: json["refund_type"],
        partialRefundRemainAmount: json["partialRefundRemainAmount"],
        isTechnicalRefund: json["isTechnicalRefund"],
        technicalRefundComment: json["technicalRefundComment"],
        debitRefundBankPending: json["debit_refund_bank_pending"],
        debitRefundResponsePun: json["debit_refund_response_pun"],
        debitRefundBankRequestDate: json["debit_refund_bank_request_date"],
        refundStatusUpdatedBy: json["refund_status_updated_by"],
        transactionNote: json["transaction_note"],
        txnBankStatus: json["txn_bank_status"],
        partialServiceCharge: json["partialServiceCharge"],
        partialServiceChargeDescription:
            json["partialServiceChargeDescription"],
        subscriptionInvoiceId: json["subscriptionInvoiceId"],
        cardtype: json["cardtype"],
        sourceofTxn: json["sourceofTxn"],
        isDisputed: json["isDisputed"],
        id: json["id"],
        transactiondate: DateTime.parse(json["transactiondate"]),
        deletedAt: json["deletedAt"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        disputeId: json["disputeId"],
        transactionentityId: json["transactionentityId"],
        transactionmodeId: json["transactionmodeId"],
        transactionstatusId: json["transactionstatusId"],
        guestuserId: json["guestuserId"],
        postransactionId: json["postransactionId"],
        cardschemeid: json["cardschemeid"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        salesUserId: json["sales_userId"],
        posUserId: json["pos_userId"],
      );

  Map<String, dynamic> toJson() => {
        "entityid": entityid,
        "IPN_id": ipnId,
        "invoicenumber": invoicenumber,
        "verificationstatus": verificationstatus,
        "isRefund": isRefund,
        "isPartialRefund": isPartialRefund,
        "refundamount": refundamount,
        "verifiedby": verifiedby,
        "verifiedbysystem": verifiedbysystem,
        "verifiedon": verifiedon,
        "amount": amount,
        "createdby": createdby,
        "modifiedby": modifiedby,
        "cardnumber": cardnumber,
        "fundsprocessed": fundsprocessed,
        "servicecharge": servicecharge,
        "servicechargedescription": servicechargedescription,
        "audittype": audittype,
        "auditcomment": auditcomment,
        "website_ref_no": websiteRefNo,
        "transaction_summary": transactionSummary,
        "txnip": txnip,
        "cardholdername": cardholdername,
        "cardsixdigit": cardsixdigit,
        "bincardstatusvalue": bincardstatusvalue,
        "txniptrackervalue": txniptrackervalue,
        "inprocess": inprocess,
        "verified": verified,
        "updatetxnby": updatetxnby,
        "refund_ticket_notes": refundTicketNotes,
        "is_suspicious": isSuspicious,
        "suspicious_note": suspiciousNote,
        "isFraud": isFraud,
        "os_history": osHistory,
        "creditcardpaymentmodeid": creditcardpaymentmodeid,
        "debitcardpaymentmodeid": debitcardpaymentmodeid,
        "refundcharge": refundcharge,
        "refundchargedescription": refundchargedescription,
        "refund_type": refundType,
        "partialRefundRemainAmount": partialRefundRemainAmount,
        "isTechnicalRefund": isTechnicalRefund,
        "technicalRefundComment": technicalRefundComment,
        "debit_refund_bank_pending": debitRefundBankPending,
        "debit_refund_response_pun": debitRefundResponsePun,
        "debit_refund_bank_request_date": debitRefundBankRequestDate,
        "refund_status_updated_by": refundStatusUpdatedBy,
        "transaction_note": transactionNote,
        "txn_bank_status": txnBankStatus,
        "partialServiceCharge": partialServiceCharge,
        "partialServiceChargeDescription": partialServiceChargeDescription,
        "subscriptionInvoiceId": subscriptionInvoiceId,
        "cardtype": cardtype,
        "sourceofTxn": sourceofTxn,
        "isDisputed": isDisputed,
        "id": id,
        "transactiondate":
            "${transactiondate.year.toString().padLeft(4, '0')}-${transactiondate.month.toString().padLeft(2, '0')}-${transactiondate.day.toString().padLeft(2, '0')}",
        "deletedAt": deletedAt,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
        "disputeId": disputeId,
        "transactionentityId": transactionentityId,
        "transactionmodeId": transactionmodeId,
        "transactionstatusId": transactionstatusId,
        "guestuserId": guestuserId,
        "postransactionId": postransactionId,
        "cardschemeid": cardschemeid,
        "senderId": senderId,
        "receiverId": receiverId,
        "sales_userId": salesUserId,
        "pos_userId": posUserId,
      };
}

class Postransaction {
  Postransaction({
    this.postransactionTransactionId,
    this.sadadId,
    this.isVoid,
    this.isReversed,
    this.cardType,
    this.paymentMethod,
    this.cardPaymentType,
    this.transactionType,
    this.cardUsageType,
    this.maskedPan,
    this.network,
    this.rrn,
    this.tid,
    this.merchantId,
    this.customerName,
    this.customerMobile,
    this.customerEmail,
    this.transResponseCode,
    this.transResponseMessage,
    this.dataJson,
    this.terminalId,
    this.syncedAt,
    this.id,
    this.transactionId,
    this.deletedAt,
    this.created,
    this.modified,
    this.terminal,
  });

  var postransactionTransactionId;
  var sadadId;
  bool? isVoid;
  bool? isReversed;
  var cardType;
  var paymentMethod;
  var cardPaymentType;
  var transactionType;
  var cardUsageType;
  var maskedPan;
  var network;
  var rrn;
  var tid;
  var merchantId;
  dynamic customerName;
  dynamic customerMobile;
  dynamic customerEmail;
  dynamic transResponseCode;
  var transResponseMessage;
  var dataJson;
  var terminalId;
  var syncedAt;
  var id;
  var transactionId;
  dynamic deletedAt;
  var created;
  var modified;
  Terminal? terminal;

  factory Postransaction.fromJson(Map<String, dynamic> json) => Postransaction(
        postransactionTransactionId: json["transaction_id"],
        sadadId: json["SadadId"],
        isVoid: json["is_void"],
        isReversed: json["is_reversed"],
        cardType: json["card_type"],
        paymentMethod: json["payment_method"],
        cardPaymentType: json["card_payment_type"],
        transactionType: json["transaction_type"],
        cardUsageType: json["card_usage_type"],
        maskedPan: json["masked_pan"],
        network: json["network"],
        rrn: json["rrn"],
        tid: json["tid"],
        merchantId: json["merchant_id"],
        customerName: json["customer_name"],
        customerMobile: json["customer_mobile"],
        customerEmail: json["customer_email"],
        transResponseCode: json["trans_response_code"],
        transResponseMessage: json["trans_response_message"],
        dataJson: json["dataJson"],
        terminalId: json["terminalId"],
        syncedAt: DateTime.parse(json["syncedAt"]),
        id: json["id"],
        transactionId: json["transactionId"],
        deletedAt: json["deletedAt"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        terminal: Terminal.fromJson(json["terminal"]),
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": postransactionTransactionId,
        "SadadId": sadadId,
        "is_void": isVoid,
        "is_reversed": isReversed,
        "card_type": cardType,
        "payment_method": paymentMethod,
        "card_payment_type": cardPaymentType,
        "transaction_type": transactionType,
        "card_usage_type": cardUsageType,
        "masked_pan": maskedPan,
        "network": network,
        "rrn": rrn,
        "tid": tid,
        "merchant_id": merchantId,
        "customer_name": customerName,
        "customer_mobile": customerMobile,
        "customer_email": customerEmail,
        "trans_response_code": transResponseCode,
        "trans_response_message": transResponseMessage,
        "dataJson": dataJson,
        "terminalId": terminalId,
        "syncedAt": syncedAt.toIso8601String(),
        "id": id,
        "transactionId": transactionId,
        "deletedAt": deletedAt,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
        "terminal": terminal!.toJson(),
      };
}

class Terminal {
  Terminal({
    this.terminalId,
    this.name,
    this.buildingNumber,
    this.streetNumber,
    this.city,
    this.zoneNumber,
    this.zone,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.status,
    this.terminalStatus,
    this.lastUpdateBy,
    this.deviceSerialNo,
    this.deviceId,
    this.rentalPlanId,
    this.rentalStartDate,
    this.simNumber,
    this.installFee,
    this.activated,
    this.deactivated,
    this.objectId,
    this.syncedAt,
    this.sadadId,
    this.previousDeviceSerialNo,
    this.previousDeviceId,
    this.isActive,
    this.isOnline,
    // this.locationApiCalledAt,
    this.terminaltype,
    this.id,
    this.created,
    this.devicetypeId,
    this.posdevice,
  });

  var terminalId;
  var name;
  var buildingNumber;
  var streetNumber;
  var city;
  var zoneNumber;
  var zone;
  dynamic postalCode;
  var latitude;
  var longitude;
  var status;
  var terminalStatus;
  var lastUpdateBy;
  var deviceSerialNo;
  var deviceId;
  var rentalPlanId;
  var rentalStartDate;
  var simNumber;
  var installFee;
  var activated;
  dynamic deactivated;
  var objectId;
  var syncedAt;
  var sadadId;
  dynamic previousDeviceSerialNo;
  dynamic previousDeviceId;
  var isActive;
  var isOnline;
  // var locationApiCalledAt;
  var terminaltype;
  var id;
  var created;
  var devicetypeId;
  Posdevice? posdevice;

  factory Terminal.fromJson(Map<String, dynamic> json) => Terminal(
        terminalId: json["terminalId"],
        name: json["name"],
        buildingNumber: json["buildingNumber"],
        streetNumber: json["streetNumber"],
        city: json["city"],
        zoneNumber: json["zoneNumber"],
        zone: json["zone"],
        postalCode: json["postalCode"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        status: json["status"],
        terminalStatus: json["terminalStatus"],
        lastUpdateBy: json["lastUpdateBy"],
        deviceSerialNo: json["deviceSerialNo"],
        deviceId: json["deviceId"],
        rentalPlanId: json["rentalPlanId"],
        rentalStartDate: DateTime.parse(json["rentalStartDate"]),
        simNumber: json["simNumber"],
        installFee: json["installFee"],
        activated: DateTime.parse(json["activated"]),
        deactivated: json["deactivated"],
        objectId: json["objectId"],
        syncedAt: DateTime.parse(json["syncedAt"]),
        sadadId: json["SadadID"],
        previousDeviceSerialNo: json["previousDeviceSerialNo"],
        previousDeviceId: json["previousDeviceId"],
        isActive: json["is_active"],
        isOnline: json["is_online"],
        // locationApiCalledAt: DateTime.parse(json["locationAPICalledAt"]),
        terminaltype: json["terminaltype"],
        id: json["id"],
        created: DateTime.parse(json["created"]),
        devicetypeId: json["devicetypeId"],
        posdevice: Posdevice.fromJson(json["posdevice"]),
      );

  Map<String, dynamic> toJson() => {
        "terminalId": terminalId,
        "name": name,
        "buildingNumber": buildingNumber,
        "streetNumber": streetNumber,
        "city": city,
        "zoneNumber": zoneNumber,
        "zone": zone,
        "postalCode": postalCode,
        "latitude": latitude,
        "longitude": longitude,
        "status": status,
        "terminalStatus": terminalStatus,
        "lastUpdateBy": lastUpdateBy,
        "deviceSerialNo": deviceSerialNo,
        "deviceId": deviceId,
        "rentalPlanId": rentalPlanId,
        "rentalStartDate": rentalStartDate.toIso8601String(),
        "simNumber": simNumber,
        "installFee": installFee,
        "activated": activated.toIso8601String(),
        "deactivated": deactivated,
        "objectId": objectId,
        "syncedAt": syncedAt.toIso8601String(),
        "SadadID": sadadId,
        "previousDeviceSerialNo": previousDeviceSerialNo,
        "previousDeviceId": previousDeviceId,
        "is_active": isActive,
        "is_online": isOnline,
        // "locationAPICalledAt": locationApiCalledAt.toIso8601String(),
        "terminaltype": terminaltype,
        "id": id,
        "created": created.toIso8601String(),
        "devicetypeId": devicetypeId,
        "posdevice": posdevice!.toJson(),
      };
}

class Posdevice {
  Posdevice({
    this.serial,
    this.deviceId,
    this.devicetype,
    this.imei,
    this.lastlocation,
    this.lastactivetime,
    this.id,
    this.deletedAt,
    this.created,
    this.modified,
    this.mainmerchantId,
  });

  var serial;
  var deviceId;
  var devicetype;
  var imei;
  dynamic lastlocation;
  dynamic lastactivetime;
  var id;
  dynamic deletedAt;
  var created;
  var modified;
  dynamic mainmerchantId;

  factory Posdevice.fromJson(Map<String, dynamic> json) => Posdevice(
        serial: json["serial"],
        deviceId: json["deviceId"],
        devicetype: json["devicetype"],
        imei: json["imei"],
        lastlocation: json["lastlocation"],
        lastactivetime: json["lastactivetime"],
        id: json["id"],
        deletedAt: json["deletedAt"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        mainmerchantId: json["mainmerchantId"],
      );

  Map<String, dynamic> toJson() => {
        "serial": serial,
        "deviceId": deviceId,
        "devicetype": devicetype,
        "imei": imei,
        "lastlocation": lastlocation,
        "lastactivetime": lastactivetime,
        "id": id,
        "deletedAt": deletedAt,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
        "mainmerchantId": mainmerchantId,
      };
}

class SenderId {
  SenderId({
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
    this.sadadPartnerId,
    this.sadadPartnerIdGeneratedDate,
    this.partnerDataUpdatedAt,
    this.businessPhoneNumber,
    this.isAgreedWithAutoWithdrawalTc,
    this.realm,
    this.cellnumber,
    this.email,
    this.emailVerified,
    this.id,
    this.deletedAt,
    this.created,
    this.modified,
    this.roleId,
  });

  var profilepic;
  var sadadId;
  var name;
  bool? agreement;
  var signature;
  bool? partneragreement;
  dynamic partnersignature;
  bool? cellVerified;
  dynamic createdBy;
  dynamic modifiedBy;
  dynamic rememberToken;
  dynamic tokenExpiry;
  dynamic passwordExpiry;
  var type;
  var whmcsClientId;
  dynamic username;
  bool? isPartnerUser;
  dynamic partnerUserId;
  dynamic addedUnderPartnerDate;
  dynamic addedUnderPartnerHistory;
  dynamic sadadPartnerId;
  dynamic sadadPartnerIdGeneratedDate;
  dynamic partnerDataUpdatedAt;
  var businessPhoneNumber;
  bool? isAgreedWithAutoWithdrawalTc;
  dynamic realm;
  var cellnumber;
  var email;
  dynamic emailVerified;
  var id;
  dynamic deletedAt;
  var created;
  var modified;
  var roleId;

  factory SenderId.fromJson(Map<String, dynamic> json) => SenderId(
        profilepic: json["profilepic"],
        sadadId: json["SadadId"],
        name: json["name"],
        agreement: json["agreement"],
        signature: json["signature"],
        partneragreement: json["partneragreement"],
        partnersignature: json["partnersignature"],
        cellVerified: json["cellVerified"],
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        rememberToken: json["remember_token"],
        tokenExpiry: json["token_expiry"],
        passwordExpiry: json["password_expiry"],
        type: json["type"],
        whmcsClientId: json["whmcs_client_id"],
        username: json["username"],
        isPartnerUser: json["isPartnerUser"],
        partnerUserId: json["partnerUserId"],
        addedUnderPartnerDate: json["addedUnderPartnerDate"],
        addedUnderPartnerHistory: json["addedUnderPartnerHistory"],
        sadadPartnerId: json["sadadPartnerID"],
        sadadPartnerIdGeneratedDate: json["SadadPartnerIDGeneratedDate"],
        partnerDataUpdatedAt: json["partnerDataUpdatedAt"],
        businessPhoneNumber: json["businessPhoneNumber"],
        isAgreedWithAutoWithdrawalTc: json["isAgreedWithAutoWithdrawalTC"],
        realm: json["realm"],
        cellnumber: json["cellnumber"],
        email: json["email"],
        emailVerified: json["emailVerified"],
        id: json["id"],
        deletedAt: json["deletedAt"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        roleId: json["roleId"],
      );

  Map<String, dynamic> toJson() => {
        "profilepic": profilepic,
        "SadadId": sadadId,
        "name": name,
        "agreement": agreement,
        "signature": signature,
        "partneragreement": partneragreement,
        "partnersignature": partnersignature,
        "cellVerified": cellVerified,
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "remember_token": rememberToken,
        "token_expiry": tokenExpiry,
        "password_expiry": passwordExpiry,
        "type": type,
        "whmcs_client_id": whmcsClientId,
        "username": username,
        "isPartnerUser": isPartnerUser,
        "partnerUserId": partnerUserId,
        "addedUnderPartnerDate": addedUnderPartnerDate,
        "addedUnderPartnerHistory": addedUnderPartnerHistory,
        "sadadPartnerID": sadadPartnerId,
        "SadadPartnerIDGeneratedDate": sadadPartnerIdGeneratedDate,
        "partnerDataUpdatedAt": partnerDataUpdatedAt,
        "businessPhoneNumber": businessPhoneNumber,
        "isAgreedWithAutoWithdrawalTC": isAgreedWithAutoWithdrawalTc,
        "realm": realm,
        "cellnumber": cellnumber,
        "email": email,
        "emailVerified": emailVerified,
        "id": id,
        "deletedAt": deletedAt,
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
        "roleId": roleId,
      };
}

class Transaction {
  Transaction({
    this.name,
    this.createdby,
    this.modifiedby,
    this.id,
  });

  var name;
  dynamic createdby;
  dynamic modifiedby;
  var id;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        name: json["name"],
        createdby: json["createdby"],
        modifiedby: json["modifiedby"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "createdby": createdby,
        "modifiedby": modifiedby,
        "id": id,
      };
}

class Txn_bank_status {
  var date;
  var txnID;
  var code;
  var message;

  Txn_bank_status({this.date, this.txnID, this.code, this.message});

  Txn_bank_status.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    txnID = json['TxnID'];
    code = json['Code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    data['TxnID'] = this.txnID;
    data['Code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

//
// class PosRefundDetailResponseModel {
//   var entityid;
//   var iPNId;
//   var invoicenumber;
//   bool? verificationstatus;
//   bool? isRefund;
//   bool? isPartialRefund;
//   var  refundamount;
//   var  verifiedby;
//   var  verifiedbysystem;
//   var  verifiedon;
//   var amount;
//  var  createdby;
//  var  modifiedby;
//  var  cardnumber;
//  var  fundsprocessed;
//  var servicecharge;
//  var  servicechargedescription;
//   var audittype;
//  var auditcomment;
//  var websiteRefNo;
//  var transactionSummary;
//  var cardholdername;
//  var cardsixdigit;
//  var bincardstatusvalue;
//   var txniptrackervalue;
//   var inprocess;
//   var isTxnRecounciliationInprogress;
//   var verified;
// var updatetxnby;
// var refundTicketNotes;
//   var isSuspicious;
//   var suspiciousNote;
//   bool? isFraud;
//   var osHistory;
//   var creditcardpaymentmodeid;
//   var debitcardpaymentmodeid;
//   var refundcharge;
//   var refundchargedescription;
//  var refundType;
//  var partialRefundRemainAmount;
//   var isTechnicalRefund;
//  var technicalRefundComment;
//  var debitRefundBankPending;
//  var debitRefundResponsePun;
//  var debitRefundBankRequestDate;
//  var refundStatusUpdatedBy;
//  var transactionNote;
//   var txnBankStatus;
//  var partialServiceCharge;
//  var partialServiceChargeDescription;
//   var subscriptionInvoiceId;
//   var cardtype;
//   var sourceofTxn;
//   bool? isDisputed;
//   var id;
//   var transactiondate;
//   var deletedAt;
//   var created;
//   var modified;
//   var disputeId;
//   var transactionentityId;
//   var transactionmodeId;
//   var transactionstatusId;
//   var guestuserId;
//   var postransactionId;
//   var cardschemeid;
//   EntityId? entityId;
//   ActualTxn? actualTxn;
//   List<dynamic>? refundTxn;
//   var priorRefundAmount;
//   var priorRefundRequestedAmount;
//   SenderId? senderId;
//   var receiverId;
//   var salesUserId;
//   var posUserId;
//   Transactionentity? transactionentity;
//   Transactionentity? transactionmode;
//   Transactionentity? transactionstatus;
//   Postransaction? postransaction;
//
//   PosRefundDetailResponseModel(
//       {this.entityid,
//         this.iPNId,
//         this.invoicenumber,
//         this.verificationstatus,
//         this.isRefund,
//         this.isPartialRefund,
//         this.refundamount,
//         this.verifiedby,
//         this.verifiedbysystem,
//         this.verifiedon,
//         this.amount,
//         this.createdby,
//         this.modifiedby,
//         this.cardnumber,
//         this.fundsprocessed,
//         this.servicecharge,
//         this.servicechargedescription,
//         this.audittype,
//         this.auditcomment,
//         this.websiteRefNo,
//         this.transactionSummary,
//         this.cardholdername,
//         this.cardsixdigit,
//         this.bincardstatusvalue,
//         this.txniptrackervalue,
//         this.inprocess,
//         this.isTxnRecounciliationInprogress,
//         this.verified,
//         this.updatetxnby,
//         this.refundTicketNotes,
//         this.isSuspicious,
//         this.suspiciousNote,
//         this.isFraud,
//         this.osHistory,
//         this.creditcardpaymentmodeid,
//         this.debitcardpaymentmodeid,
//         this.refundcharge,
//         this.refundchargedescription,
//         this.refundType,
//         this.partialRefundRemainAmount,
//         this.isTechnicalRefund,
//         this.technicalRefundComment,
//         this.debitRefundBankPending,
//         this.debitRefundResponsePun,
//         this.debitRefundBankRequestDate,
//         this.refundStatusUpdatedBy,
//         this.transactionNote,
//         this.txnBankStatus,
//         this.partialServiceCharge,
//         this.partialServiceChargeDescription,
//         this.subscriptionInvoiceId,
//         this.cardtype,
//         this.sourceofTxn,
//         this.isDisputed,
//         this.id,
//         this.transactiondate,
//         this.deletedAt,
//         this.created,
//         this.modified,
//         this.disputeId,
//         this.transactionentityId,
//         this.transactionmodeId,
//         this.transactionstatusId,
//         this.guestuserId,
//         this.postransactionId,
//         this.cardschemeid,
//         this.entityId,
//         this.actualTxn,
//         this.refundTxn,
//         this.priorRefundAmount,
//         this.priorRefundRequestedAmount,
//         this.senderId,
//         this.receiverId,
//         this.salesUserId,
//         this.posUserId,
//         this.transactionentity,
//         this.transactionmode,
//         this.transactionstatus,
//         this.postransaction});
//
//   PosRefundDetailResponseModel.fromJson(Map<String, dynamic> json) {
//     entityid = json['entityid'];
//     iPNId = json['IPN_id'];
//     invoicenumber = json['invoicenumber'];
//     verificationstatus = json['verificationstatus'];
//     isRefund = json['isRefund'];
//     isPartialRefund = json['isPartialRefund'];
//     refundamount = json['refundamount'];
//     verifiedby = json['verifiedby'];
//     verifiedbysystem = json['verifiedbysystem'];
//     verifiedon = json['verifiedon'];
//     amount = json['amount'];
//     createdby = json['createdby'];
//     modifiedby = json['modifiedby'];
//     cardnumber = json['cardnumber'];
//     fundsprocessed = json['fundsprocessed'];
//     servicecharge = json['servicecharge'];
//     servicechargedescription = json['servicechargedescription'];
//     audittype = json['audittype'];
//     auditcomment = json['auditcomment'];
//     websiteRefNo = json['website_ref_no'];
//     transactionSummary = json['transaction_summary'];
//     cardholdername = json['cardholdername'];
//     cardsixdigit = json['cardsixdigit'];
//     bincardstatusvalue = json['bincardstatusvalue'];
//     txniptrackervalue = json['txniptrackervalue'];
//     inprocess = json['inprocess'];
//     isTxnRecounciliationInprogress = json['isTxnRecounciliationInprogress'];
//     verified = json['verified'];
//     updatetxnby = json['updatetxnby'];
//     refundTicketNotes = json['refund_ticket_notes'];
//     isSuspicious = json['is_suspicious'];
//     suspiciousNote = json['suspicious_note'];
//     isFraud = json['isFraud'];
//     osHistory = json['os_history'];
//     creditcardpaymentmodeid = json['creditcardpaymentmodeid'];
//     debitcardpaymentmodeid = json['debitcardpaymentmodeid'];
//     refundcharge = json['refundcharge'];
//     refundchargedescription = json['refundchargedescription'];
//     refundType = json['refund_type'];
//     partialRefundRemainAmount = json['partialRefundRemainAmount'];
//     isTechnicalRefund = json['isTechnicalRefund'];
//     technicalRefundComment = json['technicalRefundComment'];
//     debitRefundBankPending = json['debit_refund_bank_pending'];
//     debitRefundResponsePun = json['debit_refund_response_pun'];
//     debitRefundBankRequestDate = json['debit_refund_bank_request_date'];
//     refundStatusUpdatedBy = json['refund_status_updated_by'];
//     transactionNote = json['transaction_note'];
//     txnBankStatus = json['txn_bank_status'];
//     partialServiceCharge = json['partialServiceCharge'];
//     partialServiceChargeDescription = json['partialServiceChargeDescription'];
//     subscriptionInvoiceId = json['subscriptionInvoiceId'];
//     cardtype = json['cardtype'];
//     sourceofTxn = json['sourceofTxn'];
//     isDisputed = json['isDisputed'];
//     id = json['id'];
//     transactiondate = json['transactiondate'];
//     deletedAt = json['deletedAt'];
//     created = json['created'];
//     modified = json['modified'];
//     disputeId = json['disputeId'];
//     transactionentityId = json['transactionentityId'];
//     transactionmodeId = json['transactionmodeId'];
//     transactionstatusId = json['transactionstatusId'];
//     guestuserId = json['guestuserId'];
//     postransactionId = json['postransactionId'];
//     cardschemeid = json['cardschemeid'];
//     entityId = json['entityId'] != null
//         ? new EntityId.fromJson(json['entityId'])
//         : null;
//     actualTxn = json['actualTxn'] != null
//         ? new ActualTxn.fromJson(json['actualTxn'])
//         : null;
//     if (json['refundTxn'] != null) {
//       refundTxn = <Null>[];
//       json['refundTxn'].forEach((v) {
//         refundTxn!.add(new Null.fromJson(v));
//       });
//     }
//     priorRefundAmount = json['priorRefundAmount'];
//     priorRefundRequestedAmount = json['priorRefundRequestedAmount'];
//     senderId = json['senderId'] != null
//         ? new SenderId.fromJson(json['senderId'])
//         : null;
//     receiverId = json['receiverId'];
//     salesUserId = json['sales_userId'];
//     posUserId = json['pos_userId'];
//     transactionentity = json['transactionentity'] != null
//         ? new Transactionentity.fromJson(json['transactionentity'])
//         : null;
//     transactionmode = json['transactionmode'] != null
//         ? new Transactionentity.fromJson(json['transactionmode'])
//         : null;
//     transactionstatus = json['transactionstatus'] != null
//         ? new Transactionentity.fromJson(json['transactionstatus'])
//         : null;
//     postransaction = json['postransaction'] != null
//         ? new Postransaction.fromJson(json['postransaction'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['entityid'] = this.entityid;
//     data['IPN_id'] = this.iPNId;
//     data['invoicenumber'] = this.invoicenumber;
//     data['verificationstatus'] = this.verificationstatus;
//     data['isRefund'] = this.isRefund;
//     data['isPartialRefund'] = this.isPartialRefund;
//     data['refundamount'] = this.refundamount;
//     data['verifiedby'] = this.verifiedby;
//     data['verifiedbysystem'] = this.verifiedbysystem;
//     data['verifiedon'] = this.verifiedon;
//     data['amount'] = this.amount;
//     data['createdby'] = this.createdby;
//     data['modifiedby'] = this.modifiedby;
//     data['cardnumber'] = this.cardnumber;
//     data['fundsprocessed'] = this.fundsprocessed;
//     data['servicecharge'] = this.servicecharge;
//     data['servicechargedescription'] = this.servicechargedescription;
//     data['audittype'] = this.audittype;
//     data['auditcomment'] = this.auditcomment;
//     data['website_ref_no'] = this.websiteRefNo;
//     data['transaction_summary'] = this.transactionSummary;
//     data['cardholdername'] = this.cardholdername;
//     data['cardsixdigit'] = this.cardsixdigit;
//     data['bincardstatusvalue'] = this.bincardstatusvalue;
//     data['txniptrackervalue'] = this.txniptrackervalue;
//     data['inprocess'] = this.inprocess;
//     data['isTxnRecounciliationInprogress'] =
//         this.isTxnRecounciliationInprogress;
//     data['verified'] = this.verified;
//     data['updatetxnby'] = this.updatetxnby;
//     data['refund_ticket_notes'] = this.refundTicketNotes;
//     data['is_suspicious'] = this.isSuspicious;
//     data['suspicious_note'] = this.suspiciousNote;
//     data['isFraud'] = this.isFraud;
//     data['os_history'] = this.osHistory;
//     data['creditcardpaymentmodeid'] = this.creditcardpaymentmodeid;
//     data['debitcardpaymentmodeid'] = this.debitcardpaymentmodeid;
//     data['refundcharge'] = this.refundcharge;
//     data['refundchargedescription'] = this.refundchargedescription;
//     data['refund_type'] = this.refundType;
//     data['partialRefundRemainAmount'] = this.partialRefundRemainAmount;
//     data['isTechnicalRefund'] = this.isTechnicalRefund;
//     data['technicalRefundComment'] = this.technicalRefundComment;
//     data['debit_refund_bank_pending'] = this.debitRefundBankPending;
//     data['debit_refund_response_pun'] = this.debitRefundResponsePun;
//     data['debit_refund_bank_request_date'] = this.debitRefundBankRequestDate;
//     data['refund_status_updated_by'] = this.refundStatusUpdatedBy;
//     data['transaction_note'] = this.transactionNote;
//     data['txn_bank_status'] = this.txnBankStatus;
//     data['partialServiceCharge'] = this.partialServiceCharge;
//     data['partialServiceChargeDescription'] =
//         this.partialServiceChargeDescription;
//     data['subscriptionInvoiceId'] = this.subscriptionInvoiceId;
//     data['cardtype'] = this.cardtype;
//     data['sourceofTxn'] = this.sourceofTxn;
//     data['isDisputed'] = this.isDisputed;
//     data['id'] = this.id;
//     data['transactiondate'] = this.transactiondate;
//     data['deletedAt'] = this.deletedAt;
//     data['created'] = this.created;
//     data['modified'] = this.modified;
//     data['disputeId'] = this.disputeId;
//     data['transactionentityId'] = this.transactionentityId;
//     data['transactionmodeId'] = this.transactionmodeId;
//     data['transactionstatusId'] = this.transactionstatusId;
//     data['guestuserId'] = this.guestuserId;
//     data['postransactionId'] = this.postransactionId;
//     data['cardschemeid'] = this.cardschemeid;
//     if (this.entityId != null) {
//       data['entityId'] = this.entityId!.toJson();
//     }
//     if (this.actualTxn != null) {
//       data['actualTxn'] = this.actualTxn!.toJson();
//     }
//     if (this.refundTxn != null) {
//       data['refundTxn'] = this.refundTxn!.map((v) => v.toJson()).toList();
//     }
//     data['priorRefundAmount'] = this.priorRefundAmount;
//     data['priorRefundRequestedAmount'] = this.priorRefundRequestedAmount;
//     if (this.senderId != null) {
//       data['senderId'] = this.senderId!.toJson();
//     }
//     data['receiverId'] = this.receiverId;
//     data['sales_userId'] = this.salesUserId;
//     data['pos_userId'] = this.posUserId;
//     if (this.transactionentity != null) {
//       data['transactionentity'] = this.transactionentity!.toJson();
//     }
//     if (this.transactionmode != null) {
//       data['transactionmode'] = this.transactionmode!.toJson();
//     }
//     if (this.transactionstatus != null) {
//       data['transactionstatus'] = this.transactionstatus!.toJson();
//     }
//     if (this.postransaction != null) {
//       data['postransaction'] = this.postransaction!.toJson();
//     }
//     return data;
//   }
// }
//
// class EntityId {
// var entityid;
// var iPNId;
// var invoicenumber;
//   bool? verificationstatus;
//   bool? isRefund;
//   bool? isPartialRefund;
//  var  refundamount;
//  var  verifiedby;
//  var  verifiedbysystem;
//  var  verifiedon;
//  var amount;
//  var  createdby;
//  var  modifiedby;
//  var  cardnumber;
//  var  fundsprocessed;
// var servicecharge;
//   var  servicechargedescription;
//   var audittype;
//   var  auditcomment;
//   var  websiteRefNo;
//   var  transactionSummary;
// var txnip;
//  var cardholdername;
//  var cardsixdigit;
//  var bincardstatusvalue;
// var txniptrackervalue;
//   var inprocess;
//   var isTxnRecounciliationInprogress;
//   var verified;
//   var  updatetxnby;
//   var  refundTicketNotes;
// var isSuspicious;
// var suspiciousNote;
//   bool? isFraud;
// var osHistory;
// var creditcardpaymentmodeid;
// var debitcardpaymentmodeid;
// var refundcharge;
//   var refundchargedescription;
//   var refundType;
//   var partialRefundRemainAmount;
// var isTechnicalRefund;
// var technicalRefundComment;
// var debitRefundBankPending;
// var debitRefundResponsePun;
// var debitRefundBankRequestDate;
// var refundStatusUpdatedBy;
// var transactionNote;
// var txnBankStatus;
//   var partialServiceCharge;
//   var partialServiceChargeDescription;
//  var subscriptionInvoiceId;
// var cardtype;
// var sourceofTxn;
//   bool? isDisputed;
//   var id;
//  var transactiondate;
//  var deletedAt;
// var created;
// var modified;
// var disputeId;
// var transactionentityId;
// var transactionmodeId;
// var transactionstatusId;
// var  guestuserId;
// var postransactionId;
// var  cardschemeid;
//   var senderId;
//   var receiverId;
//   var salesUserId;
//   var posUserId;
//
//   EntityId(
//       {this.entityid,
//         this.iPNId,
//         this.invoicenumber,
//         this.verificationstatus,
//         this.isRefund,
//         this.isPartialRefund,
//         this.refundamount,
//         this.verifiedby,
//         this.verifiedbysystem,
//         this.verifiedon,
//         this.amount,
//         this.createdby,
//         this.modifiedby,
//         this.cardnumber,
//         this.fundsprocessed,
//         this.servicecharge,
//         this.servicechargedescription,
//         this.audittype,
//         this.auditcomment,
//         this.websiteRefNo,
//         this.transactionSummary,
//         this.txnip,
//         this.cardholdername,
//         this.cardsixdigit,
//         this.bincardstatusvalue,
//         this.txniptrackervalue,
//         this.inprocess,
//         this.isTxnRecounciliationInprogress,
//         this.verified,
//         this.updatetxnby,
//         this.refundTicketNotes,
//         this.isSuspicious,
//         this.suspiciousNote,
//         this.isFraud,
//         this.osHistory,
//         this.creditcardpaymentmodeid,
//         this.debitcardpaymentmodeid,
//         this.refundcharge,
//         this.refundchargedescription,
//         this.refundType,
//         this.partialRefundRemainAmount,
//         this.isTechnicalRefund,
//         this.technicalRefundComment,
//         this.debitRefundBankPending,
//         this.debitRefundResponsePun,
//         this.debitRefundBankRequestDate,
//         this.refundStatusUpdatedBy,
//         this.transactionNote,
//         this.txnBankStatus,
//         this.partialServiceCharge,
//         this.partialServiceChargeDescription,
//         this.subscriptionInvoiceId,
//         this.cardtype,
//         this.sourceofTxn,
//         this.isDisputed,
//         this.id,
//         this.transactiondate,
//         this.deletedAt,
//         this.created,
//         this.modified,
//         this.disputeId,
//         this.transactionentityId,
//         this.transactionmodeId,
//         this.transactionstatusId,
//         this.guestuserId,
//         this.postransactionId,
//         this.cardschemeid,
//         this.senderId,
//         this.receiverId,
//         this.salesUserId,
//         this.posUserId});
//
//   EntityId.fromJson(Map<String, dynamic> json) {
//     entityid = json['entityid'];
//     iPNId = json['IPN_id'];
//     invoicenumber = json['invoicenumber'];
//     verificationstatus = json['verificationstatus'];
//     isRefund = json['isRefund'];
//     isPartialRefund = json['isPartialRefund'];
//     refundamount = json['refundamount'];
//     verifiedby = json['verifiedby'];
//     verifiedbysystem = json['verifiedbysystem'];
//     verifiedon = json['verifiedon'];
//     amount = json['amount'];
//     createdby = json['createdby'];
//     modifiedby = json['modifiedby'];
//     cardnumber = json['cardnumber'];
//     fundsprocessed = json['fundsprocessed'];
//     servicecharge = json['servicecharge'];
//     servicechargedescription = json['servicechargedescription'];
//     audittype = json['audittype'];
//     auditcomment = json['auditcomment'];
//     websiteRefNo = json['website_ref_no'];
//     transactionSummary = json['transaction_summary'];
//     txnip = json['txnip'];
//     cardholdername = json['cardholdername'];
//     cardsixdigit = json['cardsixdigit'];
//     bincardstatusvalue = json['bincardstatusvalue'];
//     txniptrackervalue = json['txniptrackervalue'];
//     inprocess = json['inprocess'];
//     isTxnRecounciliationInprogress = json['isTxnRecounciliationInprogress'];
//     verified = json['verified'];
//     updatetxnby = json['updatetxnby'];
//     refundTicketNotes = json['refund_ticket_notes'];
//     isSuspicious = json['is_suspicious'];
//     suspiciousNote = json['suspicious_note'];
//     isFraud = json['isFraud'];
//     osHistory = json['os_history'];
//     creditcardpaymentmodeid = json['creditcardpaymentmodeid'];
//     debitcardpaymentmodeid = json['debitcardpaymentmodeid'];
//     refundcharge = json['refundcharge'];
//     refundchargedescription = json['refundchargedescription'];
//     refundType = json['refund_type'];
//     partialRefundRemainAmount = json['partialRefundRemainAmount'];
//     isTechnicalRefund = json['isTechnicalRefund'];
//     technicalRefundComment = json['technicalRefundComment'];
//     debitRefundBankPending = json['debit_refund_bank_pending'];
//     debitRefundResponsePun = json['debit_refund_response_pun'];
//     debitRefundBankRequestDate = json['debit_refund_bank_request_date'];
//     refundStatusUpdatedBy = json['refund_status_updated_by'];
//     transactionNote = json['transaction_note'];
//     txnBankStatus = json['txn_bank_status'];
//     partialServiceCharge = json['partialServiceCharge'];
//     partialServiceChargeDescription = json['partialServiceChargeDescription'];
//     subscriptionInvoiceId = json['subscriptionInvoiceId'];
//     cardtype = json['cardtype'];
//     sourceofTxn = json['sourceofTxn'];
//     isDisputed = json['isDisputed'];
//     id = json['id'];
//     transactiondate = json['transactiondate'];
//     deletedAt = json['deletedAt'];
//     created = json['created'];
//     modified = json['modified'];
//     disputeId = json['disputeId'];
//     transactionentityId = json['transactionentityId'];
//     transactionmodeId = json['transactionmodeId'];
//     transactionstatusId = json['transactionstatusId'];
//     guestuserId = json['guestuserId'];
//     postransactionId = json['postransactionId'];
//     cardschemeid = json['cardschemeid'];
//     senderId = json['senderId'];
//     receiverId = json['receiverId'];
//     salesUserId = json['sales_userId'];
//     posUserId = json['pos_userId'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['entityid'] = this.entityid;
//     data['IPN_id'] = this.iPNId;
//     data['invoicenumber'] = this.invoicenumber;
//     data['verificationstatus'] = this.verificationstatus;
//     data['isRefund'] = this.isRefund;
//     data['isPartialRefund'] = this.isPartialRefund;
//     data['refundamount'] = this.refundamount;
//     data['verifiedby'] = this.verifiedby;
//     data['verifiedbysystem'] = this.verifiedbysystem;
//     data['verifiedon'] = this.verifiedon;
//     data['amount'] = this.amount;
//     data['createdby'] = this.createdby;
//     data['modifiedby'] = this.modifiedby;
//     data['cardnumber'] = this.cardnumber;
//     data['fundsprocessed'] = this.fundsprocessed;
//     data['servicecharge'] = this.servicecharge;
//     data['servicechargedescription'] = this.servicechargedescription;
//     data['audittype'] = this.audittype;
//     data['auditcomment'] = this.auditcomment;
//     data['website_ref_no'] = this.websiteRefNo;
//     data['transaction_summary'] = this.transactionSummary;
//     data['txnip'] = this.txnip;
//     data['cardholdername'] = this.cardholdername;
//     data['cardsixdigit'] = this.cardsixdigit;
//     data['bincardstatusvalue'] = this.bincardstatusvalue;
//     data['txniptrackervalue'] = this.txniptrackervalue;
//     data['inprocess'] = this.inprocess;
//     data['isTxnRecounciliationInprogress'] =
//         this.isTxnRecounciliationInprogress;
//     data['verified'] = this.verified;
//     data['updatetxnby'] = this.updatetxnby;
//     data['refund_ticket_notes'] = this.refundTicketNotes;
//     data['is_suspicious'] = this.isSuspicious;
//     data['suspicious_note'] = this.suspiciousNote;
//     data['isFraud'] = this.isFraud;
//     data['os_history'] = this.osHistory;
//     data['creditcardpaymentmodeid'] = this.creditcardpaymentmodeid;
//     data['debitcardpaymentmodeid'] = this.debitcardpaymentmodeid;
//     data['refundcharge'] = this.refundcharge;
//     data['refundchargedescription'] = this.refundchargedescription;
//     data['refund_type'] = this.refundType;
//     data['partialRefundRemainAmount'] = this.partialRefundRemainAmount;
//     data['isTechnicalRefund'] = this.isTechnicalRefund;
//     data['technicalRefundComment'] = this.technicalRefundComment;
//     data['debit_refund_bank_pending'] = this.debitRefundBankPending;
//     data['debit_refund_response_pun'] = this.debitRefundResponsePun;
//     data['debit_refund_bank_request_date'] = this.debitRefundBankRequestDate;
//     data['refund_status_updated_by'] = this.refundStatusUpdatedBy;
//     data['transaction_note'] = this.transactionNote;
//     data['txn_bank_status'] = this.txnBankStatus;
//     data['partialServiceCharge'] = this.partialServiceCharge;
//     data['partialServiceChargeDescription'] =
//         this.partialServiceChargeDescription;
//     data['subscriptionInvoiceId'] = this.subscriptionInvoiceId;
//     data['cardtype'] = this.cardtype;
//     data['sourceofTxn'] = this.sourceofTxn;
//     data['isDisputed'] = this.isDisputed;
//     data['id'] = this.id;
//     data['transactiondate'] = this.transactiondate;
//     data['deletedAt'] = this.deletedAt;
//     data['created'] = this.created;
//     data['modified'] = this.modified;
//     data['disputeId'] = this.disputeId;
//     data['transactionentityId'] = this.transactionentityId;
//     data['transactionmodeId'] = this.transactionmodeId;
//     data['transactionstatusId'] = this.transactionstatusId;
//     data['guestuserId'] = this.guestuserId;
//     data['postransactionId'] = this.postransactionId;
//     data['cardschemeid'] = this.cardschemeid;
//     data['senderId'] = this.senderId;
//     data['receiverId'] = this.receiverId;
//     data['sales_userId'] = this.salesUserId;
//     data['pos_userId'] = this.posUserId;
//     return data;
//   }
// }
//
// class ActualTxn {
//   var invoicenumber;
//   var entityid;
//
//   ActualTxn({this.invoicenumber, this.entityid});
//
//   ActualTxn.fromJson(Map<String, dynamic> json) {
//     invoicenumber = json['invoicenumber'];
//     entityid = json['entityid'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['invoicenumber'] = this.invoicenumber;
//     data['entityid'] = this.entityid;
//     return data;
//   }
// }
//
// class SenderId {
//  var profilepic;
//  var sadadId;
//  var name;
//   bool? agreement;
//   var signature;
//   bool? partneragreement;
//   var partnersignature;
//   bool? cellVerified;
//  var createdBy;
//  var modifiedBy;
//  var rememberToken;
//  var tokenExpiry;
//  var passwordExpiry;
//   var type;
//   var whmcsClientId;
//   var username;
//   bool? isPartnerUser;
//  var partnerUserId;
//  var addedUnderPartnerDate;
//  var addedUnderPartnerHistory;
//  var sadadPartnerID;
//  var sadadPartnerIDGeneratedDate;
//  var partnerDataUpdatedAt;
//   var businessPhoneNumber;
//   bool? isAgreedWithAutoWithdrawalTC;
//   bool? isSubUserPublicAccess;
//   var realm;
// var cellnumber;
// var email;
//   var emailVerified;
//   var id;
//   var deletedAt;
//   var created;
//   var modified;
//   var roleId;
//
//   SenderId(
//       {this.profilepic,
//         this.sadadId,
//         this.name,
//         this.agreement,
//         this.signature,
//         this.partneragreement,
//         this.partnersignature,
//         this.cellVerified,
//         this.createdBy,
//         this.modifiedBy,
//         this.rememberToken,
//         this.tokenExpiry,
//         this.passwordExpiry,
//         this.type,
//         this.whmcsClientId,
//         this.username,
//         this.isPartnerUser,
//         this.partnerUserId,
//         this.addedUnderPartnerDate,
//         this.addedUnderPartnerHistory,
//         this.sadadPartnerID,
//         this.sadadPartnerIDGeneratedDate,
//         this.partnerDataUpdatedAt,
//         this.businessPhoneNumber,
//         this.isAgreedWithAutoWithdrawalTC,
//         this.isSubUserPublicAccess,
//         this.realm,
//         this.cellnumber,
//         this.email,
//         this.emailVerified,
//         this.id,
//         this.deletedAt,
//         this.created,
//         this.modified,
//         this.roleId});
//
//   SenderId.fromJson(Map<String, dynamic> json) {
//     profilepic = json['profilepic'];
//     sadadId = json['SadadId'];
//     name = json['name'];
//     agreement = json['agreement'];
//     signature = json['signature'];
//     partneragreement = json['partneragreement'];
//     partnersignature = json['partnersignature'];
//     cellVerified = json['cellVerified'];
//     createdBy = json['createdBy'];
//     modifiedBy = json['modifiedBy'];
//     rememberToken = json['remember_token'];
//     tokenExpiry = json['token_expiry'];
//     passwordExpiry = json['password_expiry'];
//     type = json['type'];
//     whmcsClientId = json['whmcs_client_id'];
//     username = json['username'];
//     isPartnerUser = json['isPartnerUser'];
//     partnerUserId = json['partnerUserId'];
//     addedUnderPartnerDate = json['addedUnderPartnerDate'];
//     addedUnderPartnerHistory = json['addedUnderPartnerHistory'];
//     sadadPartnerID = json['sadadPartnerID'];
//     sadadPartnerIDGeneratedDate = json['SadadPartnerIDGeneratedDate'];
//     partnerDataUpdatedAt = json['partnerDataUpdatedAt'];
//     businessPhoneNumber = json['businessPhoneNumber'];
//     isAgreedWithAutoWithdrawalTC = json['isAgreedWithAutoWithdrawalTC'];
//     isSubUserPublicAccess = json['isSubUserPublicAccess'];
//     realm = json['realm'];
//     cellnumber = json['cellnumber'];
//     email = json['email'];
//     emailVerified = json['emailVerified'];
//     id = json['id'];
//     deletedAt = json['deletedAt'];
//     created = json['created'];
//     modified = json['modified'];
//     roleId = json['roleId'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['profilepic'] = this.profilepic;
//     data['SadadId'] = this.sadadId;
//     data['name'] = this.name;
//     data['agreement'] = this.agreement;
//     data['signature'] = this.signature;
//     data['partneragreement'] = this.partneragreement;
//     data['partnersignature'] = this.partnersignature;
//     data['cellVerified'] = this.cellVerified;
//     data['createdBy'] = this.createdBy;
//     data['modifiedBy'] = this.modifiedBy;
//     data['remember_token'] = this.rememberToken;
//     data['token_expiry'] = this.tokenExpiry;
//     data['password_expiry'] = this.passwordExpiry;
//     data['type'] = this.type;
//     data['whmcs_client_id'] = this.whmcsClientId;
//     data['username'] = this.username;
//     data['isPartnerUser'] = this.isPartnerUser;
//     data['partnerUserId'] = this.partnerUserId;
//     data['addedUnderPartnerDate'] = this.addedUnderPartnerDate;
//     data['addedUnderPartnerHistory'] = this.addedUnderPartnerHistory;
//     data['sadadPartnerID'] = this.sadadPartnerID;
//     data['SadadPartnerIDGeneratedDate'] = this.sadadPartnerIDGeneratedDate;
//     data['partnerDataUpdatedAt'] = this.partnerDataUpdatedAt;
//     data['businessPhoneNumber'] = this.businessPhoneNumber;
//     data['isAgreedWithAutoWithdrawalTC'] = this.isAgreedWithAutoWithdrawalTC;
//     data['isSubUserPublicAccess'] = this.isSubUserPublicAccess;
//     data['realm'] = this.realm;
//     data['cellnumber'] = this.cellnumber;
//     data['email'] = this.email;
//     data['emailVerified'] = this.emailVerified;
//     data['id'] = this.id;
//     data['deletedAt'] = this.deletedAt;
//     data['created'] = this.created;
//     data['modified'] = this.modified;
//     data['roleId'] = this.roleId;
//     return data;
//   }
// }
//
// class Transactionentity {
//   var name;
//  var createdby;
//  var modifiedby;
//   var id;
//
//   Transactionentity({this.name, this.createdby, this.modifiedby, this.id});
//
//   Transactionentity.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     createdby = json['createdby'];
//     modifiedby = json['modifiedby'];
//     id = json['id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['createdby'] = this.createdby;
//     data['modifiedby'] = this.modifiedby;
//     data['id'] = this.id;
//     return data;
//   }
// }
//
// class Postransaction {
//   var transactionId;
//   var sadadId;
//   bool? isVoid;
//   bool? isReversed;
//  var cardType;
//  var paymentMethod;
//  var cardPaymentType;
//  var transactionType;
//  var cardUsageType;
//  var maskedPan;
//  var network;
//  var rrn;
//  var tid;
//  var merchantId;
//   var customerName;
//   var customerMobile;
//   var customerEmail;
//   var transResponseCode;
//   var transResponseMessage;
//   var dataJson;
//   var terminalId;
//   var syncedAt;
//   var id;
//   var transactionId;
//   var deletedAt;
//   var created;
//   var modified;
//   Terminal? terminal;
//
//   Postransaction(
//       {this.transactionId,
//         this.sadadId,
//         this.isVoid,
//         this.isReversed,
//         this.cardType,
//         this.paymentMethod,
//         this.cardPaymentType,
//         this.transactionType,
//         this.cardUsageType,
//         this.maskedPan,
//         this.network,
//         this.rrn,
//         this.tid,
//         this.merchantId,
//         this.customerName,
//         this.customerMobile,
//         this.customerEmail,
//         this.transResponseCode,
//         this.transResponseMessage,
//         this.dataJson,
//         this.terminalId,
//         this.syncedAt,
//         this.id,
//         this.transactionId,
//         this.deletedAt,
//         this.created,
//         this.modified,
//         this.terminal});
//
//   Postransaction.fromJson(Map<String, dynamic> json) {
//     transactionId = json['transaction_id'];
//     sadadId = json['SadadId'];
//     isVoid = json['is_void'];
//     isReversed = json['is_reversed'];
//     cardType = json['card_type'];
//     paymentMethod = json['payment_method'];
//     cardPaymentType = json['card_payment_type'];
//     transactionType = json['transaction_type'];
//     cardUsageType = json['card_usage_type'];
//     maskedPan = json['masked_pan'];
//     network = json['network'];
//     rrn = json['rrn'];
//     tid = json['tid'];
//     merchantId = json['merchant_id'];
//     customerName = json['customer_name'];
//     customerMobile = json['customer_mobile'];
//     customerEmail = json['customer_email'];
//     transResponseCode = json['trans_response_code'];
//     transResponseMessage = json['trans_response_message'];
//     dataJson = json['dataJson'];
//     terminalId = json['terminalId'];
//     syncedAt = json['syncedAt'];
//     id = json['id'];
//     transactionId = json['transactionId'];
//     deletedAt = json['deletedAt'];
//     created = json['created'];
//     modified = json['modified'];
//     terminal = json['terminal'] != null
//         ? new Terminal.fromJson(json['terminal'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['transaction_id'] = this.transactionId;
//     data['SadadId'] = this.sadadId;
//     data['is_void'] = this.isVoid;
//     data['is_reversed'] = this.isReversed;
//     data['card_type'] = this.cardType;
//     data['payment_method'] = this.paymentMethod;
//     data['card_payment_type'] = this.cardPaymentType;
//     data['transaction_type'] = this.transactionType;
//     data['card_usage_type'] = this.cardUsageType;
//     data['masked_pan'] = this.maskedPan;
//     data['network'] = this.network;
//     data['rrn'] = this.rrn;
//     data['tid'] = this.tid;
//     data['merchant_id'] = this.merchantId;
//     data['customer_name'] = this.customerName;
//     data['customer_mobile'] = this.customerMobile;
//     data['customer_email'] = this.customerEmail;
//     data['trans_response_code'] = this.transResponseCode;
//     data['trans_response_message'] = this.transResponseMessage;
//     data['dataJson'] = this.dataJson;
//     data['terminalId'] = this.terminalId;
//     data['syncedAt'] = this.syncedAt;
//     data['id'] = this.id;
//     data['transactionId'] = this.transactionId;
//     data['deletedAt'] = this.deletedAt;
//     data['created'] = this.created;
//     data['modified'] = this.modified;
//     if (this.terminal != null) {
//       data['terminal'] = this.terminal!.toJson();
//     }
//     return data;
//   }
// }
//
// class Terminal {
//   var terminalId;
//   var name;
//   var buildingNumber;
//   var streetNumber;
//   var city;
//   var zoneNumber;
//   var zone;
//   var postalCode;
//   var latitude;
//   var longitude;
//  var status;
//  var terminalStatus;
//  var lastUpdateBy;
//  var deviceSerialNo;
//  var deviceId;
//   var rentalPlanId;
//   var rentalStartDate;
//   var rentalThreshold;
//   var simNumber;
//   var installFee;
//   var activated;
//   var deactivated;
//   var objectId;
//   var syncedAt;
//   var sadadID;
//   var previousDeviceSerialNo;
//   var previousDeviceId;
//   bool? isActive;
//   var isOnline;
//   var locationAPICalledAt;
//   var terminaltype;
//   var id;
//   var created;
//   var devicetypeId;
//   Posdevice? posdevice;
//
//   Terminal(
//       {this.terminalId,
//         this.name,
//         this.buildingNumber,
//         this.streetNumber,
//         this.city,
//         this.zoneNumber,
//         this.zone,
//         this.postalCode,
//         this.latitude,
//         this.longitude,
//         this.status,
//         this.terminalStatus,
//         this.lastUpdateBy,
//         this.deviceSerialNo,
//         this.deviceId,
//         this.rentalPlanId,
//         this.rentalStartDate,
//         this.rentalThreshold,
//         this.simNumber,
//         this.installFee,
//         this.activated,
//         this.deactivated,
//         this.objectId,
//         this.syncedAt,
//         this.sadadID,
//         this.previousDeviceSerialNo,
//         this.previousDeviceId,
//         this.isActive,
//         this.isOnline,
//         this.locationAPICalledAt,
//         this.terminaltype,
//         this.id,
//         this.created,
//         this.devicetypeId,
//         this.posdevice});
//
//   Terminal.fromJson(Map<String, dynamic> json) {
//     terminalId = json['terminalId'];
//     name = json['name'];
//     buildingNumber = json['buildingNumber'];
//     streetNumber = json['streetNumber'];
//     city = json['city'];
//     zoneNumber = json['zoneNumber'];
//     zone = json['zone'];
//     postalCode = json['postalCode'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     status = json['status'];
//     terminalStatus = json['terminalStatus'];
//     lastUpdateBy = json['lastUpdateBy'];
//     deviceSerialNo = json['deviceSerialNo'];
//     deviceId = json['deviceId'];
//     rentalPlanId = json['rentalPlanId'];
//     rentalStartDate = json['rentalStartDate'];
//     rentalThreshold = json['rentalThreshold'];
//     simNumber = json['simNumber'];
//     installFee = json['installFee'];
//     activated = json['activated'];
//     deactivated = json['deactivated'];
//     objectId = json['objectId'];
//     syncedAt = json['syncedAt'];
//     sadadID = json['SadadID'];
//     previousDeviceSerialNo = json['previousDeviceSerialNo'];
//     previousDeviceId = json['previousDeviceId'];
//     isActive = json['is_active'];
//     isOnline = json['is_online'];
//     locationAPICalledAt = json['locationAPICalledAt'];
//     terminaltype = json['terminaltype'];
//     id = json['id'];
//     created = json['created'];
//     devicetypeId = json['devicetypeId'];
//     posdevice = json['posdevice'] != null
//         ? new Posdevice.fromJson(json['posdevice'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['terminalId'] = this.terminalId;
//     data['name'] = this.name;
//     data['buildingNumber'] = this.buildingNumber;
//     data['streetNumber'] = this.streetNumber;
//     data['city'] = this.city;
//     data['zoneNumber'] = this.zoneNumber;
//     data['zone'] = this.zone;
//     data['postalCode'] = this.postalCode;
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     data['status'] = this.status;
//     data['terminalStatus'] = this.terminalStatus;
//     data['lastUpdateBy'] = this.lastUpdateBy;
//     data['deviceSerialNo'] = this.deviceSerialNo;
//     data['deviceId'] = this.deviceId;
//     data['rentalPlanId'] = this.rentalPlanId;
//     data['rentalStartDate'] = this.rentalStartDate;
//     data['rentalThreshold'] = this.rentalThreshold;
//     data['simNumber'] = this.simNumber;
//     data['installFee'] = this.installFee;
//     data['activated'] = this.activated;
//     data['deactivated'] = this.deactivated;
//     data['objectId'] = this.objectId;
//     data['syncedAt'] = this.syncedAt;
//     data['SadadID'] = this.sadadID;
//     data['previousDeviceSerialNo'] = this.previousDeviceSerialNo;
//     data['previousDeviceId'] = this.previousDeviceId;
//     data['is_active'] = this.isActive;
//     data['is_online'] = this.isOnline;
//     data['locationAPICalledAt'] = this.locationAPICalledAt;
//     data['terminaltype'] = this.terminaltype;
//     data['id'] = this.id;
//     data['created'] = this.created;
//     data['devicetypeId'] = this.devicetypeId;
//     if (this.posdevice != null) {
//       data['posdevice'] = this.posdevice!.toJson();
//     }
//     return data;
//   }
// }
//
// class Posdevice {
//   var serial;
//   var deviceId;
//   var devicetype;
//   var imei;
//   var lastlocation;
//   var lastactivetime;
//   var id;
//   var deletedAt;
//  var  created;
//  var  modified;
//   var mainmerchantId;
//
//   Posdevice(
//       {this.serial,
//         this.deviceId,
//         this.devicetype,
//         this.imei,
//         this.lastlocation,
//         this.lastactivetime,
//         this.id,
//         this.deletedAt,
//         this.created,
//         this.modified,
//         this.mainmerchantId});
//
//   Posdevice.fromJson(Map<String, dynamic> json) {
//     serial = json['serial'];
//     deviceId = json['deviceId'];
//     devicetype = json['devicetype'];
//     imei = json['imei'];
//     lastlocation = json['lastlocation'];
//     lastactivetime = json['lastactivetime'];
//     id = json['id'];
//     deletedAt = json['deletedAt'];
//     created = json['created'];
//     modified = json['modified'];
//     mainmerchantId = json['mainmerchantId'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['serial'] = this.serial;
//     data['deviceId'] = this.deviceId;
//     data['devicetype'] = this.devicetype;
//     data['imei'] = this.imei;
//     data['lastlocation'] = this.lastlocation;
//     data['lastactivetime'] = this.lastactivetime;
//     data['id'] = this.id;
//     data['deletedAt'] = this.deletedAt;
//     data['created'] = this.created;
//     data['modified'] = this.modified;
//     data['mainmerchantId'] = this.mainmerchantId;
//     return data;
//   }
// }
//
// class Transaction {
//   Transaction({
//     this.name,
//     this.createdby,
//     this.modifiedby,
//     this.id,
//   });
//
//   var name;
//   dynamic createdby;
//   dynamic modifiedby;
//   var id;
//
//   factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
//     name: json["name"],
//     createdby: json["createdby"],
//     modifiedby: json["modifiedby"],
//     id: json["id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "createdby": createdby,
//     "modifiedby": modifiedby,
//     "id": id,
//   };
// }
//
// class Txn_bank_status {
//   var date;
//   var txnID;
//   var code;
//   var message;
//
//   Txn_bank_status({this.date, this.txnID, this.code, this.message});
//
//   Txn_bank_status.fromJson(Map<String, dynamic> json) {
//     date = json['Date'];
//     txnID = json['TxnID'];
//     code = json['Code'];
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Date'] = this.date;
//     data['TxnID'] = this.txnID;
//     data['Code'] = this.code;
//     data['message'] = this.message;
//     return data;
//   }
// }
//
// class ReceiverId {
//   var profilepic;
//   var sadadId;
//   var name;
//   bool? agreement;
//   var signature;
//   bool? partneragreement;
//   var partnersignature;
//   bool? cellVerified;
//   var createdBy;
//   var modifiedBy;
//   var rememberToken;
//   var tokenExpiry;
//   var passwordExpiry;
//   var type;
//   var whmcsClientId;
//   var username;
//   bool? isPartnerUser;
//   var partnerUserId;
//   var addedUnderPartnerDate;
//   var addedUnderPartnerHistory;
//   var sadadPartnerID;
//   var sadadPartnerIDGeneratedDate;
//   var partnerDataUpdatedAt;
//   var businessPhoneNumber;
//   bool? isAgreedWithAutoWithdrawalTC;
//   bool? isSubUserPublicAccess;
//   var realm;
//   var cellnumber;
//   var email;
//   var emailVerified;
//   var id;
//   var deletedAt;
//   var created;
//   var modified;
//   var roleId;
//
//   ReceiverId(
//       {this.profilepic,
//         this.sadadId,
//         this.name,
//         this.agreement,
//         this.signature,
//         this.partneragreement,
//         this.partnersignature,
//         this.cellVerified,
//         this.createdBy,
//         this.modifiedBy,
//         this.rememberToken,
//         this.tokenExpiry,
//         this.passwordExpiry,
//         this.type,
//         this.whmcsClientId,
//         this.username,
//         this.isPartnerUser,
//         this.partnerUserId,
//         this.addedUnderPartnerDate,
//         this.addedUnderPartnerHistory,
//         this.sadadPartnerID,
//         this.sadadPartnerIDGeneratedDate,
//         this.partnerDataUpdatedAt,
//         this.businessPhoneNumber,
//         this.isAgreedWithAutoWithdrawalTC,
//         this.isSubUserPublicAccess,
//         this.realm,
//         this.cellnumber,
//         this.email,
//         this.emailVerified,
//         this.id,
//         this.deletedAt,
//         this.created,
//         this.modified,
//         this.roleId});
//
//   ReceiverId.fromJson(Map<String, dynamic> json) {
//     profilepic = json['profilepic'];
//     sadadId = json['SadadId'];
//     name = json['name'];
//     agreement = json['agreement'];
//     signature = json['signature'];
//     partneragreement = json['partneragreement'];
//     partnersignature = json['partnersignature'];
//     cellVerified = json['cellVerified'];
//     createdBy = json['createdBy'];
//     modifiedBy = json['modifiedBy'];
//     rememberToken = json['remember_token'];
//     tokenExpiry = json['token_expiry'];
//     passwordExpiry = json['password_expiry'];
//     type = json['type'];
//     whmcsClientId = json['whmcs_client_id'];
//     username = json['username'];
//     isPartnerUser = json['isPartnerUser'];
//     partnerUserId = json['partnerUserId'];
//     addedUnderPartnerDate = json['addedUnderPartnerDate'];
//     addedUnderPartnerHistory = json['addedUnderPartnerHistory'];
//     sadadPartnerID = json['sadadPartnerID'];
//     sadadPartnerIDGeneratedDate = json['SadadPartnerIDGeneratedDate'];
//     partnerDataUpdatedAt = json['partnerDataUpdatedAt'];
//     businessPhoneNumber = json['businessPhoneNumber'];
//     isAgreedWithAutoWithdrawalTC = json['isAgreedWithAutoWithdrawalTC'];
//     isSubUserPublicAccess = json['isSubUserPublicAccess'];
//     realm = json['realm'];
//     cellnumber = json['cellnumber'];
//     email = json['email'];
//     emailVerified = json['emailVerified'];
//     id = json['id'];
//     deletedAt = json['deletedAt'];
//     created = json['created'];
//     modified = json['modified'];
//     roleId = json['roleId'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['profilepic'] = this.profilepic;
//     data['SadadId'] = this.sadadId;
//     data['name'] = this.name;
//     data['agreement'] = this.agreement;
//     data['signature'] = this.signature;
//     data['partneragreement'] = this.partneragreement;
//     data['partnersignature'] = this.partnersignature;
//     data['cellVerified'] = this.cellVerified;
//     data['createdBy'] = this.createdBy;
//     data['modifiedBy'] = this.modifiedBy;
//     data['remember_token'] = this.rememberToken;
//     data['token_expiry'] = this.tokenExpiry;
//     data['password_expiry'] = this.passwordExpiry;
//     data['type'] = this.type;
//     data['whmcs_client_id'] = this.whmcsClientId;
//     data['username'] = this.username;
//     data['isPartnerUser'] = this.isPartnerUser;
//     data['partnerUserId'] = this.partnerUserId;
//     data['addedUnderPartnerDate'] = this.addedUnderPartnerDate;
//     data['addedUnderPartnerHistory'] = this.addedUnderPartnerHistory;
//     data['sadadPartnerID'] = this.sadadPartnerID;
//     data['SadadPartnerIDGeneratedDate'] = this.sadadPartnerIDGeneratedDate;
//     data['partnerDataUpdatedAt'] = this.partnerDataUpdatedAt;
//     data['businessPhoneNumber'] = this.businessPhoneNumber;
//     data['isAgreedWithAutoWithdrawalTC'] = this.isAgreedWithAutoWithdrawalTC;
//     data['isSubUserPublicAccess'] = this.isSubUserPublicAccess;
//     data['realm'] = this.realm;
//     data['cellnumber'] = this.cellnumber;
//     data['email'] = this.email;
//     data['emailVerified'] = this.emailVerified;
//     data['id'] = this.id;
//     data['deletedAt'] = this.deletedAt;
//     data['created'] = this.created;
//     data['modified'] = this.modified;
//     data['roleId'] = this.roleId;
//     return data;
//   }
// }
