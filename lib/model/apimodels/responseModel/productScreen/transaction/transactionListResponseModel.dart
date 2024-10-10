class TransactionListResponseModel {
  var entityid;
  var iPNId;
  var invoicenumber;
  bool? verificationstatus;
  bool? isRefund;
  bool? isPartialRefund;
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
  bool? isFraud;
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
  bool? isDisputed;
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
  Invoice? invoice;
  bool? isRefundable;
  // var refundId;
  List<RefundId>? refundId;
  var priorRefundAmount;
  var priorRefundRequestedAmount;
  SenderId? senderId;
  ReceiverId? receiverId;
  var salesUserId;
  List<RefundTxn>? refundTxn;
  var posUserId;
  Transactionentity? transactionentity;
  Transactionentity? transactionmode;
  Transactionentity? transactionstatus;

  TransactionListResponseModel(
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
      this.refundTxn,
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
      this.invoice,
      this.isRefundable,
      this.refundId,
      this.priorRefundAmount,
      this.priorRefundRequestedAmount,
      this.senderId,
      this.receiverId,
      this.salesUserId,
      this.posUserId,
      this.transactionentity,
      this.transactionmode,
      this.transactionstatus});

  TransactionListResponseModel.fromJson(Map<String, dynamic> json) {
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
    invoice =
        json['invoice'] != null ? new Invoice.fromJson(json['invoice']) : null;
    isRefundable = json['isRefundable'];
    // refundId = json['refundId'];
    if (json['refundId'] != null) {
      refundId = <RefundId>[];
      json['refundId'].forEach((v) {
        refundId!.add(new RefundId.fromJson(v));
      });
    }
    priorRefundAmount = json['priorRefundAmount'];
    priorRefundRequestedAmount = json['priorRefundRequestedAmount'];
    if (json['refundTxn'] != null) {
      refundTxn = <RefundTxn>[];
      json['refundTxn'].forEach((v) {
        refundTxn!.add(new RefundTxn.fromJson(v));
      });
    }
    senderId = json['senderId'] != null
        ? json['senderId'] is int
            ? null
            : new SenderId.fromJson(json['senderId'])
        : null;
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
    data['transactiondate'] = this.transactiondate;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    if (this.refundTxn != null) {
      data['refundTxn'] = this.refundTxn!.map((v) => v.toJson()).toList();
    }
    data['modified'] = this.modified;
    data['disputeId'] = this.disputeId;
    data['transactionentityId'] = this.transactionentityId;
    data['transactionmodeId'] = this.transactionmodeId;
    data['transactionstatusId'] = this.transactionstatusId;
    data['guestuserId'] = this.guestuserId;
    data['postransactionId'] = this.postransactionId;
    data['cardschemeid'] = this.cardschemeid;
    if (this.invoice != null) {
      data['invoice'] = this.invoice!.toJson();
    }
    data['isRefundable'] = this.isRefundable;
    // data['refundId'] = this.refundId;
    if (this.refundId != null) {
      data['refundId'] = this.refundId!.map((v) => v.toJson()).toList();
    }
    data['priorRefundAmount'] = this.priorRefundAmount;
    data['priorRefundRequestedAmount'] = this.priorRefundRequestedAmount;
    if (this.senderId != null) {
      data['senderId'] = this.senderId!.toJson();
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
    return data;
  }
}

class RefundId {
  var entityid;
  var invoicenumber;
  var amount;
  var created;
  var modified;
  var transactionstatusId;

  RefundId(
      {this.entityid,
      this.invoicenumber,
      this.amount,
      this.created,
      this.modified,
      this.transactionstatusId});

  RefundId.fromJson(Map<String, dynamic> json) {
    entityid = json['entityid'];
    invoicenumber = json['invoicenumber'];
    amount = json['amount'];
    created = json['created'];
    modified = json['modified'];
    transactionstatusId = json['transactionstatusId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entityid'] = this.entityid;
    data['invoicenumber'] = this.invoicenumber;
    data['amount'] = this.amount;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['transactionstatusId'] = this.transactionstatusId;
    return data;
  }
}

class Invoice {
  var invoiceno;
  var clientname;
  var cellno;
  var emailaddress;
  bool? remarksenabled;
  var remarks;
  var grossamount;
  var transactionfees;
  var netamount;
  var expecteddelivery;
  bool? readreceipt;
  var readdatetime;
  var modifiedby;
  var isArchived;
  bool? internationalAllow;
  var paymentduedate;
  var shareUrl;
  var recurringFreq;
  var subsinvoiceId;
  var cycleperiod;
  var cycleperiodexpiry;
  var usermetadetailsid;
  var sourceofinvoice;
  bool? isrentalplaninvoice;
  var invoiceSummery;
  bool? withDetails;
  var invoiceWebhookUrl;
  var invoiceThankyouPageUrl;
  var invoiceCustomerShareUrl;
  var id;
  var date;
  var userbusinessId;
  var createdby;
  var deletedAt;
  var created;
  var sentviaId;
  var invoicestatusId;
  var usermetadetailsId;
  var invoicereceiverId;
  var invoicesenderId;

