class PosPaymentDetailResponseModel {
  var entityid;
  var iPNId;
  var invoicenumber;
  var verificationstatus;
  var isRefund;
  var isPartialRefund;
  var refundamount;
  var verifiedby;
  var verifiedbysystem;
  var verifiedon;
  var amount;
  var createdby;
  var modifiedby;
  var cardnumber;
  var fundsprocessed;
  var servicecharge;
  var servicechargedescription;
  var audittype;
  var auditcomment;
  var websiteRefNo;
  var transactionSummary;
  var txnip;
  var cardholdername;
  var cardsixdigit;
  var bincardstatusvalue;
  var txniptrackervalue;
  var inprocess;
  var verified;
  var updatetxnby;
  var refundTicketNotes;
  var isSuspicious;
  var suspiciousNote;
  var isFraud;
  var osHistory;
  var creditcardpaymentmodeid;
  var debitcardpaymentmodeid;
  var refundcharge;
  var refundchargedescription;
  var refundType;
  var partialRefundRemainAmount;
  var isTechnicalRefund;
  var technicalRefundComment;
  var debitRefundBankPending;
  var debitRefundResponsePun;
  var debitRefundBankRequestDate;
  var refundStatusUpdatedBy;
  var transactionNote;
  var txnBankStatus;
  var partialServiceCharge;
  var partialServiceChargeDescription;
  var subscriptionInvoiceId;
  var cardtype;
  var sourceofTxn;
  var isDisputed;
  var id;
  var transactiondate;
  var deletedAt;
  var created;
  var modified;
  var disputeId;
  var transactionentityId;
  var transactionmodeId;
  var transactionstatusId;
  var guestuserId;
  var postransactionId;
  var cardschemeid;
  var refundId;
  var priorRefundAmount;
  var priorRefundRequestedAmount;
  var senderId;
  List<RefundTxn>? refundTxn;
  ReceiverId? receiverId;
  var salesUserId;
  var posUserId;
  Dispute? dispute;
  Transactionentity? transactionentity;
  Transactionentity? transactionmode;
  Transactionentity? transactionstatus;
  Postransaction? postransaction;

  PosPaymentDetailResponseModel(
      {this.entityid,
      this.iPNId,
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
      this.refundTxn,
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
      this.refundId,
      this.priorRefundAmount,
      this.priorRefundRequestedAmount,
      this.senderId,
      this.receiverId,
      this.salesUserId,
      this.posUserId,
      this.transactionentity,
      this.dispute,
      this.transactionmode,
      this.transactionstatus,
      this.postransaction});

