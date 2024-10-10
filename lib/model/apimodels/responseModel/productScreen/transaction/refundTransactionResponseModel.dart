import 'dart:convert';

class TransactionRefundDetailResponseModel {
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
  Invoice? invoice;
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
  EntityId? entityId;
  ActualTxn? actualTxn;
  Guestuser? guestuser;
  Bankresponse? bankresponse;
  BankRefundResponse? bankRefundResponse;
  SenderId? senderId;
  ReceiverId? receiverId;
  var salesUserId;
  var posUserId;
  Transactionentity? transactionentity;
  Transactionentity? transactionmode;
  Transactionentity? transactionstatus;

  TransactionRefundDetailResponseModel(
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
      this.invoice,
      this.fundsprocessed,
      this.servicecharge,
      this.servicechargedescription,
      this.audittype,
      this.bankresponse,
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
      this.bankRefundResponse,
      this.senderId,
      this.receiverId,
      this.salesUserId,
      this.posUserId,
      this.transactionentity,
      this.transactionmode,
      this.transactionstatus,
      this.guestuser});

  TransactionRefundDetailResponseModel.fromJson(Map<String, dynamic> json) {
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
    cardholdername = json['cardholdername'];
    cardsixdigit = json['cardsixdigit'];

    bincardstatusvalue = json['bincardstatusvalue'];
    // txniptrackervalue = json['txniptrackervalue'];
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
    bankresponse = json['bankresponse'] != null
        ? new Bankresponse.fromJson(json['bankresponse'])
        : null;
    invoice =
        json['invoice'] != null ? new Invoice.fromJson(json['invoice']) : null;
    partialRefundRemainAmount = json['partialRefundRemainAmount'];
    isTechnicalRefund = json['isTechnicalRefund'];
    technicalRefundComment = json['technicalRefundComment'];
    debitRefundBankPending = json['debit_refund_bank_pending'];
    debitRefundResponsePun = json['debit_refund_response_pun'];
    debitRefundBankRequestDate = json['debit_refund_bank_request_date'];
    refundStatusUpdatedBy = json['refund_status_updated_by'];
    transactionNote = json['transaction_note'];
    // txnBankStatus = json['txn_bank_status'];
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
    guestuser = json['guestuser'] != null
        ? new Guestuser.fromJson(json['guestuser'])
        : null;
    txniptrackervalue = json['txniptrackervalue'] != null
        // ignore: unnecessary_new
        ? new Txniptrackervalue.fromJson(jsonDecode(json['txniptrackervalue']))
        : null;
    txnBankStatus = json['txn_bank_status'] != null
        ? (jsonDecode(json['txn_bank_status']) as List<dynamic>)
            .map((e) => Txn_bank_status.fromJson(e))
            .toList()
        : null;
    entityId = json['entityId'] != null
        ? new EntityId.fromJson(json['entityId'])
        : null;
    actualTxn = json['actualTxn'] != null
        ? new ActualTxn.fromJson(json['actualTxn'])
        : null;
    bankRefundResponse = json['bankRefundResponse'] != null
        ? new BankRefundResponse.fromJson(json['bankRefundResponse'])
        : null;
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
    data['cardholdername'] = this.cardholdername;
    data['cardsixdigit'] = this.cardsixdigit;
    data['bincardstatusvalue'] = this.bincardstatusvalue;
    // data['txniptrackervalue'] = this.txniptrackervalue;
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
    // data['txn_bank_status'] = this.txnBankStatus;
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
    data['modified'] = this.modified;
    data['disputeId'] = this.disputeId;
    data['transactionentityId'] = this.transactionentityId;
    data['transactionmodeId'] = this.transactionmodeId;
    data['transactionstatusId'] = this.transactionstatusId;
    data['guestuserId'] = this.guestuserId;
    data['postransactionId'] = this.postransactionId;
    data['cardschemeid'] = this.cardschemeid;
    if (this.txniptrackervalue != null) {
      data['txniptrackervalue'] = this.txniptrackervalue!.toJson();
    }
    if (this.bankresponse != null) {
      data['bankresponse'] = this.bankresponse!.toJson();
    }
    if (this.entityId != null) {
      data['entityId'] = this.entityId!.toJson();
    }
    if (this.actualTxn != null) {
      data['actualTxn'] = this.actualTxn!.toJson();
    }
    if (this.bankRefundResponse != null) {
      data['bankRefundResponse'] = this.bankRefundResponse!.toJson();
    }
    if (this.invoice != null) {
      data['invoice'] = this.invoice!.toJson();
    }
    if (this.senderId != null) {
      data['senderId'] = this.senderId!.toJson();
    }
    if (this.guestuser != null) {
      data['guestuser'] = this.guestuser!.toJson();
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
  var invoicePaymentDate;
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
      this.invoicePaymentDate,
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
    invoicePaymentDate = json['invoice_payment_date'];
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
    data['invoice_payment_date'] = this.invoicePaymentDate;
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

class Bankresponse {
  var invoicenumber;
  var responseCode;
  var explanation;
  var s3DSecureAcsEci;
  var s3DSecureAuthenticationStatus;
  var s3DSecureEnrollmentStatus;
  var responseGatewayCode;
  var responseAcquirerMessage;
  var result;
  var cardNumber;
  var rRN;
  var authNumber;

  Bankresponse(
      {this.invoicenumber,
      this.responseCode,
      this.explanation,
      this.s3DSecureAcsEci,
      this.s3DSecureAuthenticationStatus,
      this.s3DSecureEnrollmentStatus,
      this.responseGatewayCode,
      this.responseAcquirerMessage,
      this.result,
      this.cardNumber,
      this.rRN,
      this.authNumber});

  Bankresponse.fromJson(Map<String, dynamic> json) {
    invoicenumber = json['invoicenumber'];
    responseCode = json['responseCode'];
    explanation = json['explanation'];
    s3DSecureAcsEci = json['3DSecure_acsEci'];
    s3DSecureAuthenticationStatus = json['3DSecure_authenticationStatus'];
    s3DSecureEnrollmentStatus = json['3DSecure_enrollmentStatus'];
    responseGatewayCode = json['response_gatewayCode'];
    responseAcquirerMessage = json['response_acquirerMessage'];
    result = json['result'];
    cardNumber = json['cardNumber'];
    rRN = json['RRN'];
    authNumber = json['AuthNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoicenumber'] = this.invoicenumber;
    data['responseCode'] = this.responseCode;
    data['explanation'] = this.explanation;
    data['3DSecure_acsEci'] = this.s3DSecureAcsEci;
    data['3DSecure_authenticationStatus'] = this.s3DSecureAuthenticationStatus;
    data['3DSecure_enrollmentStatus'] = this.s3DSecureEnrollmentStatus;
    data['response_gatewayCode'] = this.responseGatewayCode;
    data['response_acquirerMessage'] = this.responseAcquirerMessage;
    data['result'] = this.result;
    data['cardNumber'] = this.cardNumber;
    data['RRN'] = this.rRN;
    data['AuthNumber'] = this.authNumber;
    return data;
  }
}

class EntityId {
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
  var senderId;
  var receiverId;
  var salesUserId;
  var posUserId;

  EntityId(
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
      this.posUserId});

  EntityId.fromJson(Map<String, dynamic> json) {
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
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    salesUserId = json['sales_userId'];
    posUserId = json['pos_userId'];
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
    data['modified'] = this.modified;
    data['disputeId'] = this.disputeId;
    data['transactionentityId'] = this.transactionentityId;
    data['transactionmodeId'] = this.transactionmodeId;
    data['transactionstatusId'] = this.transactionstatusId;
    data['guestuserId'] = this.guestuserId;
    data['postransactionId'] = this.postransactionId;
    data['cardschemeid'] = this.cardschemeid;
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    data['sales_userId'] = this.salesUserId;
    data['pos_userId'] = this.posUserId;
    return data;
  }
}

class ActualTxn {
  var invoicenumber;

  ActualTxn({this.invoicenumber});

  ActualTxn.fromJson(Map<String, dynamic> json) {
    invoicenumber = json['invoicenumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoicenumber'] = this.invoicenumber;
    return data;
  }
}

class BankRefundResponse {
  var invoicenumber;
  var responseCode;
  var explanation;
  var rRN;
  var result;
  var cardNumber;
  var refundId;

  BankRefundResponse(
      {this.invoicenumber,
      this.responseCode,
      this.explanation,
      this.rRN,
      this.result,
      this.cardNumber,
      this.refundId});

  BankRefundResponse.fromJson(Map<String, dynamic> json) {
    invoicenumber = json['invoicenumber'];
    responseCode = json['responseCode'];
    explanation = json['explanation'];
    rRN = json['RRN'];
    result = json['result'];
    cardNumber = json['cardNumber'];
    refundId = json['refund_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoicenumber'] = this.invoicenumber;
    data['responseCode'] = this.responseCode;
    data['explanation'] = this.explanation;
    data['RRN'] = this.rRN;
    data['result'] = this.result;
    data['cardNumber'] = this.cardNumber;
    data['refund_id'] = this.refundId;
    return data;
  }
}

class SenderId {
  var profilepic;
  var sadadId;
  var name;
  bool? agreement;
  var signature;
  var partneragreement;
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

class Txniptrackervalue {
  var ipAddress;
  var city;
  var cityGeonameId;
  var region;
  var regionIsoCode;
  var regionGeonameId;
  var postalCode;
  var country;
  var countryCode;
  var countryGeonameId;
  bool? countryIsEu;
  var continent;
  var continentCode;
  var continentGeonameId;
  var longitude;
  var latitude;
  Security? security;
  Timezone? timezone;
  Flag? flag;
  Currency? currency;
  Connection? connection;
  var countryCodeFull;
  var ip;

  Txniptrackervalue(
      {this.ipAddress,
      this.city,
      this.cityGeonameId,
      this.region,
      this.regionIsoCode,
      this.regionGeonameId,
      this.postalCode,
      this.country,
      this.countryCode,
      this.countryGeonameId,
      this.countryIsEu,
      this.continent,
      this.continentCode,
      this.continentGeonameId,
      this.longitude,
      this.latitude,
      this.security,
      this.timezone,
      this.flag,
      this.currency,
      this.connection,
      this.countryCodeFull,
      this.ip});

  Txniptrackervalue.fromJson(Map<String, dynamic> json) {
    ipAddress = json['ip_address'];
    city = json['city'];
    cityGeonameId = json['city_geoname_id'];
    region = json['region'];
    regionIsoCode = json['region_iso_code'];
    regionGeonameId = json['region_geoname_id'];
    postalCode = json['postal_code'];
    country = json['country'];
    countryCode = json['country_code'];
    countryGeonameId = json['country_geoname_id'];
    countryIsEu = json['country_is_eu'];
    continent = json['continent'];
    continentCode = json['continent_code'];
    continentGeonameId = json['continent_geoname_id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    security = json['security'] != null
        ? new Security.fromJson(json['security'])
        : null;
    timezone = json['timezone'] != null
        ? new Timezone.fromJson(json['timezone'])
        : null;
    flag = json['flag'] != null ? new Flag.fromJson(json['flag']) : null;
    currency = json['currency'] != null
        ? new Currency.fromJson(json['currency'])
        : null;
    connection = json['connection'] != null
        ? new Connection.fromJson(json['connection'])
        : null;
    countryCodeFull = json['country_code_full'];
    ip = json['ip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ip_address'] = this.ipAddress;
    data['city'] = this.city;
    data['city_geoname_id'] = this.cityGeonameId;
    data['region'] = this.region;
    data['region_iso_code'] = this.regionIsoCode;
    data['region_geoname_id'] = this.regionGeonameId;
    data['postal_code'] = this.postalCode;
    data['country'] = this.country;
    data['country_code'] = this.countryCode;
    data['country_geoname_id'] = this.countryGeonameId;
    data['country_is_eu'] = this.countryIsEu;
    data['continent'] = this.continent;
    data['continent_code'] = this.continentCode;
    data['continent_geoname_id'] = this.continentGeonameId;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    if (this.security != null) {
      data['security'] = this.security!.toJson();
    }
    if (this.timezone != null) {
      data['timezone'] = this.timezone!.toJson();
    }
    if (this.flag != null) {
      data['flag'] = this.flag!.toJson();
    }
    if (this.currency != null) {
      data['currency'] = this.currency!.toJson();
    }
    if (this.connection != null) {
      data['connection'] = this.connection!.toJson();
    }
    data['country_code_full'] = this.countryCodeFull;
    data['ip'] = this.ip;
    return data;
  }
}

class Security {
  bool? isVpn;

  Security({this.isVpn});

  Security.fromJson(Map<String, dynamic> json) {
    isVpn = json['is_vpn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_vpn'] = this.isVpn;
    return data;
  }
}

class Timezone {
  var name;
  var abbreviation;
  var gmtOffset;
  var currentTime;
  bool? isDst;

  Timezone(
      {this.name,
      this.abbreviation,
      this.gmtOffset,
      this.currentTime,
      this.isDst});

  Timezone.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    abbreviation = json['abbreviation'];
    gmtOffset = json['gmt_offset'];
    currentTime = json['current_time'];
    isDst = json['is_dst'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['abbreviation'] = this.abbreviation;
    data['gmt_offset'] = this.gmtOffset;
    data['current_time'] = this.currentTime;
    data['is_dst'] = this.isDst;
    return data;
  }
}

class Flag {
  var emoji;
  var unicode;
  var png;
  var svg;

  Flag({this.emoji, this.unicode, this.png, this.svg});

  Flag.fromJson(Map<String, dynamic> json) {
    emoji = json['emoji'];
    unicode = json['unicode'];
    png = json['png'];
    svg = json['svg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emoji'] = this.emoji;
    data['unicode'] = this.unicode;
    data['png'] = this.png;
    data['svg'] = this.svg;
    return data;
  }
}

class Currency {
  var currencyName;
  var currencyCode;

  Currency({this.currencyName, this.currencyCode});

  Currency.fromJson(Map<String, dynamic> json) {
    currencyName = json['currency_name'];
    currencyCode = json['currency_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency_name'] = this.currencyName;
    data['currency_code'] = this.currencyCode;
    return data;
  }
}

class Connection {
  var autonomousSystemNumber;
  var autonomousSystemOrganization;
  var connectionType;
  var ispName;
  var organizationName;

  Connection(
      {this.autonomousSystemNumber,
      this.autonomousSystemOrganization,
      this.connectionType,
      this.ispName,
      this.organizationName});

  Connection.fromJson(Map<String, dynamic> json) {
    autonomousSystemNumber = json['autonomous_system_number'];
    autonomousSystemOrganization = json['autonomous_system_organization'];
    connectionType = json['connection_type'];
    ispName = json['isp_name'];
    organizationName = json['organization_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['autonomous_system_number'] = this.autonomousSystemNumber;
    data['autonomous_system_organization'] = this.autonomousSystemOrganization;
    data['connection_type'] = this.connectionType;
    data['isp_name'] = this.ispName;
    data['organization_name'] = this.organizationName;
    return data;
  }
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

class Guestuser {
  var cellnumber;
  var actualCellnumber;
  var email;
  var transactionno;
  var quantity;
  var expiryTime;
  var otp;
  var token;
  var ttl;
  var id;
  var created;
  var modified;

  Guestuser(
      {this.cellnumber,
      this.actualCellnumber,
      this.email,
      this.transactionno,
      this.quantity,
      this.expiryTime,
      this.otp,
      this.token,
      this.ttl,
      this.id,
      this.created,
      this.modified});

  Guestuser.fromJson(Map<String, dynamic> json) {
    cellnumber = json['cellnumber'];
    actualCellnumber = json['actual_cellnumber'];
    email = json['email'];
    transactionno = json['transactionno'];
    quantity = json['quantity'];
    expiryTime = json['expiryTime'];
    otp = json['otp'];
    token = json['token'];
    ttl = json['ttl'];
    id = json['id'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cellnumber'] = this.cellnumber;
    data['actual_cellnumber'] = this.actualCellnumber;
    data['email'] = this.email;
    data['transactionno'] = this.transactionno;
    data['quantity'] = this.quantity;
    data['expiryTime'] = this.expiryTime;
    data['otp'] = this.otp;
    data['token'] = this.token;
    data['ttl'] = this.ttl;
    data['id'] = this.id;
    data['created'] = this.created;
    data['modified'] = this.modified;
    return data;
  }
}
