// To parse this JSON data, do
//
//     final createInvoiceResponseModel = createInvoiceResponseModelFromJson(jsonString);

import 'dart:convert';

CreateInvoiceResponseModel createInvoiceResponseModelFromJson(String str) =>
    CreateInvoiceResponseModel.fromJson(json.decode(str));

String createInvoiceResponseModelToJson(CreateInvoiceResponseModel data) =>
    json.encode(data.toJson());

class CreateInvoiceResponseModel {
  CreateInvoiceResponseModel({
    this.invoiceno,
    this.clientname,
    this.cellno,
    this.remarksenabled,
    this.remarks,
    this.grossamount,
    this.transactionfees,
    this.netamount,
    this.readreceipt,
    this.modifiedby,
    this.isArchived,
    this.internationalAllow,
    this.paymentduedate,
    this.shareUrl,
    this.recurringFreq,
    this.subsinvoiceId,
    this.sourceofinvoice,
    this.isrentalplaninvoice,
    this.withDetails,
    this.id,
    this.date,
    this.createdby,
    this.deletedAt,
    this.created,
    this.sentviaId,
    this.invoicestatusId,
    this.invoicesenderId,
    this.invoicereceiverId,
  });

  var invoiceno;
  var clientname;
  var cellno;
  bool? remarksenabled;
  var remarks;
  var grossamount;
  var transactionfees;
  var netamount;
  var readreceipt;
  var modifiedby;
  var isArchived;
  bool? internationalAllow;
  DateTime? paymentduedate;
  var shareUrl;
  var recurringFreq;
  var subsinvoiceId;
  var sourceofinvoice;
  bool? isrentalplaninvoice;
  bool? withDetails;
  var id;
  DateTime? date;
  var createdby;
  dynamic deletedAt;
  DateTime? created;
  var sentviaId;
  var invoicestatusId;
  var invoicesenderId;
  var invoicereceiverId;

  factory CreateInvoiceResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateInvoiceResponseModel(
        invoiceno: json["invoiceno"],
        clientname: json["clientname"],
        cellno: json["cellno"],
        remarksenabled: json["remarksenabled"],
        remarks: json["remarks"],
        grossamount: json["grossamount"],
        transactionfees: json["transactionfees"],
        netamount: json["netamount"],
        readreceipt: json["readreceipt"],
        modifiedby: json["modifiedby"],
        isArchived: json["is_archived"],
        internationalAllow: json["internationalAllow"],
        paymentduedate: DateTime.parse(json["paymentduedate"]),
        shareUrl: json["shareUrl"],
        recurringFreq: json["recurring_freq"],
        subsinvoiceId: json["subsinvoiceId"],
        sourceofinvoice: json["sourceofinvoice"],
        isrentalplaninvoice: json["isrentalplaninvoice"],
        withDetails: json["withDetails"],
        id: json["id"],
        date: DateTime.parse(json["date"]),
        createdby: json["createdby"],
        deletedAt: json["deletedAt"],
        created: DateTime.parse(json["created"]),
        sentviaId: json["sentviaId"],
        invoicestatusId: json["invoicestatusId"],
        invoicesenderId: json["invoicesenderId"],
        invoicereceiverId: json["invoicereceiverId"],
      );

  Map<String, dynamic> toJson() => {
        "invoiceno": invoiceno,
        "clientname": clientname,
        "cellno": cellno,
        "remarksenabled": remarksenabled,
        "remarks": remarks,
        "grossamount": grossamount,
        "transactionfees": transactionfees,
        "netamount": netamount,
        "readreceipt": readreceipt,
        "modifiedby": modifiedby,
        "is_archived": isArchived,
        "internationalAllow": internationalAllow,
        "paymentduedate": paymentduedate!.toIso8601String(),
        "shareUrl": shareUrl,
        "recurring_freq": recurringFreq,
        "subsinvoiceId": subsinvoiceId,
        "sourceofinvoice": sourceofinvoice,
        "isrentalplaninvoice": isrentalplaninvoice,
        "withDetails": withDetails,
        "id": id,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "createdby": createdby,
        "deletedAt": deletedAt,
        "created": created!.toIso8601String(),
        "sentviaId": sentviaId,
        "invoicestatusId": invoicestatusId,
        "invoicesenderId": invoicesenderId,
        "invoicereceiverId": invoicereceiverId,
      };
}