  PosPaymentDetailResponseModel.fromJson(Map<String, dynamic> json) {
    entityid = json['entityid'];
    iPNId = json['IPN_id'];
    invoicenumber = json['invoicenumber'];
    verificationstatus = json['verificationstatus'];
    isRefund = json['isRefund'];
    isPartialRefund = json['isPartialRefund'];
    refundamount = json['refundamount'];
    verifiedby = json['verifiedby'];
    verifiedbysystem = json['verifiedbysystem'];
    verifiedon = json['verifiedon'];
    amount = json['amount'];
    if (json['refundTxn'] != null) {
      refundTxn = <RefundTxn>[];
      json['refundTxn'].forEach((v) {
        refundTxn!.add(new RefundTxn.fromJson(v));
      });
    }
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    cardnumber = json['cardnumber'];
    fundsprocessed = json['fundsprocessed'];
    servicecharge = json['servicecharge'];
    servicechargedescription = json['servicechargedescription'];
    audittype = json['audittype'];
    auditcomment = json['auditcomment'];
    websiteRefNo = json['website_ref_no'];
    transactionSummary = json['transaction_summary'];
    txnip = json['txnip'];
    cardholdername = json['cardholdername'];
    cardsixdigit = json['cardsixdigit'];
    bincardstatusvalue = json['bincardstatusvalue'];
    txniptrackervalue = json['txniptrackervalue'];
    inprocess = json['inprocess'];
    verified = json['verified'];
    dispute =
        json['dispute'] != null ? new Dispute.fromJson(json['dispute']) : null;
    updatetxnby = json['updatetxnby'];
    refundTicketNotes = json['refund_ticket_notes'];
    isSuspicious = json['is_suspicious'];
    suspiciousNote = json['suspicious_note'];
    isFraud = json['isFraud'];
    osHistory = json['os_history'];
    creditcardpaymentmodeid = json['creditcardpaymentmodeid'];
    debitcardpaymentmodeid = json['debitcardpaymentmodeid'];
    refundcharge = json['refundcharge'];
    refundchargedescription = json['refundchargedescription'];
    refundType = json['refund_type'];
    partialRefundRemainAmount = json['partialRefundRemainAmount'];
    isTechnicalRefund = json['isTechnicalRefund'];
    technicalRefundComment = json['technicalRefundComment'];
    debitRefundBankPending = json['debit_refund_bank_pending'];
    debitRefundResponsePun = json['debit_refund_response_pun'];
    debitRefundBankRequestDate = json['debit_refund_bank_request_date'];
    refundStatusUpdatedBy = json['refund_status_updated_by'];
    transactionNote = json['transaction_note'];
    txnBankStatus = json['txn_bank_status'];
    partialServiceCharge = json['partialServiceCharge'];
    partialServiceChargeDescription = json['partialServiceChargeDescription'];
    subscriptionInvoiceId = json['subscriptionInvoiceId'];
    cardtype = json['cardtype'];
    sourceofTxn = json['sourceofTxn'];
    isDisputed = json['isDisputed'];
    id = json['id'];
    transactiondate = json['transactiondate'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    modified = json['modified'];
    disputeId = json['disputeId'];
    transactionentityId = json['transactionentityId'];
    transactionmodeId = json['transactionmodeId'];
    transactionstatusId = json['transactionstatusId'];
    guestuserId = json['guestuserId'];
    postransactionId = json['postransactionId'];
    cardschemeid = json['cardschemeid'];
    refundId = json['refundId'];
    priorRefundAmount = json['priorRefundAmount'];
    priorRefundRequestedAmount = json['priorRefundRequestedAmount'];
    senderId = json['senderId'];
    receiverId = json['receiverId'] != null
        ? json['receiverId'] is int
            ? null
            : new ReceiverId.fromJson(json['receiverId'])
        : null;
    salesUserId = json['sales_userId'];
    posUserId = json['pos_userId'];
    transactionentity = json['transactionentity'] != null
        ? new Transactionentity.fromJson(json['transactionentity'])
        : null;
    transactionmode = json['transactionmode'] != null
        ? new Transactionentity.fromJson(json['transactionmode'])
        : null;
    transactionstatus = json['transactionstatus'] != null
        ? new Transactionentity.fromJson(json['transactionstatus'])
        : null;
    postransaction = json['postransaction'] != null
        ? new Postransaction.fromJson(json['postransaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entityid'] = this.entityid;
    data['IPN_id'] = this.iPNId;
    data['invoicenumber'] = this.invoicenumber;
    data['verificationstatus'] = this.verificationstatus;
    data['isRefund'] = this.isRefund;
    data['isPartialRefund'] = this.isPartialRefund;
    data['refundamount'] = this.refundamount;
    data['verifiedby'] = this.verifiedby;
    data['verifiedbysystem'] = this.verifiedbysystem;
    data['verifiedon'] = this.verifiedon;
    data['amount'] = this.amount;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['cardnumber'] = this.cardnumber;
    data['fundsprocessed'] = this.fundsprocessed;
    data['servicecharge'] = this.servicecharge;
    data['servicechargedescription'] = this.servicechargedescription;
    data['audittype'] = this.audittype;
    data['auditcomment'] = this.auditcomment;
    data['website_ref_no'] = this.websiteRefNo;
    data['transaction_summary'] = this.transactionSummary;
    data['txnip'] = this.txnip;
    data['cardholdername'] = this.cardholdername;
    data['cardsixdigit'] = this.cardsixdigit;
    data['bincardstatusvalue'] = this.bincardstatusvalue;
    data['txniptrackervalue'] = this.txniptrackervalue;
    data['inprocess'] = this.inprocess;
    data['verified'] = this.verified;
    data['updatetxnby'] = this.updatetxnby;
    data['refund_ticket_notes'] = this.refundTicketNotes;
    data['is_suspicious'] = this.isSuspicious;
    data['suspicious_note'] = this.suspiciousNote;
    data['isFraud'] = this.isFraud;
    data['os_history'] = this.osHistory;
    data['creditcardpaymentmodeid'] = this.creditcardpaymentmodeid;
    data['debitcardpaymentmodeid'] = this.debitcardpaymentmodeid;
    data['refundcharge'] = this.refundcharge;
    data['refundchargedescription'] = this.refundchargedescription;
    data['refund_type'] = this.refundType;
    data['partialRefundRemainAmount'] = this.partialRefundRemainAmount;
    data['isTechnicalRefund'] = this.isTechnicalRefund;
    data['technicalRefundComment'] = this.technicalRefundComment;
    data['debit_refund_bank_pending'] = this.debitRefundBankPending;
    data['debit_refund_response_pun'] = this.debitRefundResponsePun;
    data['debit_refund_bank_request_date'] = this.debitRefundBankRequestDate;
    data['refund_status_updated_by'] = this.refundStatusUpdatedBy;
    data['transaction_note'] = this.transactionNote;
    data['txn_bank_status'] = this.txnBankStatus;
    data['partialServiceCharge'] = this.partialServiceCharge;
    data['partialServiceChargeDescription'] =
        this.partialServiceChargeDescription;
    data['subscriptionInvoiceId'] = this.subscriptionInvoiceId;
    data['cardtype'] = this.cardtype;
    data['sourceofTxn'] = this.sourceofTxn;
    data['isDisputed'] = this.isDisputed;
    data['id'] = this.id;
    if (this.refundTxn != null) {
      data['refundTxn'] = this.refundTxn!.map((v) => v.toJson()).toList();
    }
    data['transactiondate'] = this.transactiondate;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['disputeId'] = this.disputeId;
    data['transactionentityId'] = this.transactionentityId;
    data['transactionmodeId'] = this.transactionmodeId;
    data['transactionstatusId'] = this.transactionstatusId;
    data['guestuserId'] = this.guestuserId;
    data['postransactionId'] = this.postransactionId;
    data['cardschemeid'] = this.cardschemeid;
    data['refundId'] = this.refundId;
    data['priorRefundAmount'] = this.priorRefundAmount;
    data['priorRefundRequestedAmount'] = this.priorRefundRequestedAmount;
    data['senderId'] = this.senderId;
    if (this.dispute != null) {
      data['dispute'] = this.dispute!.toJson();
    }
    if (this.receiverId != null) {
      data['receiverId'] = this.receiverId!.toJson();
    }
    data['sales_userId'] = this.salesUserId;
    data['pos_userId'] = this.posUserId;
    if (this.transactionentity != null) {
      data['transactionentity'] = this.transactionentity!.toJson();
    }
    if (this.transactionmode != null) {
      data['transactionmode'] = this.transactionmode!.toJson();
    }
    if (this.transactionstatus != null) {
      data['transactionstatus'] = this.transactionstatus!.toJson();
    }
    if (this.postransaction != null) {
      data['postransaction'] = this.postransaction!.toJson();
    }
    return data;
  }
}

class Dispute {
  var disputeId;
  var amount;
  var comment;
  var discussion;
  var createdby;
  var modifiedby;
  var isPOS;
  var id;
  var transactionId;
  var created;
  var modified;
  var disputestatusId;
  var disputetypeId;
  var guestuserId;
  var senderId;
  var receiverId;

  Dispute(
      {this.disputeId,
      this.amount,
      this.comment,
      this.discussion,
      this.createdby,
      this.modifiedby,
      this.isPOS,
      this.id,
      this.transactionId,
      this.created,
      this.modified,
      this.disputestatusId,
      this.disputetypeId,
      this.guestuserId,
      this.senderId,
      this.receiverId});

  Dispute.fromJson(Map<String, dynamic> json) {
    disputeId = json['disputeId'];
    amount = json['amount'];
    comment = json['comment'];
    discussion = json['discussion'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    isPOS = json['isPOS'];
    id = json['id'];
    transactionId = json['transactionId'];
    created = json['created'];
    modified = json['modified'];
    disputestatusId = json['disputestatusId'];
    disputetypeId = json['disputetypeId'];
    guestuserId = json['guestuserId'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['disputeId'] = this.disputeId;
    data['amount'] = this.amount;
    data['comment'] = this.comment;
    data['discussion'] = this.discussion;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['isPOS'] = this.isPOS;
    data['id'] = this.id;
    data['transactionId'] = this.transactionId;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['disputestatusId'] = this.disputestatusId;
    data['disputetypeId'] = this.disputetypeId;
    data['guestuserId'] = this.guestuserId;
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    return data;
  }
}

class RefundTxn {
  var entityid;
  var invoicenumber;
  var amount;
  var id;
  var created;
  var modified;
  var transactionstatusId;

  RefundTxn(
      {this.entityid,
      this.invoicenumber,
      this.amount,
      this.id,
      this.created,
      this.modified,
      this.transactionstatusId});

  RefundTxn.fromJson(Map<String, dynamic> json) {
    entityid = json['entityid'];
    invoicenumber = json['invoicenumber'];
    amount = json['amount'];
    id = json['id'];
    created = json['created'];
    modified = json['modified'];
    transactionstatusId = json['transactionstatusId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entityid'] = this.entityid;
    data['invoicenumber'] = this.invoicenumber;
    data['amount'] = this.amount;
    data['id'] = this.id;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['transactionstatusId'] = this.transactionstatusId;
    return data;
  }
}

class ReceiverId {
  var profilepic;
  var sadadId;
  var name;
  var agreement;
  var signature;
  var partneragreement;
  var partnersignature;
  var cellVerified;
  var createdBy;
  var modifiedBy;
  var rememberToken;
  var tokenExpiry;
  var passwordExpiry;
  var type;
  var whmcsClientId;
  var username;
  var isPartnerUser;
  var partnerUserId;
  var addedUnderPartnerDate;
  var addedUnderPartnerHistory;
  var sadadPartnerID;
  var sadadPartnerIDGeneratedDate;
  var partnerDataUpdatedAt;
  var businessPhoneNumber;
  var isAgreedWithAutoWithdrawalTC;
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

class Transactionentity {
  var name;
  var createdby;
  var modifiedby;
  var id;

  Transactionentity({this.name, this.createdby, this.modifiedby, this.id});

  Transactionentity.fromJson(Map<String, dynamic> json) {
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

class Postransaction {
  var transaction_Id;
  var sadadId;
  var isVoid;
  var isReversed;
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
  var customerName;
  var customerMobile;
  var customerEmail;
  var transResponseCode;
  var transResponseMessage;
  var dataJson;
  var terminalId;
  var syncedAt;
  var id;
  var transactionId;
  var deletedAt;
  var created;
  var modified;
  Terminal? terminal;

  Postransaction(
      {this.transaction_Id,
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
      this.terminal});

  Postransaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    sadadId = json['SadadId'];
    isVoid = json['is_void'];
    isReversed = json['is_reversed'];
    cardType = json['card_type'];
    paymentMethod = json['payment_method'];
    cardPaymentType = json['card_payment_type'];
    transactionType = json['transaction_type'];
    cardUsageType = json['card_usage_type'];
    maskedPan = json['masked_pan'];
    network = json['network'];
    rrn = json['rrn'];
    tid = json['tid'];
    merchantId = json['merchant_id'];
    customerName = json['customer_name'];
    customerMobile = json['customer_mobile'];
    customerEmail = json['customer_email'];
    transResponseCode = json['trans_response_code'];
    transResponseMessage = json['trans_response_message'];
    dataJson = json['dataJson'];
    terminalId = json['terminalId'];
    syncedAt = json['syncedAt'];
    id = json['id'];
    transactionId = json['transactionId'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    modified = json['modified'];
    terminal = json['terminal'] != null
        ? new Terminal.fromJson(json['terminal'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_id'] = this.transactionId;
    data['SadadId'] = this.sadadId;
    data['is_void'] = this.isVoid;
    data['is_reversed'] = this.isReversed;
    data['card_type'] = this.cardType;
    data['payment_method'] = this.paymentMethod;
    data['card_payment_type'] = this.cardPaymentType;
    data['transaction_type'] = this.transactionType;
    data['card_usage_type'] = this.cardUsageType;
    data['masked_pan'] = this.maskedPan;
    data['network'] = this.network;
    data['rrn'] = this.rrn;
    data['tid'] = this.tid;
    data['merchant_id'] = this.merchantId;
    data['customer_name'] = this.customerName;
    data['customer_mobile'] = this.customerMobile;
    data['customer_email'] = this.customerEmail;
    data['trans_response_code'] = this.transResponseCode;
    data['trans_response_message'] = this.transResponseMessage;
    data['dataJson'] = this.dataJson;
    data['terminalId'] = this.terminalId;
    data['syncedAt'] = this.syncedAt;
    data['id'] = this.id;
    data['transactionId'] = this.transactionId;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    data['modified'] = this.modified;
    if (this.terminal != null) {
      data['terminal'] = this.terminal!.toJson();
    }
    return data;
  }
}

class Terminal {
  var terminalId;
  var name;
  var buildingNumber;
  var streetNumber;
  var city;
  var zoneNumber;
  var zone;
  var location;
  var postalCode;
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
  var deactivated;
  var objectId;
  var syncedAt;
  var sadadID;
  var previousDeviceSerialNo;
  var previousDeviceId;
  var isActive;
  var isOnline;
  var locationAPICalledAt;
  var terminaltype;
  var id;
  var created;
  var devicetypeId;
  Posdevice? posdevice;

  Terminal(
      {this.terminalId,
      this.name,
      this.buildingNumber,
      this.streetNumber,
      this.city,
      this.zoneNumber,
      this.zone,
        this.location,
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
      this.sadadID,
      this.previousDeviceSerialNo,
      this.previousDeviceId,
      this.isActive,
      this.isOnline,
      this.locationAPICalledAt,
      this.terminaltype,
      this.id,
      this.created,
      this.devicetypeId,
      this.posdevice});

  Terminal.fromJson(Map<String, dynamic> json) {
    terminalId = json['terminalId'];
    name = json['name'];
    buildingNumber = json['buildingNumber'];
    streetNumber = json['streetNumber'];
    city = json['city'];
    zoneNumber = json['zoneNumber'];
    zone = json['zone'];
    location = json['location'];
    postalCode = json['postalCode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    terminalStatus = json['terminalStatus'];
    lastUpdateBy = json['lastUpdateBy'];
    deviceSerialNo = json['deviceSerialNo'];
    deviceId = json['deviceId'];
    rentalPlanId = json['rentalPlanId'];
    rentalStartDate = json['rentalStartDate'];
    simNumber = json['simNumber'];
    installFee = json['installFee'];
    activated = json['activated'];
    deactivated = json['deactivated'];
    objectId = json['objectId'];
    syncedAt = json['syncedAt'];
    sadadID = json['SadadID'];
    previousDeviceSerialNo = json['previousDeviceSerialNo'];
    previousDeviceId = json['previousDeviceId'];
    isActive = json['is_active'];
    isOnline = json['is_online'];
    locationAPICalledAt = json['locationAPICalledAt'];
    terminaltype = json['terminaltype'];
    id = json['id'];
    created = json['created'];
    devicetypeId = json['devicetypeId'];
    posdevice = json['posdevice'] != null
        ? new Posdevice.fromJson(json['posdevice'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['terminalId'] = this.terminalId;
    data['name'] = this.name;
    data['buildingNumber'] = this.buildingNumber;
    data['streetNumber'] = this.streetNumber;
    data['city'] = this.city;
    data['zoneNumber'] = this.zoneNumber;
    data['zone'] = this.zone;
    data['location'] = this.location;
    data['postalCode'] = this.postalCode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['terminalStatus'] = this.terminalStatus;
    data['lastUpdateBy'] = this.lastUpdateBy;
    data['deviceSerialNo'] = this.deviceSerialNo;
    data['deviceId'] = this.deviceId;
    data['rentalPlanId'] = this.rentalPlanId;
    data['rentalStartDate'] = this.rentalStartDate;
    data['simNumber'] = this.simNumber;
    data['installFee'] = this.installFee;
    data['activated'] = this.activated;
    data['deactivated'] = this.deactivated;
    data['objectId'] = this.objectId;
    data['syncedAt'] = this.syncedAt;
    data['SadadID'] = this.sadadID;
    data['previousDeviceSerialNo'] = this.previousDeviceSerialNo;
    data['previousDeviceId'] = this.previousDeviceId;
    data['is_active'] = this.isActive;
    data['is_online'] = this.isOnline;
    data['locationAPICalledAt'] = this.locationAPICalledAt;
    data['terminaltype'] = this.terminaltype;
    data['id'] = this.id;
    data['created'] = this.created;
    data['devicetypeId'] = this.devicetypeId;
    if (this.posdevice != null) {
      data['posdevice'] = this.posdevice!.toJson();
    }
    return data;
  }
}

class Posdevice {
  var serial;
  var deviceId;
  var devicetype;
  var imei;
  var lastlocation;
  var lastactivetime;
  var id;
  var deletedAt;
  var created;
  var modified;
  var mainmerchantId;

  Posdevice(
      {this.serial,
      this.deviceId,
      this.devicetype,
      this.imei,
      this.lastlocation,
      this.lastactivetime,
      this.id,
      this.deletedAt,
      this.created,
      this.modified,
      this.mainmerchantId});

  Posdevice.fromJson(Map<String, dynamic> json) {
    serial = json['serial'];
    deviceId = json['deviceId'];
    devicetype = json['devicetype'];
    imei = json['imei'];
    lastlocation = json['lastlocation'];
    lastactivetime = json['lastactivetime'];
    id = json['id'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    modified = json['modified'];
    mainmerchantId = json['mainmerchantId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serial'] = this.serial;
    data['deviceId'] = this.deviceId;
    data['devicetype'] = this.devicetype;
    data['imei'] = this.imei;
    data['lastlocation'] = this.lastlocation;
    data['lastactivetime'] = this.lastactivetime;
    data['id'] = this.id;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['mainmerchantId'] = this.mainmerchantId;
    return data;
  }
}
