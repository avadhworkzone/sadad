class CreateInvoiceRequestModel {
  String? clientname;
  String? remarks;
  String? grossamount;
  String? invoicesenderId;
  String? invoicestatusId;
  String? cellno;
  String? createdby;
  String? paymentduedate;
  bool? readreceipt;
  bool? remarksenabled;
  List<CreateInvoicedetails>? invoicedetails;

  CreateInvoiceRequestModel(
      {this.clientname,
      this.remarks,
      this.grossamount,
      this.invoicesenderId,
      this.invoicestatusId,
      this.cellno,
      this.createdby,
      this.paymentduedate,
      // this.readreceipt,
      this.remarksenabled,
      this.invoicedetails});

  CreateInvoiceRequestModel.fromJson(Map<String, dynamic> json) {
    clientname = json['clientname'];
    remarks = json['remarks'];
    grossamount = json['grossamount'];
    invoicesenderId = json['invoicesenderId'];
    invoicestatusId = json['invoicestatusId'];
    cellno = json['cellno'];
    createdby = json['createdby'];
    paymentduedate = json['paymentduedate'];
    readreceipt = json['readreceipt'];
    remarksenabled = json['remarksenabled'];
    if (json['invoicedetails'] != null) {
      invoicedetails = <CreateInvoicedetails>[];
      json['invoicedetails'].forEach((v) {
        invoicedetails!.add(new CreateInvoicedetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientname'] = this.clientname;
    data['remarks'] = this.remarks;
    data['grossamount'] = this.grossamount;
    data['invoicesenderId'] = this.invoicesenderId;
    data['invoicestatusId'] = this.invoicestatusId;
    data['cellno'] = this.cellno;
    data['createdby'] = this.createdby;
    data['paymentduedate'] = this.paymentduedate;
    data['readreceipt'] = this.readreceipt;
    data['remarksenabled'] = this.remarksenabled;
    if (this.invoicedetails != null) {
      data['invoicedetails'] =
          this.invoicedetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CreateInvoicedetails {
  String? description;
  String? quantity;
  String? amount;
  String? productId;

  CreateInvoicedetails(
      {this.description, this.quantity, this.amount, this.productId});

  CreateInvoicedetails.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    quantity = json['quantity'];
    amount = json['amount'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['quantity'] = this.quantity;
    data['amount'] = this.amount;
    data['productId'] = this.productId;
    return data;
  }
}
