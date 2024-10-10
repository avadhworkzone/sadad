class InvoiceAllListResponseModel {
  var invoiceno;
  var clientname;
  var cellno;
  var emailaddress;
  var remarksenabled;
  var remarks;
  var grossamount;
  var transactionfees;
  var netamount;
  var expecteddelivery;
  var readreceipt;
  var readdatetime;
  var modifiedby;
  var isArchived;
  var internationalAllow;
  var paymentduedate;
  var shareUrl;
  var recurringFreq;
  var subsinvoiceId;
  var cycleperiod;
  var cycleperiodexpiry;
  var usermetadetailsid;
  var sourceofinvoice;
  var isrentalplaninvoice;
  var invoiceSummery;
  var withDetails;
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
  List<dynamic>? invoiceDetails;

  InvoiceAllListResponseModel(
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
      this.invoicesenderId,
      this.invoiceDetails});

  InvoiceAllListResponseModel.fromJson(Map<String, dynamic> json) {
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
    if (json['invoicedetails'] != null) {
      invoiceDetails = <Invoicedetails>[];
      json['invoicedetails'].forEach((v) {
        invoiceDetails!.add(new Invoicedetails.fromJson(v));
      });
    }
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
    if (this.invoiceDetails != null) {
      data['invoicedetails'] =
          this.invoiceDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Invoicedetails {
  var description;
  var quantity;
  var amount;
  var createdby;
  var modifiedby;
  var id;
  var invoiceId;
  var productId;
  var deletedAt;
  var productrecurringId;
  Product? product;
  Invoicedetails(
      {this.description,
      this.quantity,
      this.amount,
      this.createdby,
      this.modifiedby,
      this.id,
      this.invoiceId,
      this.productId,
      this.deletedAt,
      this.product,
      this.productrecurringId});

  Invoicedetails.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    quantity = json['quantity'];
    amount = json['amount'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    id = json['id'];
    invoiceId = json['invoiceId'];
    productId = json['productId'];
    deletedAt = json['deletedAt'];
    productrecurringId = json['productrecurringId'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['quantity'] = this.quantity;
    data['amount'] = this.amount;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['id'] = this.id;
    data['invoiceId'] = this.invoiceId;
    data['productId'] = this.productId;
    data['deletedAt'] = this.deletedAt;
    data['productrecurringId'] = this.productrecurringId;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Product {
  var name;
  var description;
  var arabicName;
  var arabicDescription;
  var totalavailablequantity;
  var enablewatermark;
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
