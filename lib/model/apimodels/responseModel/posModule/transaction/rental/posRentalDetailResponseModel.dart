import 'dart:convert';

class PosRentalDetailResponseModel {
  var totalinvoices;
  List<PosInvoiceDetail>? invoices;

  PosRentalDetailResponseModel({this.totalinvoices, this.invoices});

  PosRentalDetailResponseModel.fromJson(Map<String, dynamic> json) {
    totalinvoices = json['totalinvoices'];
    if (json['invoices'] != null) {
      invoices = <PosInvoiceDetail>[];
      json['invoices'].forEach((v) {
        invoices!.add(new PosInvoiceDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalinvoices'] = this.totalinvoices;
    if (this.invoices != null) {
      data['invoices'] = this.invoices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PosInvoiceDetail {
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
  List<InvoiceSummery>? invoiceSummery;
  var id;
  var date;
  var createdby;
  var deletedAt;
  var created;
  var invoicestatusId;
  Transaction? transaction;
  InvoicereceiverId? invoicereceiverId;
  InvoicereceiverId? invoicesenderId;
  Transactionstatus? invoicestatus;
  List<Recurringposrentals>? recurringposrentals;

  PosInvoiceDetail(
      {this.invoiceno,
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
      this.recurringposrentals});

  PosInvoiceDetail.fromJson(Map<String, dynamic> json) {
    invoiceno = json['invoiceno'];
    clientname = json['clientname'];
    cellno = json['cellno'];
    emailaddress = json['emailaddress'];
    remarks = json['remarks'];
    grossamount = json['grossamount'];
    transactionfees = json['transactionfees'];
    netamount = json['netamount'];
    modifiedby = json['modifiedby'];
    paymentduedate = json['paymentduedate'];
    shareUrl = json['shareUrl'];
    subsinvoiceId = json['subsinvoiceId'];
    isrentalplaninvoice = json['isrentalplaninvoice'];
    // invoiceSummery = json['invoice_summery'];
    if (json['invoice_summery'] != null) {
      invoiceSummery = <InvoiceSummery>[];
      jsonDecode(json['invoice_summery']).forEach((v) {
        invoiceSummery!.add(new InvoiceSummery.fromJson(v));
      });
    }

    id = json['id'];
    date = json['date'];
    createdby = json['createdby'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    invoicestatusId = json['invoicestatusId'];
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
    invoicereceiverId = json['invoicereceiverId'] != null
        ? new InvoicereceiverId.fromJson(json['invoicereceiverId'])
        : null;
    invoicesenderId = json['invoicesenderId'] != null
        ? new InvoicereceiverId.fromJson(json['invoicesenderId'])
        : null;
    invoicestatus = json['invoicestatus'] != null
        ? new Transactionstatus.fromJson(json['invoicestatus'])
        : null;
    if (json['recurringposrentals'] != null) {
      recurringposrentals = <Recurringposrentals>[];
      json['recurringposrentals'].forEach((v) {
        recurringposrentals!.add(new Recurringposrentals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoiceno'] = this.invoiceno;
    data['clientname'] = this.clientname;
    data['cellno'] = this.cellno;
    data['emailaddress'] = this.emailaddress;
    data['remarks'] = this.remarks;
    data['grossamount'] = this.grossamount;
    data['transactionfees'] = this.transactionfees;
    data['netamount'] = this.netamount;
    data['modifiedby'] = this.modifiedby;
    data['paymentduedate'] = this.paymentduedate;
    data['shareUrl'] = this.shareUrl;
    data['subsinvoiceId'] = this.subsinvoiceId;
    data['isrentalplaninvoice'] = this.isrentalplaninvoice;
    if (this.invoiceSummery != null) {
      data['invoice_summery'] =
          this.invoiceSummery!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['date'] = this.date;
    data['createdby'] = this.createdby;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    data['invoicestatusId'] = this.invoicestatusId;
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    if (this.invoicereceiverId != null) {
      data['invoicereceiverId'] = this.invoicereceiverId!.toJson();
    }
    if (this.invoicesenderId != null) {
      data['invoicesenderId'] = this.invoicesenderId!.toJson();
    }
    if (this.invoicestatus != null) {
      data['invoicestatus'] = this.invoicestatus!.toJson();
    }
    if (this.recurringposrentals != null) {
      data['recurringposrentals'] =
          this.recurringposrentals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transaction {
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
  Transactionstatus? transactionstatus;
  Transactionstatus? transactionmode;
  Transactionstatus? transactionentity;

  Transaction(
      {this.entityid,
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
      this.transactionentity});

  Transaction.fromJson(Map<String, dynamic> json) {
    entityid = json['entityid'];
    invoicenumber = json['invoicenumber'];
    amount = json['amount'];
    servicecharge = json['servicecharge'];
    servicechargedescription = json['servicechargedescription'];
    audittype = json['audittype'];
    auditcomment = json['auditcomment'];
    transactionSummary = json['transaction_summary'];
    cardholdername = json['cardholdername'];
    cardsixdigit = json['cardsixdigit'];
    bincardstatusvalue = json['bincardstatusvalue'];
    txniptrackervalue = json['txniptrackervalue'];
    osHistory = json['os_history'];
    creditcardpaymentmodeid = json['creditcardpaymentmodeid'];
    refundcharge = json['refundcharge'];
    refundchargedescription = json['refundchargedescription'];
    id = json['id'];
    transactiondate = json['transactiondate'];
    created = json['created'];
    modified = json['modified'];
    transactionentityId = json['transactionentityId'];
    transactionmodeId = json['transactionmodeId'];
    transactionstatusId = json['transactionstatusId'];
    guestuserId = json['guestuserId'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    transactionstatus = json['transactionstatus'] != null
        ? new Transactionstatus.fromJson(json['transactionstatus'])
        : null;
    transactionmode = json['transactionmode'] != null
        ? new Transactionstatus.fromJson(json['transactionmode'])
        : null;
    transactionentity = json['transactionentity'] != null
        ? new Transactionstatus.fromJson(json['transactionentity'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entityid'] = this.entityid;
    data['invoicenumber'] = this.invoicenumber;
    data['amount'] = this.amount;
    data['servicecharge'] = this.servicecharge;
    data['servicechargedescription'] = this.servicechargedescription;
    data['audittype'] = this.audittype;
    data['auditcomment'] = this.auditcomment;
    data['transaction_summary'] = this.transactionSummary;
    data['cardholdername'] = this.cardholdername;
    data['cardsixdigit'] = this.cardsixdigit;
    data['bincardstatusvalue'] = this.bincardstatusvalue;
    data['txniptrackervalue'] = this.txniptrackervalue;
    data['os_history'] = this.osHistory;
    data['creditcardpaymentmodeid'] = this.creditcardpaymentmodeid;
    data['refundcharge'] = this.refundcharge;
    data['refundchargedescription'] = this.refundchargedescription;
    data['id'] = this.id;
    data['transactiondate'] = this.transactiondate;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['transactionentityId'] = this.transactionentityId;
    data['transactionmodeId'] = this.transactionmodeId;
    data['transactionstatusId'] = this.transactionstatusId;
    data['guestuserId'] = this.guestuserId;
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    if (this.transactionstatus != null) {
      data['transactionstatus'] = this.transactionstatus!.toJson();
    }
    if (this.transactionmode != null) {
      data['transactionmode'] = this.transactionmode!.toJson();
    }
    if (this.transactionentity != null) {
      data['transactionentity'] = this.transactionentity!.toJson();
    }
    return data;
  }
}

class Transactionstatus {
  var name;
  var id;

  Transactionstatus({this.name, this.id});

  Transactionstatus.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}

class InvoicereceiverId {
  var sadadId;
  var name;
  var type;
  var cellnumber;
  var email;
  var id;
  var created;
  var roleId;

  InvoicereceiverId(
      {this.sadadId,
      this.name,
      this.type,
      this.cellnumber,
      this.email,
      this.id,
      this.created,
      this.roleId});

  InvoicereceiverId.fromJson(Map<String, dynamic> json) {
    sadadId = json['SadadId'];
    name = json['name'];
    type = json['type'];
    cellnumber = json['cellnumber'];
    email = json['email'];
    id = json['id'];
    created = json['created'];
    roleId = json['roleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SadadId'] = this.sadadId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['cellnumber'] = this.cellnumber;
    data['email'] = this.email;
    data['id'] = this.id;
    data['created'] = this.created;
    data['roleId'] = this.roleId;
    return data;
  }
}

class Recurringposrentals {
  var userId;
  var terminalId;
  var rentalPlanId;
  var frequency;
  var iterations;
  var pendingIterations;
  var lastIterationAmount;
  bool? isRentalsActivated;
  var installationFees;
  var amount;
  var additionalCharges;
  var rentalThresHold;
  var nextposrentaldate;
  var invoiceId;
  var transactionId;
  var createdby;
  var modifiedby;
  var id;
  var deletedAt;
  var created;
  var modified;
  var rentalPeriod;
  Terminal? terminal;

  Recurringposrentals(
      {this.userId,
      this.terminalId,
      this.rentalPlanId,
      this.frequency,
      this.iterations,
      this.pendingIterations,
      this.lastIterationAmount,
      this.isRentalsActivated,
      this.installationFees,
      this.amount,
      this.additionalCharges,
      this.rentalThresHold,
      this.nextposrentaldate,
      this.invoiceId,
      this.transactionId,
      this.createdby,
      this.modifiedby,
      this.id,
      this.deletedAt,
      this.created,
      this.modified,
      this.rentalPeriod,
      this.terminal});

  Recurringposrentals.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    terminalId = json['terminalId'];
    rentalPlanId = json['rentalPlanId'];
    frequency = json['frequency'];
    iterations = json['iterations'];
    pendingIterations = json['pending_iterations'];
    lastIterationAmount = json['last_iteration_amount'];
    isRentalsActivated = json['isRentalsActivated'];
    installationFees = json['installationFees'];
    amount = json['amount'];
    additionalCharges = json['additionalCharges'];
    rentalThresHold = json['rentalThresHold'];
    nextposrentaldate = json['nextposrentaldate'];
    invoiceId = json['invoiceId'];
    transactionId = json['transactionId'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    id = json['id'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    modified = json['modified'];
    rentalPeriod = json['rentalPeriod'];
    terminal = json['terminal'] != null
        ? new Terminal.fromJson(json['terminal'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['terminalId'] = this.terminalId;
    data['rentalPlanId'] = this.rentalPlanId;
    data['frequency'] = this.frequency;
    data['iterations'] = this.iterations;
    data['pending_iterations'] = this.pendingIterations;
    data['last_iteration_amount'] = this.lastIterationAmount;
    data['isRentalsActivated'] = this.isRentalsActivated;
    data['installationFees'] = this.installationFees;
    data['amount'] = this.amount;
    data['additionalCharges'] = this.additionalCharges;
    data['rentalThresHold'] = this.rentalThresHold;
    data['nextposrentaldate'] = this.nextposrentaldate;
    data['invoiceId'] = this.invoiceId;
    data['transactionId'] = this.transactionId;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['id'] = this.id;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['rentalPeriod'] = this.rentalPeriod;
    if (this.terminal != null) {
      data['terminal'] = this.terminal!.toJson();
    }
    return data;
  }
}

class Terminal {
  var terminalId;
  var deviceSerialNo;
  var devicetypeId;
  Posdevice? posdevice;
  Devicetype? devicetype;

  Terminal(
      {this.terminalId,
      this.deviceSerialNo,
      this.devicetypeId,
      this.posdevice,
      this.devicetype});

  Terminal.fromJson(Map<String, dynamic> json) {
    terminalId = json['terminalId'];
    deviceSerialNo = json['deviceSerialNo'];
    devicetypeId = json['devicetypeId'];
    posdevice = json['posdevice'] != null
        ? new Posdevice.fromJson(json['posdevice'])
        : null;
    devicetype = json['devicetype'] != null
        ? new Devicetype.fromJson(json['devicetype'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['terminalId'] = this.terminalId;
    data['deviceSerialNo'] = this.deviceSerialNo;
    data['devicetypeId'] = this.devicetypeId;
    if (this.posdevice != null) {
      data['posdevice'] = this.posdevice!.toJson();
    }
    if (this.devicetype != null) {
      data['devicetype'] = this.devicetype!.toJson();
    }
    return data;
  }
}

class Posdevice {
  var serial;
  var deviceId;

  Posdevice({this.serial, this.deviceId});

  Posdevice.fromJson(Map<String, dynamic> json) {
    serial = json['serial'];
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serial'] = this.serial;
    data['deviceId'] = this.deviceId;
    return data;
  }
}

class Devicetype {
  var name;
  var devicetype;
  var id;

  Devicetype({this.name, this.devicetype, this.id});

  Devicetype.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    devicetype = json['devicetype'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['devicetype'] = this.devicetype;
    data['id'] = this.id;
    return data;
  }
}

class InvoiceSummery {
  var terminalId;
  var rentalPlanId;
  var quantity;
  var installationFees;
  var amount;
  var additionalCharges;
  var nextPosRentalDate;
  var totalAmount;
  var deviceSerialNo;
  var devicetype;
  var frequency;

  InvoiceSummery(
      {this.terminalId,
      this.rentalPlanId,
      this.quantity,
      this.installationFees,
      this.amount,
      this.additionalCharges,
      this.totalAmount,
      this.nextPosRentalDate,
      this.deviceSerialNo,
      this.devicetype,
      this.frequency});

  InvoiceSummery.fromJson(Map<String, dynamic> json) {
    terminalId = json['terminalId'];
    rentalPlanId = json['rentalPlanId'];
    quantity = json['quantity'];
    installationFees = json['installation_fees'];
    amount = json['amount'];
    totalAmount = json['totalAmount'];
    additionalCharges = json['additional_charges'];
    nextPosRentalDate = json['next_pos_rental_date'];
    deviceSerialNo = json['deviceSerialNo'];
    devicetype = json['devicetype'];
    frequency = json['frequency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['terminalId'] = this.terminalId;
    data['quantity'] = this.quantity;
    data['rentalPlanId'] = this.rentalPlanId;
    data['installation_fees'] = this.installationFees;
    data['amount'] = this.amount;
    data['additional_charges'] = this.additionalCharges;
    data['next_pos_rental_date'] = this.nextPosRentalDate;
    data['deviceSerialNo'] = this.deviceSerialNo;
    data['devicetype'] = this.devicetype;
    data['frequency'] = this.frequency;
    data['totalAmount'] = this.totalAmount;
    return data;
  }
}

class Autogenerated {
  List<InvoiceSummery>? invoiceSummery;

  Autogenerated({this.invoiceSummery});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    if (json['invoice_summery'] != null) {
      invoiceSummery = <InvoiceSummery>[];
      json['invoice_summery'].forEach((v) {
        invoiceSummery!.add(new InvoiceSummery.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.invoiceSummery != null) {
      data['invoice_summery'] =
          this.invoiceSummery!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class InvoiceSummery {
//   String? terminalId;
//   String? rentalPlanId;
//   int? installationFees;
//   int? amount;
//   int? additionalCharges;
//   String? nextPosRentalDate;
//   String? deviceSerialNo;
//   String? devicetype;
//   String? frequency;
//
//   InvoiceSummery(
//       {this.terminalId,
//         this.rentalPlanId,
//         this.installationFees,
//         this.amount,
//         this.additionalCharges,
//         this.nextPosRentalDate,
//         this.deviceSerialNo,
//         this.devicetype,
//         this.frequency});
//
//   InvoiceSummery.fromJson(Map<String, dynamic> json) {
//     terminalId = json['terminalId'];
//     rentalPlanId = json['rentalPlanId'];
//     installationFees = json['installation_fees'];
//     amount = json['amount'];
//     additionalCharges = json['additional_charges'];
//     nextPosRentalDate = json['next_pos_rental_date'];
//     deviceSerialNo = json['deviceSerialNo'];
//     devicetype = json['devicetype'];
//     frequency = json['frequency'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['terminalId'] = this.terminalId;
//     data['rentalPlanId'] = this.rentalPlanId;
//     data['installation_fees'] = this.installationFees;
//     data['amount'] = this.amount;
//     data['additional_charges'] = this.additionalCharges;
//     data['next_pos_rental_date'] = this.nextPosRentalDate;
//     data['deviceSerialNo'] = this.deviceSerialNo;
//     data['devicetype'] = this.devicetype;
//     data['frequency'] = this.frequency;
//     return data;
//   }
// }
