// To parse this JSON data, do
//
//     final orderDetailResponseModel = orderDetailResponseModelFromJson(jsonString);

import 'dart:convert';

OrderDetailResponseModel orderDetailResponseModelFromJson(String str) =>
    OrderDetailResponseModel.fromJson(json.decode(str));

String orderDetailResponseModelToJson(OrderDetailResponseModel data) =>
    json.encode(data.toJson());

class OrderDetailResponseModel {
  OrderDetailResponseModel({
    this.quantity,
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
    this.product,
  });

  var quantity;
  var expecteddelivery;
  bool? isArchived;
  var createdby;
  var modifiedby;
  var orderstatusId;
  var amount;
  var orderno;
  dynamic deliverydate;
  dynamic cellnumber;
  var productdetails;
  dynamic salesUserId;
  var shareUrl;
  var id;
  DateTime? date;
  var productId;
  dynamic deletedAt;
  DateTime? created;
  DateTime? modified;
  var transactionId;
  dynamic invoiceId;
  CustomerId? customerId;
  var vendorId;
  Transaction? transaction;
  Orderstatus? orderstatus;
  Product? product;

  factory OrderDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailResponseModel(
        quantity: json["quantity"],
        expecteddelivery: json["expecteddelivery"],
        isArchived: json["is_archived"],
        createdby: json["createdby"],
        modifiedby: json["modifiedby"],
        orderstatusId: json["orderstatusId"],
        amount: json["amount"],
        orderno: json["orderno"],
        deliverydate: json["deliverydate"],
        cellnumber: json["cellnumber"],
        productdetails: json["productdetails"],
        salesUserId: json["sales_userId"],
        shareUrl: json["shareUrl"],
        id: json["id"],
        date: DateTime.parse(json["date"]),
        productId: json["productId"],
        deletedAt: json["deletedAt"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        transactionId: json["transactionId"],
        invoiceId: json["invoiceId"],
        customerId: json["customerId"] is int
            ? null
            : CustomerId.fromJson(json["customerId"]),
        vendorId: json["vendorId"],
        transaction: Transaction.fromJson(json["transaction"]),
        orderstatus: Orderstatus.fromJson(json["orderstatus"]),
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "expecteddelivery": expecteddelivery,
        "is_archived": isArchived,
        "createdby": createdby,
        "modifiedby": modifiedby,
        "orderstatusId": orderstatusId,
        "amount": amount,
        "orderno": orderno,
        "deliverydate": deliverydate,
        "cellnumber": cellnumber,
        "productdetails": productdetails,
        "sales_userId": salesUserId,
        "shareUrl": shareUrl,
        "id": id,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "productId": productId,
        "deletedAt": deletedAt,
        "created": created!.toIso8601String(),
        "modified": modified!.toIso8601String(),
        "transactionId": transactionId,
        "invoiceId": invoiceId,
        "customerId": customerId!.toJson(),
        "vendorId": vendorId,
        "transaction": transaction!.toJson(),
        "orderstatus": orderstatus!.toJson(),
        "product": product!.toJson(),
      };
}

class CustomerId {
  CustomerId({
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
  var agreement;
  var signature;
  bool? partneragreement;
  dynamic partnersignature;
  bool? cellVerified;
  dynamic createdBy;
  dynamic modifiedBy;
  dynamic rememberToken;
  dynamic tokenExpiry;
  dynamic passwordExpiry;
  dynamic type;
  dynamic whmcsClientId;
  dynamic username;
  bool? isPartnerUser;
  dynamic partnerUserId;
  dynamic addedUnderPartnerDate;
  dynamic addedUnderPartnerHistory;
  dynamic sadadPartnerId;
  dynamic sadadPartnerIdGeneratedDate;
  dynamic partnerDataUpdatedAt;
  var businessPhoneNumber;
  var isAgreedWithAutoWithdrawalTc;
  dynamic realm;
  var cellnumber;
  var email;
  dynamic emailVerified;
  var id;
  dynamic deletedAt;
  DateTime? created;
  DateTime? modified;
  var roleId;

  factory CustomerId.fromJson(Map<String, dynamic> json) => CustomerId(
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
        "created": created!.toIso8601String(),
        "modified": modified!.toIso8601String(),
        "roleId": roleId,
      };
}

class Orderstatus {
  Orderstatus({
    this.name,
    this.createdby,
    this.modifiedby,
    this.id,
  });

  var name;
  dynamic createdby;
  dynamic modifiedby;
  var id;

  factory Orderstatus.fromJson(Map<String, dynamic> json) => Orderstatus(
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

class Product {
  Product({
    this.name,
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
    this.productmedia,
  });

  var name;
  var description;
  dynamic arabicName;
  dynamic arabicDescription;
  var totalavailablequantity;
  bool? enablewatermark;
  var price;
  var viewcount;
  var salescount;
  bool? allowoncepersadadaccount;
  var expecteddays;
  bool? showproduct;
  var createdby;
  var modifiedby;
  var transactionFees;
  var netamount;
  bool? isUnlimited;
  var prodId;
  var shareUrl;
  var recurringFreq;
  var isdisplayinpanel;
  bool? isRecurringProduct;
  var isShippingAddressRequired;
  dynamic recurringCycleLimit;
  var nextCycleCharge;
  var id;
  DateTime? date;
  var productNumber;
  var merchantId;
  dynamic deletedAt;
  DateTime? created;
  DateTime? modified;
  dynamic viewproductipId;
  List<Productmedia>? productmedia;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
        description: json["description"],
        arabicName: json["arabicName"],
        arabicDescription: json["arabicDescription"],
        totalavailablequantity: json["totalavailablequantity"],
        enablewatermark: json["enablewatermark"],
        price: json["price"],
        viewcount: json["viewcount"],
        salescount: json["salescount"],
        allowoncepersadadaccount: json["allowoncepersadadaccount"],
        expecteddays: json["expecteddays"],
        showproduct: json["showproduct"],
        createdby: json["createdby"],
        modifiedby: json["modifiedby"],
        transactionFees: json["transactionFees"],
        netamount: json["netamount"],
        isUnlimited: json["isUnlimited"],
        prodId: json["prodId"],
        shareUrl: json["shareUrl"],
        recurringFreq: json["recurring_freq"],
        isdisplayinpanel: json["isdisplayinpanel"],
        isRecurringProduct: json["isRecurringProduct"],
        isShippingAddressRequired: json["isShippingAddressRequired"],
        recurringCycleLimit: json["recurringCycleLimit"],
        nextCycleCharge: json["nextCycleCharge"],
        id: json["id"],
        date: DateTime.parse(json["date"]),
        productNumber: json["productNumber"],
        merchantId: json["merchantId"],
        deletedAt: json["deletedAt"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        viewproductipId: json["viewproductipId"],
        productmedia: List<Productmedia>.from(
            json["productmedia"].map((x) => Productmedia.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "arabicName": arabicName,
        "arabicDescription": arabicDescription,
        "totalavailablequantity": totalavailablequantity,
        "enablewatermark": enablewatermark,
        "price": price,
        "viewcount": viewcount,
        "salescount": salescount,
        "allowoncepersadadaccount": allowoncepersadadaccount,
        "expecteddays": expecteddays,
        "showproduct": showproduct,
        "createdby": createdby,
        "modifiedby": modifiedby,
        "transactionFees": transactionFees,
        "netamount": netamount,
        "isUnlimited": isUnlimited,
        "prodId": prodId,
        "shareUrl": shareUrl,
        "recurring_freq": recurringFreq,
        "isdisplayinpanel": isdisplayinpanel,
        "isRecurringProduct": isRecurringProduct,
        "isShippingAddressRequired": isShippingAddressRequired,
        "recurringCycleLimit": recurringCycleLimit,
        "nextCycleCharge": nextCycleCharge,
        "id": id,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "productNumber": productNumber,
        "merchantId": merchantId,
        "deletedAt": deletedAt,
        "created": created!.toIso8601String(),
        "modified": modified!.toIso8601String(),
        "viewproductipId": viewproductipId,
        "productmedia":
            List<dynamic>.from(productmedia!.map((x) => x.toJson())),
      };
}

class Productmedia {
  Productmedia({
    this.name,
    this.version,
    this.createdby,
    this.modifiedby,
    this.watermarkimg,
    this.id,
    this.productId,
  });

  var name;
  dynamic version;
  var createdby;
  dynamic modifiedby;
  dynamic watermarkimg;
  var id;
  var productId;

  factory Productmedia.fromJson(Map<String, dynamic> json) => Productmedia(
        name: json["name"],
        version: json["version"],
        createdby: json["createdby"],
        modifiedby: json["modifiedby"],
        watermarkimg: json["watermarkimg"],
        id: json["id"],
        productId: json["productId"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "version": version,
        "createdby": createdby,
        "modifiedby": modifiedby,
        "watermarkimg": watermarkimg,
        "id": id,
        "productId": productId,
      };
}

class Transaction {
  Transaction({
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

  var entityid;
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
  var createdby;
  var modifiedby;
  var cardnumber;
  dynamic fundsprocessed;
  var servicecharge;
  var servicechargedescription;
  var audittype;
  dynamic auditcomment;
  dynamic websiteRefNo;
  var transactionSummary;
  var txnip;
  var cardholdername;
  var cardsixdigit;
  var bincardstatusvalue;
  var txniptrackervalue;
  var inprocess;
  var verified;
  var updatetxnby;
  dynamic refundTicketNotes;
  var isSuspicious;
  dynamic suspiciousNote;
  bool? isFraud;
  var osHistory;
  var creditcardpaymentmodeid;
  dynamic debitcardpaymentmodeid;
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
  DateTime? transactiondate;
  dynamic deletedAt;
  DateTime? created;
  DateTime? modified;
  dynamic disputeId;
  var transactionentityId;
  var transactionmodeId;
  var transactionstatusId;
  dynamic guestuserId;
  dynamic postransactionId;
  var cardschemeid;
  var senderId;
  var receiverId;
  dynamic salesUserId;
  dynamic posUserId;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
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
        servicecharge: json["servicecharge"].toDouble(),
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
            "${transactiondate!.year.toString().padLeft(4, '0')}-${transactiondate!.month.toString().padLeft(2, '0')}-${transactiondate!.day.toString().padLeft(2, '0')}",
        "deletedAt": deletedAt,
        "created": created!.toIso8601String(),
        "modified": modified!.toIso8601String(),
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
