class OnlineInvoiceReportResponse {
  var count;
  List<InvoiceReportRes>? data;

  OnlineInvoiceReportResponse({this.count, this.data});

  OnlineInvoiceReportResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = <InvoiceReportRes>[];
      json['data'].forEach((v) {
        data!.add(new InvoiceReportRes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InvoiceReportRes {
  var invoicePaymentDate;
  var transactionId;
  var invoiceNumber;
  var invoiceCreatedDate;
  var invoiceAmount;
  var currency;
  var invoiceStatus;
  var invoiceViewStatus;
  var invoiceSharedVia;
  var username;
  var customerName;
  var customerEmailId;
  var customerMobileNumber;
  var invoiceDescription;
  var subtotal;
  var invoiceId;
  List<InvoiceDetails>? invoiceDetails;

  InvoiceReportRes(
      {this.invoicePaymentDate,
      this.transactionId,
      this.invoiceNumber,
      this.invoiceCreatedDate,
      this.invoiceAmount,
      this.currency,
      this.invoiceStatus,
      this.invoiceViewStatus,
      this.invoiceSharedVia,
      this.username,
      this.customerName,
      this.customerEmailId,
      this.customerMobileNumber,
      this.invoiceDescription,
      this.subtotal,
      this.invoiceId,
      this.invoiceDetails});

  InvoiceReportRes.fromJson(Map<String, dynamic> json) {
    invoicePaymentDate = json['invoicePaymentDate'];
    transactionId = json['transactionId'];
    invoiceNumber = json['invoiceNumber'];
    invoiceCreatedDate = json['invoiceCreatedDate'];
    invoiceAmount = json['invoiceAmount'];
    currency = json['currency'];
    invoiceStatus = json['invoiceStatus'];
    invoiceViewStatus = json['invoiceViewStatus'];
    invoiceSharedVia = json['invoiceSharedVia'];
    username = json['username'];
    customerName = json['customerName'];
    customerEmailId = json['customerEmailId'];
    customerMobileNumber = json['customerMobileNumber'];
    invoiceDescription = json['invoiceDescription'];
    subtotal = json['subtotal'];
    invoiceId = json['invoiceId'];
    if (json['invoiceDetails'] != null) {
      invoiceDetails = <InvoiceDetails>[];
      json['invoiceDetails'].forEach((v) {
        invoiceDetails!.add(new InvoiceDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoicePaymentDate'] = this.invoicePaymentDate;
    data['transactionId'] = this.transactionId;
    data['invoiceNumber'] = this.invoiceNumber;
    data['invoiceCreatedDate'] = this.invoiceCreatedDate;
    data['invoiceAmount'] = this.invoiceAmount;
    data['currency'] = this.currency;
    data['invoiceStatus'] = this.invoiceStatus;
    data['invoiceViewStatus'] = this.invoiceViewStatus;
    data['invoiceSharedVia'] = this.invoiceSharedVia;
    data['username'] = this.username;
    data['customerName'] = this.customerName;
    data['customerEmailId'] = this.customerEmailId;
    data['customerMobileNumber'] = this.customerMobileNumber;
    data['invoiceDescription'] = this.invoiceDescription;
    data['subtotal'] = this.subtotal;
    data['invoiceId'] = this.invoiceId;
    if (this.invoiceDetails != null) {
      data['invoiceDetails'] =
          this.invoiceDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InvoiceDetails {
  var productName;
  var quantity;
  var unitPrice;
  var productAmount;

  InvoiceDetails(
      {this.productName, this.quantity, this.unitPrice, this.productAmount});

  InvoiceDetails.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    quantity = json['quantity'];
    unitPrice = json['unitPrice'];
    productAmount = json['productAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productName'] = this.productName;
    data['quantity'] = this.quantity;
    data['unitPrice'] = this.unitPrice;
    data['productAmount'] = this.productAmount;
    return data;
  }
}
