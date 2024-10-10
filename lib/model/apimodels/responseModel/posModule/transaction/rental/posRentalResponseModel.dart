// To parse this JSON data, do
//
//     final posRentalResponseModel = posRentalResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

PosRentalResponseModel posRentalResponseModelFromJson(String str) =>
    PosRentalResponseModel.fromJson(json.decode(str));

String posRentalResponseModelToJson(PosRentalResponseModel data) =>
    json.encode(data.toJson());

class PosRentalResponseModel {
  PosRentalResponseModel({
    this.totalinvoices,
    this.invoices,
  });

  var totalinvoices;
  List<PosInvoice>? invoices = [];

  factory PosRentalResponseModel.fromJson(Map<String, dynamic> json) =>
      PosRentalResponseModel(
        totalinvoices: json["totalinvoices"],
        invoices: List<PosInvoice>.from(
            json["invoices"].map((x) => PosInvoice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalinvoices": totalinvoices,
        "invoices": List<dynamic>.from(invoices!.map((x) => x.toJson())),
      };
}

class PosInvoice {
  PosInvoice({
    this.invoiceno,
    this.clientname,
    this.cellno,
    this.emailaddress,
    this.remarks,
    this.grossamount,
    this.transactionfees,
    this.netamount,
    this.modifiedby,
    this.paymentduedate,
    this.shareUrl,
    this.subsinvoiceId,
    this.isrentalplaninvoice,
    this.invoiceSummery,
    this.id,
    this.date,
    this.createdby,
    this.deletedAt,
    this.created,
    this.invoicestatusId,
    this.transaction,
    this.invoicereceiverId,
    this.invoicesenderId,
    this.invoicestatus,
    this.recurringposrentals,
  });

  var invoiceno;
  var clientname;
  var cellno;
  var emailaddress;
  var remarks;
  var grossamount;
  var transactionfees;
  var netamount;
  var modifiedby;
  var paymentduedate;
  var shareUrl;
  var subsinvoiceId;
  bool? isrentalplaninvoice;
  var invoiceSummery;
  var id;
  var date;
  var createdby;
  dynamic deletedAt;
  var created;
  var invoicestatusId;
  Transaction? transaction;
  InvoiceerId? invoicereceiverId;
  InvoiceerId? invoicesenderId;
  Invoicestatus? invoicestatus;
  List<dynamic>? recurringposrentals;

  factory PosInvoice.fromJson(Map<String, dynamic> json) => PosInvoice(
        invoiceno: json["invoiceno"],
        clientname: json["clientname"],
        cellno: json["cellno"],
        emailaddress: json["emailaddress"],
        remarks: json["remarks"],
        grossamount: json["grossamount"],
        transactionfees: json["transactionfees"],
        netamount: json["netamount"],
        modifiedby: json["modifiedby"],
        paymentduedate: json["paymentduedate"],
        shareUrl: json["shareUrl"],
        subsinvoiceId: json["subsinvoiceId"],
        isrentalplaninvoice: json["isrentalplaninvoice"],
        invoiceSummery: json["invoice_summery"],
        id: json["id"],
        date: DateTime.parse(json["date"]),
        createdby: json["createdby"],
        deletedAt: json["deletedAt"],
        created: DateTime.parse(json["created"]),
        invoicestatusId: json["invoicestatusId"],
        transaction: json["transaction"] == null
            ? null
            : Transaction.fromJson(json["transaction"]),
        invoicereceiverId: json["invoicereceiverId"] == null
            ? null
            : InvoiceerId.fromJson(json["invoicereceiverId"]),
        invoicesenderId: json["invoicesenderId"] == null
            ? null
            : InvoiceerId.fromJson(json["invoicesenderId"]),
        invoicestatus: json["invoicestatus"] == null
            ? null
            : Invoicestatus.fromJson(json["invoicestatus"]),
        recurringposrentals: json["recurringposrentals"] == null
            ? []
            : List<dynamic>.from(json["recurringposrentals"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "invoiceno": invoiceno,
        "clientname": clientname,
        "cellno": cellno,
        "emailaddress": emailaddress,
        "remarks": remarks,
        "grossamount": grossamount,
        "transactionfees": transactionfees,
        "netamount": netamount,
        "modifiedby": modifiedby,
        "paymentduedate": paymentduedate,
        "shareUrl": shareUrl,
        "subsinvoiceId": subsinvoiceId,
        "isrentalplaninvoice": isrentalplaninvoice,
        "invoice_summery": invoiceSummery,
        "id": id,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "createdby": createdby,
        "deletedAt": deletedAt,
        "created": created!.toIso8601String(),
        "invoicestatusId": invoicestatusId,
        "transaction": transaction!.toJson(),
        "invoicereceiverId": invoicereceiverId!.toJson(),
        "invoicesenderId": invoicesenderId!.toJson(),
        "invoicestatus": invoicestatus!.toJson(),
        "recurringposrentals":
            List<dynamic>.from(recurringposrentals!.map((x) => x)),
      };
}

class InvoiceerId {
  InvoiceerId({
    this.sadadId,
    this.name,
    this.type,
    this.cellnumber,
    this.email,
    this.id,
    this.created,
    this.roleId,
  });

  var sadadId;
  var name;
  var type;
  var cellnumber;
  var email;
  var id;
  var created;
  var roleId;

  factory InvoiceerId.fromJson(Map<String, dynamic> json) => InvoiceerId(
        sadadId: json["SadadId"],
        name: json["name"],
        type: json["type"],
        cellnumber: json["cellnumber"],
        email: json["email"],
        id: json["id"],
        created: DateTime.parse(json["created"]),
        roleId: json["roleId"],
      );

  Map<String, dynamic> toJson() => {
        "SadadId": sadadId,
        "name": name,
        "type": type,
        "cellnumber": cellnumber,
        "email": email,
        "id": id,
        "created": created.toIso8601String(),
        "roleId": roleId,
      };
}

class Invoicestatus {
  Invoicestatus({
    this.name,
    this.id,
  });

  var name;
  var id;

  factory Invoicestatus.fromJson(Map<String, dynamic> json) => Invoicestatus(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}

class Transaction {
  Transaction({
    this.entityid,
    this.invoicenumber,
    this.amount,
    this.servicecharge,
    this.servicechargedescription,
    this.audittype,
    this.auditcomment,
    this.transactionSummary,
    this.cardholdername,
    this.cardsixdigit,
    this.bincardstatusvalue,
    this.txniptrackervalue,
    this.osHistory,
    this.creditcardpaymentmodeid,
    this.refundcharge,
    this.refundchargedescription,
    this.id,
    this.transactiondate,
    this.created,
    this.modified,
    this.transactionentityId,
    this.transactionmodeId,
    this.transactionstatusId,
    this.guestuserId,
    this.senderId,
    this.receiverId,
    this.transactionstatus,
    this.transactionmode,
    this.transactionentity,
  });

  var entityid;
  var invoicenumber;
  var amount;
  var servicecharge;
  var servicechargedescription;
  var audittype;
  var auditcomment;
  var transactionSummary;
  var cardholdername;
  var cardsixdigit;
  var bincardstatusvalue;
  var txniptrackervalue;
  var osHistory;
  var creditcardpaymentmodeid;
  var refundcharge;
  var refundchargedescription;
  var id;
  var transactiondate;
  var created;
  var modified;
  var transactionentityId;
  var transactionmodeId;
  var transactionstatusId;
  var guestuserId;
  var senderId;
  var receiverId;
  Invoicestatus? transactionstatus;
  Invoicestatus? transactionmode;
  Invoicestatus? transactionentity;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        entityid: json["entityid"],
        invoicenumber: json["invoicenumber"],
        amount: json["amount"],
        servicecharge: json["servicecharge"],
        servicechargedescription: json["servicechargedescription"],
        audittype: json["audittype"],
        auditcomment: json["auditcomment"],
        transactionSummary: json["transaction_summary"] == null
            ? null
            : json["transaction_summary"],
        cardholdername:
            json["cardholdername"] == null ? null : json["cardholdername"],
        cardsixdigit:
            json["cardsixdigit"] == null ? null : json["cardsixdigit"],
        bincardstatusvalue: json["bincardstatusvalue"] == null
            ? null
            : json["bincardstatusvalue"],
        txniptrackervalue: json["txniptrackervalue"],
        osHistory: json["os_history"],
        creditcardpaymentmodeid: json["creditcardpaymentmodeid"] == null
            ? null
            : json["creditcardpaymentmodeid"],
        refundcharge: json["refundcharge"],
        refundchargedescription: json["refundchargedescription"],
        id: json["id"],
        transactiondate: DateTime.parse(json["transactiondate"]),
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        transactionentityId: json["transactionentityId"],
        transactionmodeId: json["transactionmodeId"],
        transactionstatusId: json["transactionstatusId"],
        guestuserId: json["guestuserId"] == null ? null : json["guestuserId"],
        senderId: json["senderId"] == null ? null : json["senderId"],
        receiverId: json["receiverId"] == null ? null : json["receiverId"],
        transactionstatus: Invoicestatus.fromJson(json["transactionstatus"]),
        transactionmode: Invoicestatus.fromJson(json["transactionmode"]),
        transactionentity: Invoicestatus.fromJson(json["transactionentity"]),
      );

  Map<String, dynamic> toJson() => {
        "entityid": entityid,
        "invoicenumber": invoicenumber,
        "amount": amount,
        "servicecharge": servicecharge,
        "servicechargedescription": servicechargedescription,
        "audittype": audittype,
        "auditcomment": auditcomment,
        "transaction_summary":
            transactionSummary == null ? null : transactionSummary,
        "cardholdername": cardholdername == null ? null : cardholdername,
        "cardsixdigit": cardsixdigit == null ? null : cardsixdigit,
        "bincardstatusvalue":
            bincardstatusvalue == null ? null : bincardstatusvalue,
        "txniptrackervalue": txniptrackervalue,
        "os_history": osHistory,
        "creditcardpaymentmodeid":
            creditcardpaymentmodeid == null ? null : creditcardpaymentmodeid,
        "refundcharge": refundcharge,
        "refundchargedescription": refundchargedescription,
        "id": id,
        "transactiondate":
            "${transactiondate.year.toString().padLeft(4, '0')}-${transactiondate.month.toString().padLeft(2, '0')}-${transactiondate.day.toString().padLeft(2, '0')}",
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
        "transactionentityId": transactionentityId,
        "transactionmodeId": transactionmodeId,
        "transactionstatusId": transactionstatusId,
        "guestuserId": guestuserId == null ? null : guestuserId,
        "senderId": senderId,
        "receiverId": receiverId,
        "transactionstatus": transactionstatus!.toJson(),
        "transactionmode": transactionmode!.toJson(),
        "transactionentity": transactionentity!.toJson(),
      };
}
