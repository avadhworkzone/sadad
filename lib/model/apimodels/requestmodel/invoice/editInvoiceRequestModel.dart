class EditInvoiceRequestModel {
  String? clientname;
  String? cellno;
  String? remarks;
  String? grossamount;
  bool? readreceipt;
  String? paymentduedate;
  String? createdby;
 var invoicestatusId;
  String? invoicesenderId;
  bool? remarksenabled;
  List<EditInvoicedetails>? invoicedetails;

  EditInvoiceRequestModel(
      {this.clientname,
      this.cellno,
      this.remarks,
      this.grossamount,
      this.readreceipt,
      this.paymentduedate,
      this.createdby,
      this.invoicestatusId,
      this.invoicesenderId,
      this.remarksenabled,
      this.invoicedetails});

  EditInvoiceRequestModel.fromJson(Map<String, dynamic> json) {
    clientname = json['clientname'];
    cellno = json['cellno'];
    remarks = json['remarks'];
    grossamount = json['grossamount'];
    readreceipt = json['readreceipt'];
    remarksenabled = json['remarksenabled'];
    paymentduedate = json['paymentduedate'];
    createdby = json['createdby'];
    invoicestatusId = json['invoicestatusId'];
    invoicesenderId = json['invoicesenderId'];
    if (json['invoicedetails'] != null) {
      invoicedetails = <EditInvoicedetails>[];
      json['invoicedetails'].forEach((v) {
        invoicedetails!.add(new EditInvoicedetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientname'] = this.clientname;
    data['cellno'] = this.cellno;
    data['remarks'] = this.remarks;
    data['grossamount'] = this.grossamount;
    data['readreceipt'] = this.readreceipt;
    data['remarksenabled'] = this.remarksenabled;
    data['paymentduedate'] = this.paymentduedate;
    data['createdby'] = this.createdby;
    data['invoicestatusId'] = this.invoicestatusId;
    data['invoicesenderId'] = this.invoicesenderId;
    if (this.invoicedetails != null) {
      data['invoicedetails'] =
          this.invoicedetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EditInvoicedetails {
  int? id;
  String? description;
  String? quantity;
  int? invoiceId;
  String? amount;
  String? productId;
  String? deletedAt;

  EditInvoicedetails(
      {this.id,
      this.description,
      this.quantity,
      this.invoiceId,
      this.amount,
      this.productId,
      this.deletedAt});

  EditInvoicedetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    quantity = json['quantity'];
    invoiceId = json['invoiceId'];
    productId = json['productId'];
    amount = json['amount'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['quantity'] = this.quantity;
    data['invoiceId'] = this.invoiceId;
    data['productId'] = this.productId;
    data['amount'] = this.amount;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}
