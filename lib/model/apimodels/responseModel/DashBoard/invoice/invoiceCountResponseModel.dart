class InvoiceCountResponseModel {
  var totalCreatedInvoice;
  var totalCreatedInvoiceAmount;
  var draft;
  var unpaid;
  var paid;
  var overdue;
  var draftAmount;
  var unpaidAmount;
  var paidAmount;
  var overdueAmount;

  InvoiceCountResponseModel(
      {this.totalCreatedInvoice,
      this.totalCreatedInvoiceAmount,
      this.draft,
      this.unpaid,
      this.paid,
      this.overdue,
      this.draftAmount,
      this.unpaidAmount,
      this.paidAmount,
      this.overdueAmount});

  InvoiceCountResponseModel.fromJson(Map<String, dynamic> json) {
    totalCreatedInvoice = json['total_created_invoice'];
    totalCreatedInvoiceAmount = json['total_created_invoice_amount'];
    draft = json['draft'];
    unpaid = json['unpaid'];
    paid = json['paid'];
    overdue = json['overdue'];
    draftAmount = json['draftAmount'];
    unpaidAmount = json['unpaidAmount'];
    paidAmount = json['paidAmount'];
    overdueAmount = json['overdueAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_created_invoice'] = this.totalCreatedInvoice;
    data['total_created_invoice_amount'] = this.totalCreatedInvoiceAmount;
    data['draft'] = this.draft;
    data['unpaid'] = this.unpaid;
    data['paid'] = this.paid;
    data['overdue'] = this.overdue;
    data['draftAmount'] = this.draftAmount;
    data['unpaidAmount'] = this.unpaidAmount;
    data['paidAmount'] = this.paidAmount;
    data['overdueAmount'] = this.overdueAmount;
    return data;
  }
}
