class CheckInternationalResponseModel {
  var receivedpaymentpush;
  var receivedpaymentsms;
  var receivedpaymentemail;
  var transferpush;
  var transfersms;
  var transferemail;
  var receivedorderspush;
  var receivedordersms;
  var receivedorderemail;
  var receivedrequestforpaymentpush;
  var receivedrequestforpaymentsms;
  var receivedrequestforpaymentemail;
  var orderpush;
  var ordersms;
  var orderemail;
  var lastloginip;
  var lastlogindatetime;
  var previouslogindatetime;
  var createdby;
  var modifiedby;
  var isplayasound;
  var isArabic;
  var isInternational;
  var maxaddfundamt;
  var allowrecurringpayment;
  var reminderdays;
  var issavecreditcardajax;
  var isallowsecretkey;
  var assignedoriginator;
  var isusercomission;
  var isinternationalcreditcard;
  var allowcountries;
  var isdebitcardallowforwebcheckout;
  var allowCountryHistory;
  var receiveotpvia;
  var isallowedtosavecard;
  var isallowedtodirectpayment;
  var webhook;
  var webhookURL;
  var webhookAlertEmail;
  var isEmailNotificationEnabled;
  var isSMSNotificationEnabled;
  var transactionMailingList;
  var transactionPush;
  var settlementMailingList;
  var settlementPush;
  var refundMailingList;
  var refundPush;
  var disputeMailingList;
  var disputePush;
  var supportMailingList;
  var supportPush;
  var isallowedtocybersourcevisa;
  var isallowedtocybersourcemastercard;
  var isallowedtoapplepay;
  var isallowedtogooglepay;
  var isallowedtoamex;
  var id;
  var userId;
  var deletedAt;

  CheckInternationalResponseModel(
      {this.receivedpaymentpush,
      this.receivedpaymentsms,
      this.receivedpaymentemail,
      this.transferpush,
      this.transfersms,
      this.transferemail,
      this.receivedorderspush,
      this.receivedordersms,
      this.receivedorderemail,
      this.receivedrequestforpaymentpush,
      this.receivedrequestforpaymentsms,
      this.receivedrequestforpaymentemail,
      this.orderpush,
      this.ordersms,
      this.orderemail,
      this.lastloginip,
      this.lastlogindatetime,
      this.previouslogindatetime,
      this.createdby,
      this.modifiedby,
      this.isplayasound,
      this.isArabic,
      this.isInternational,
      this.maxaddfundamt,
      this.allowrecurringpayment,
      this.reminderdays,
      this.issavecreditcardajax,
      this.isallowsecretkey,
      this.assignedoriginator,
      this.isusercomission,
      this.isinternationalcreditcard,
      this.allowcountries,
      this.isdebitcardallowforwebcheckout,
      this.allowCountryHistory,
      this.receiveotpvia,
      this.isallowedtosavecard,
      this.isallowedtodirectpayment,
      this.webhook,
      this.webhookURL,
      this.webhookAlertEmail,
      this.isEmailNotificationEnabled,
      this.isSMSNotificationEnabled,
      this.transactionMailingList,
      this.transactionPush,
      this.settlementMailingList,
      this.settlementPush,
      this.refundMailingList,
      this.refundPush,
      this.disputeMailingList,
      this.disputePush,
      this.supportMailingList,
      this.supportPush,
      this.isallowedtocybersourcevisa,
      this.isallowedtocybersourcemastercard,
      this.isallowedtoapplepay,
      this.isallowedtogooglepay,
      this.isallowedtoamex,
      this.id,
      this.userId,
      this.deletedAt});

