class OrderListResponseModel {
  var quantity;
  var expecteddelivery;
  var isArchived;
  var createdby;
  var modifiedby;
  var orderstatusId;
  var amount;
  var orderno;
  var deliverydate;
  var cellnumber;
  var productdetails;
  var salesUserId;
  var shareUrl;
  var id;
  var date;
  var productId;
  var deletedAt;
  var created;
  var modified;
  var transactionId;
  var invoiceId;
  CustomerId? customerId;
  var vendorId;
  Transaction? transaction;
  Orderstatus? orderstatus;
  Product? product;

  OrderListResponseModel(
      {this.quantity,
      this.expecteddelivery,
      this.isArchived,
      this.createdby,
      this.modifiedby,
      this.orderstatusId,
      this.amount,
      this.orderno,
      this.deliverydate,
      this.cellnumber,
      this.productdetails,
      this.salesUserId,
      this.shareUrl,
      this.id,
      this.date,
      this.productId,
      this.deletedAt,
      this.created,
      this.modified,
      this.transactionId,
      this.invoiceId,
      this.customerId,
      this.vendorId,
      this.transaction,
      this.orderstatus,
      this.product});

  OrderListResponseModel.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    expecteddelivery = json['expecteddelivery'];
    isArchived = json['is_archived'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    orderstatusId = json['orderstatusId'];
    amount = json['amount'];
    orderno = json['orderno'];
    deliverydate = json['deliverydate'];
    cellnumber = json['cellnumber'];
    productdetails = json['productdetails'];
    salesUserId = json['sales_userId'];
    shareUrl = json['shareUrl'];
    id = json['id'];
    date = json['date'];
    productId = json['productId'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    modified = json['modified'];
    transactionId = json['transactionId'];
    invoiceId = json['invoiceId'];
    // customerId = json['customerId'] != null
    //     ? (json['customerId'] is int)
    //         ? null
    //         : new CustomerId.fromJson(json['customerId'])
    //     : null;
    vendorId = json['vendorId'];
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
    orderstatus = json['orderstatus'] != null
        ? new Orderstatus.fromJson(json['orderstatus'])
        : null;
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['expecteddelivery'] = this.expecteddelivery;
    data['is_archived'] = this.isArchived;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['orderstatusId'] = this.orderstatusId;
    data['amount'] = this.amount;
    data['orderno'] = this.orderno;
    data['deliverydate'] = this.deliverydate;
    data['cellnumber'] = this.cellnumber;
    data['productdetails'] = this.productdetails;
    data['sales_userId'] = this.salesUserId;
    data['shareUrl'] = this.shareUrl;
    data['id'] = this.id;
    data['date'] = this.date;
    data['productId'] = this.productId;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['transactionId'] = this.transactionId;
    data['invoiceId'] = this.invoiceId;
    if (this.customerId != null) {
      data['customerId'] = this.customerId!.toJson();
    }
    data['vendorId'] = this.vendorId;
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    if (this.orderstatus != null) {
      data['orderstatus'] = this.orderstatus!.toJson();
    }
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class CustomerId {
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

  CustomerId(
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

  CustomerId.fromJson(Map<String, dynamic> json) {
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

class Transaction {
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

  Transaction(
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

  Transaction.fromJson(Map<String, dynamic> json) {
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

class Orderstatus {
  var name;
  var createdby;
  var modifiedby;
  var id;

  Orderstatus({this.name, this.createdby, this.modifiedby, this.id});

  Orderstatus.fromJson(Map<String, dynamic> json) {
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

class Product {
  var name;
  var description;
  var arabicName;
  var arabicDescription;
  var totalavailablequantity;
  bool? enablewatermark;
  var price;
  var viewcount;
  var salescount;
  var allowoncepersadadaccount;
  var expecteddays;
  var showproduct;
  var createdby;
  var modifiedby;
  var transactionFees;
  var netamount;
  bool? isUnlimited;
  var prodId;
  var shareUrl;
  var recurringFreq;
  var isdisplayinpanel;
  var isRecurringProduct;
  var isShippingAddressRequired;
  var recurringCycleLimit;
  var nextCycleCharge;
  var id;
  var date;
  var productNumber;
  var merchantId;
  var deletedAt;
  var created;
  var modified;
  var viewproductipId;
  List<Productmedia>? productmedia;

  Product(
      {this.name,
      this.description,
      this.arabicName,
      this.arabicDescription,
      this.totalavailablequantity,
      this.enablewatermark,
      this.price,
      this.viewcount,
      this.salescount,
      this.allowoncepersadadaccount,
      this.expecteddays,
      this.showproduct,
      this.createdby,
      this.modifiedby,
      this.transactionFees,
      this.netamount,
      this.isUnlimited,
      this.prodId,
      this.shareUrl,
      this.recurringFreq,
      this.isdisplayinpanel,
      this.isRecurringProduct,
      this.isShippingAddressRequired,
      this.recurringCycleLimit,
      this.nextCycleCharge,
      this.id,
      this.date,
      this.productNumber,
      this.merchantId,
      this.deletedAt,
      this.created,
      this.modified,
      this.viewproductipId,
      this.productmedia});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    arabicName = json['arabicName'];
    arabicDescription = json['arabicDescription'];
    totalavailablequantity = json['totalavailablequantity'];
    enablewatermark = json['enablewatermark'];
    price = json['price'];
    viewcount = json['viewcount'];
    salescount = json['salescount'];
    allowoncepersadadaccount = json['allowoncepersadadaccount'];
    expecteddays = json['expecteddays'];
    showproduct = json['showproduct'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    transactionFees = json['transactionFees'];
    netamount = json['netamount'];
    isUnlimited = json['isUnlimited'];
    prodId = json['prodId'];
    shareUrl = json['shareUrl'];
    recurringFreq = json['recurring_freq'];
    isdisplayinpanel = json['isdisplayinpanel'];
    isRecurringProduct = json['isRecurringProduct'];
    isShippingAddressRequired = json['isShippingAddressRequired'];
    recurringCycleLimit = json['recurringCycleLimit'];
    nextCycleCharge = json['nextCycleCharge'];
    id = json['id'];
    date = json['date'];
    productNumber = json['productNumber'];
    merchantId = json['merchantId'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    modified = json['modified'];
    viewproductipId = json['viewproductipId'];
    if (json['productmedia'] != null) {
      productmedia = <Productmedia>[];
      json['productmedia'].forEach((v) {
        productmedia!.add(new Productmedia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['arabicName'] = this.arabicName;
    data['arabicDescription'] = this.arabicDescription;
    data['totalavailablequantity'] = this.totalavailablequantity;
    data['enablewatermark'] = this.enablewatermark;
    data['price'] = this.price;
    data['viewcount'] = this.viewcount;
    data['salescount'] = this.salescount;
    data['allowoncepersadadaccount'] = this.allowoncepersadadaccount;
    data['expecteddays'] = this.expecteddays;
    data['showproduct'] = this.showproduct;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['transactionFees'] = this.transactionFees;
    data['netamount'] = this.netamount;
    data['isUnlimited'] = this.isUnlimited;
    data['prodId'] = this.prodId;
    data['shareUrl'] = this.shareUrl;
    data['recurring_freq'] = this.recurringFreq;
    data['isdisplayinpanel'] = this.isdisplayinpanel;
    data['isRecurringProduct'] = this.isRecurringProduct;
    data['isShippingAddressRequired'] = this.isShippingAddressRequired;
    data['recurringCycleLimit'] = this.recurringCycleLimit;
    data['nextCycleCharge'] = this.nextCycleCharge;
    data['id'] = this.id;
    data['date'] = this.date;
    data['productNumber'] = this.productNumber;
    data['merchantId'] = this.merchantId;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['viewproductipId'] = this.viewproductipId;
    if (this.productmedia != null) {
      data['productmedia'] = this.productmedia!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Productmedia {
  var name;
  var version;
  var createdby;
  var modifiedby;
  var watermarkimg;
  var id;
  var productId;

  Productmedia(
      {this.name,
      this.version,
      this.createdby,
      this.modifiedby,
      this.watermarkimg,
      this.id,
      this.productId});

  Productmedia.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    version = json['version'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    watermarkimg = json['watermarkimg'];
    id = json['id'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['version'] = this.version;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['watermarkimg'] = this.watermarkimg;
    data['id'] = this.id;
    data['productId'] = this.productId;
    return data;
  }
}