  Invoice(
      {this.invoiceno,
      this.clientname,
      this.cellno,
      this.emailaddress,
      this.remarksenabled,
      this.remarks,
      this.grossamount,
      this.transactionfees,
      this.netamount,
      this.expecteddelivery,
      this.readreceipt,
      this.readdatetime,
      this.modifiedby,
      this.isArchived,
      this.internationalAllow,
      this.paymentduedate,
      this.shareUrl,
      this.recurringFreq,
      this.subsinvoiceId,
      this.cycleperiod,
      this.cycleperiodexpiry,
      this.usermetadetailsid,
      this.sourceofinvoice,
      this.isrentalplaninvoice,
      this.invoiceSummery,
      this.withDetails,
      this.invoiceWebhookUrl,
      this.invoiceThankyouPageUrl,
      this.invoiceCustomerShareUrl,
      this.id,
      this.date,
      this.userbusinessId,
      this.createdby,
      this.deletedAt,
      this.created,
      this.sentviaId,
      this.invoicestatusId,
      this.usermetadetailsId,
      this.invoicereceiverId,
      this.invoicesenderId});

  Invoice.fromJson(Map<String, dynamic> json) {
    invoiceno = json['invoiceno'];
    clientname = json['clientname'];
    cellno = json['cellno'];
    emailaddress = json['emailaddress'];
    remarksenabled = json['remarksenabled'];
    remarks = json['remarks'];
    grossamount = json['grossamount'];
    transactionfees = json['transactionfees'];
    netamount = json['netamount'];
    expecteddelivery = json['expecteddelivery'];
    readreceipt = json['readreceipt'];
    readdatetime = json['readdatetime'];
    modifiedby = json['modifiedby'];
    isArchived = json['is_archived'];
    internationalAllow = json['internationalAllow'];
    paymentduedate = json['paymentduedate'];
    shareUrl = json['shareUrl'];
    recurringFreq = json['recurring_freq'];
    subsinvoiceId = json['subsinvoiceId'];
    cycleperiod = json['cycleperiod'];
    cycleperiodexpiry = json['cycleperiodexpiry'];
    usermetadetailsid = json['usermetadetailsid'];
    sourceofinvoice = json['sourceofinvoice'];
    isrentalplaninvoice = json['isrentalplaninvoice'];
    invoiceSummery = json['invoice_summery'];
    withDetails = json['withDetails'];
    invoiceWebhookUrl = json['invoice_webhook_url'];
    invoiceThankyouPageUrl = json['invoice_thankyou_page_url'];
    invoiceCustomerShareUrl = json['invoice_customer_share_url'];
    id = json['id'];
    date = json['date'];
    userbusinessId = json['userbusinessId'];
    createdby = json['createdby'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    sentviaId = json['sentviaId'];
    invoicestatusId = json['invoicestatusId'];
    usermetadetailsId = json['usermetadetailsId'];
    invoicereceiverId = json['invoicereceiverId'];
    invoicesenderId = json['invoicesenderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoiceno'] = this.invoiceno;
    data['clientname'] = this.clientname;
    data['cellno'] = this.cellno;
    data['emailaddress'] = this.emailaddress;
    data['remarksenabled'] = this.remarksenabled;
    data['remarks'] = this.remarks;
    data['grossamount'] = this.grossamount;
    data['transactionfees'] = this.transactionfees;
    data['netamount'] = this.netamount;
    data['expecteddelivery'] = this.expecteddelivery;
    data['readreceipt'] = this.readreceipt;
    data['readdatetime'] = this.readdatetime;
    data['modifiedby'] = this.modifiedby;
    data['is_archived'] = this.isArchived;
    data['internationalAllow'] = this.internationalAllow;
    data['paymentduedate'] = this.paymentduedate;
    data['shareUrl'] = this.shareUrl;
    data['recurring_freq'] = this.recurringFreq;
    data['subsinvoiceId'] = this.subsinvoiceId;
    data['cycleperiod'] = this.cycleperiod;
    data['cycleperiodexpiry'] = this.cycleperiodexpiry;
    data['usermetadetailsid'] = this.usermetadetailsid;
    data['sourceofinvoice'] = this.sourceofinvoice;
    data['isrentalplaninvoice'] = this.isrentalplaninvoice;
    data['invoice_summery'] = this.invoiceSummery;
    data['withDetails'] = this.withDetails;
    data['invoice_webhook_url'] = this.invoiceWebhookUrl;
    data['invoice_thankyou_page_url'] = this.invoiceThankyouPageUrl;
    data['invoice_customer_share_url'] = this.invoiceCustomerShareUrl;
    data['id'] = this.id;
    data['date'] = this.date;
    data['userbusinessId'] = this.userbusinessId;
    data['createdby'] = this.createdby;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    data['sentviaId'] = this.sentviaId;
    data['invoicestatusId'] = this.invoicestatusId;
    data['usermetadetailsId'] = this.usermetadetailsId;
    data['invoicereceiverId'] = this.invoicereceiverId;
    data['invoicesenderId'] = this.invoicesenderId;
    return data;
  }
}

class SenderId {
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
  var realm;
  var cellnumber;
  var email;
  var emailVerified;
  var id;
  var deletedAt;
  var created;
  var modified;
  var roleId;

  SenderId(
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

  SenderId.fromJson(Map<String, dynamic> json) {
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

class ReceiverId {
  var profilepic;
  var sadadId;
  var name;
  var agreement;
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

class RefundTxn {
  var entityid;
  var invoicenumber;
  var amount;
  var created;
  var modified;
  var transactionstatusId;

  RefundTxn(
      {this.entityid,
      this.invoicenumber,
      this.amount,
      this.created,
      this.modified,
      this.transactionstatusId});

  RefundTxn.fromJson(Map<String, dynamic> json) {
    entityid = json['entityid'];
    invoicenumber = json['invoicenumber'];
    amount = json['amount'];
    created = json['created'];
    modified = json['modified'];
    transactionstatusId = json['transactionstatusId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entityid'] = this.entityid;
    data['invoicenumber'] = this.invoicenumber;
    data['amount'] = this.amount;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['transactionstatusId'] = this.transactionstatusId;
    return data;
  }
}