  CheckInternationalResponseModel.fromJson(Map<String, dynamic> json) {
    receivedpaymentpush = json['receivedpaymentpush'];
    receivedpaymentsms = json['receivedpaymentsms'];
    receivedpaymentemail = json['receivedpaymentemail'];
    transferpush = json['transferpush'];
    transfersms = json['transfersms'];
    transferemail = json['transferemail'];
    receivedorderspush = json['receivedorderspush'];
    receivedordersms = json['receivedordersms'];
    receivedorderemail = json['receivedorderemail'];
    receivedrequestforpaymentpush = json['receivedrequestforpaymentpush'];
    receivedrequestforpaymentsms = json['receivedrequestforpaymentsms'];
    receivedrequestforpaymentemail = json['receivedrequestforpaymentemail'];
    orderpush = json['orderpush'];
    ordersms = json['ordersms'];
    orderemail = json['orderemail'];
    lastloginip = json['lastloginip'];
    lastlogindatetime = json['lastlogindatetime'];
    previouslogindatetime = json['previouslogindatetime'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    isplayasound = json['isplayasound'];
    isArabic = json['isArabic'];
    isInternational = json['isInternational'];
    maxaddfundamt = json['maxaddfundamt'];
    allowrecurringpayment = json['allowrecurringpayment'];
    reminderdays = json['reminderdays'];
    issavecreditcardajax = json['issavecreditcardajax'];
    isallowsecretkey = json['isallowsecretkey'];
    assignedoriginator = json['assignedoriginator'];
    isusercomission = json['isusercomission'];
    isinternationalcreditcard = json['isinternationalcreditcard'];
    allowcountries = json['allowcountries'];
    isdebitcardallowforwebcheckout = json['isdebitcardallowforwebcheckout'];
    allowCountryHistory = json['allowCountryHistory'];
    receiveotpvia = json['receiveotpvia'];
    isallowedtosavecard = json['isallowedtosavecard'];
    isallowedtodirectpayment = json['isallowedtodirectpayment'];
    webhook = json['webhook'];
    webhookURL = json['webhookURL'];
    webhookAlertEmail = json['webhookAlertEmail'];
    isEmailNotificationEnabled = json['isEmailNotificationEnabled'];
    isSMSNotificationEnabled = json['isSMSNotificationEnabled'];
    transactionMailingList = json['transactionMailingList'];
    transactionPush = json['transactionPush'];
    settlementMailingList = json['settlementMailingList'];
    settlementPush = json['settlementPush'];
    refundMailingList = json['refundMailingList'];
    refundPush = json['refundPush'];
    disputeMailingList = json['disputeMailingList'];
    disputePush = json['disputePush'];
    supportMailingList = json['supportMailingList'];
    supportPush = json['supportPush'];
    isallowedtocybersourcevisa = json['isallowedtocybersourcevisa'];
    isallowedtocybersourcemastercard = json['isallowedtocybersourcemastercard'];
    isallowedtoapplepay = json['isallowedtoapplepay'];
    isallowedtogooglepay = json['isallowedtogooglepay'];
    isallowedtoamex = json['isallowedtoamex'];
    id = json['id'];
    userId = json['userId'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receivedpaymentpush'] = this.receivedpaymentpush;
    data['receivedpaymentsms'] = this.receivedpaymentsms;
    data['receivedpaymentemail'] = this.receivedpaymentemail;
    data['transferpush'] = this.transferpush;
    data['transfersms'] = this.transfersms;
    data['transferemail'] = this.transferemail;
    data['receivedorderspush'] = this.receivedorderspush;
    data['receivedordersms'] = this.receivedordersms;
    data['receivedorderemail'] = this.receivedorderemail;
    data['receivedrequestforpaymentpush'] = this.receivedrequestforpaymentpush;
    data['receivedrequestforpaymentsms'] = this.receivedrequestforpaymentsms;
    data['receivedrequestforpaymentemail'] =
        this.receivedrequestforpaymentemail;
    data['orderpush'] = this.orderpush;
    data['ordersms'] = this.ordersms;
    data['orderemail'] = this.orderemail;
    data['lastloginip'] = this.lastloginip;
    data['lastlogindatetime'] = this.lastlogindatetime;
    data['previouslogindatetime'] = this.previouslogindatetime;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['isplayasound'] = this.isplayasound;
    data['isArabic'] = this.isArabic;
    data['isInternational'] = this.isInternational;
    data['maxaddfundamt'] = this.maxaddfundamt;
    data['allowrecurringpayment'] = this.allowrecurringpayment;
    data['reminderdays'] = this.reminderdays;
    data['issavecreditcardajax'] = this.issavecreditcardajax;
    data['isallowsecretkey'] = this.isallowsecretkey;
    data['assignedoriginator'] = this.assignedoriginator;
    data['isusercomission'] = this.isusercomission;
    data['isinternationalcreditcard'] = this.isinternationalcreditcard;
    data['allowcountries'] = this.allowcountries;
    data['isdebitcardallowforwebcheckout'] =
        this.isdebitcardallowforwebcheckout;
    data['allowCountryHistory'] = this.allowCountryHistory;
    data['receiveotpvia'] = this.receiveotpvia;
    data['isallowedtosavecard'] = this.isallowedtosavecard;
    data['isallowedtodirectpayment'] = this.isallowedtodirectpayment;
    data['webhook'] = this.webhook;
    data['webhookURL'] = this.webhookURL;
    data['webhookAlertEmail'] = this.webhookAlertEmail;
    data['isEmailNotificationEnabled'] = this.isEmailNotificationEnabled;
    data['isSMSNotificationEnabled'] = this.isSMSNotificationEnabled;
    data['transactionMailingList'] = this.transactionMailingList;
    data['transactionPush'] = this.transactionPush;
    data['settlementMailingList'] = this.settlementMailingList;
    data['settlementPush'] = this.settlementPush;
    data['refundMailingList'] = this.refundMailingList;
    data['refundPush'] = this.refundPush;
    data['disputeMailingList'] = this.disputeMailingList;
    data['disputePush'] = this.disputePush;
    data['supportMailingList'] = this.supportMailingList;
    data['supportPush'] = this.supportPush;
    data['isallowedtocybersourcevisa'] = this.isallowedtocybersourcevisa;
    data['isallowedtocybersourcemastercard'] =
        this.isallowedtocybersourcemastercard;
    data['isallowedtoapplepay'] = this.isallowedtoapplepay;
    data['isallowedtogooglepay'] = this.isallowedtogooglepay;
    data['isallowedtoamex'] = this.isallowedtoamex;
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}
