import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/util/utils.dart';

import '../base/constants.dart';

class StaticData {
  //DashboardScreen
  List<String> chartsZone = [
    'Today',
    'Yesterday',
    'Week',
    'Month',
    'Year',
    'Custom'
  ];
  List<String> timeZone = [
    'All',
    'Today',
    'Yesterday',
    'Week',
    'Month',
    'Year',
    'Custom'
  ];
  List<String> batchSummaryTimeZone = [
    'Today',
    'Yesterday',
    'Week',
    'Month',
    'Custom'
  ];
  List<String> transactionStatus = [
    'InProgress',
    'Success',
    'Failed',
    'On-Hold'
  ];
  List<String> transactionTypes = [
    'Purchase',
    'Refund',
    'Dispute',
  ];
  List<String> refundStatus = [
    'Refunded',
    'Requested',
    'Rejected',
  ];
  List<String> disputeStatus = [
    'Open',
    'Under Review',
    'Close',
  ];
  List<String> disputeType = [
    'ChargeBack',
    'Fraud',
  ];

  List<String> transactionModes = [
    'Credit card',
    'Debit card',
    'Wallet',
  ];
  List<String> integrationTypes = [
    'Website',
    'Mobile',
  ];
  List<String> transactionSources = [
    // 'Subscription',
    // 'Add Funds',
    'Wallet Transfer',
    'Store Link',
    'PG API',
    'QR-Transfer',
    // 'Subscription',
    // 'Maved',
    'Invoice',
  ];

  List<String> transactionReportSources = [
    'PG API',
    'Mawaid',
    'Invoice',
    'Wallet Transfer',
    'Subscription',
    'Store Link',
    'All',
  ];
  List<Map<String, dynamic>> transactionPaymentMethod = [
    {
      'title': 'Visa',
      'image': Images.visaCard,
    },
    {
      'title': 'Mastercard',
      'image': Images.masterCard,
    },
    {
      'title': 'AMEX',
      'image': Images.amex,
    },
    {
      'title': 'JCB',
      'image': Images.jcb,
    },
    {
      'title': 'UPI',
      'image': Images.upi,
    },
    {
      'title': 'Sadad Pay',
      'image': Images.sadadWalletPay,
    },
    {
      'title': 'Apple Pay',
      'image': Images.applePay,
    },
    {
      'title': 'Google Pay',
      'image': Images.googlePay,
    },
  ];
  //
  // List<SalesData> data = [
  //
  // ];
  // List<Map<dynamic, dynamic>> paymentMethodItemList = [
  // ];
  List<Map<String, String>> createModuleList = [
    {
      "title": "create Invoice",
      "icon": Images.invoice,
      "addIcon": Images.addRoundMaroon,
    },
    {
      "title": "create Product",
      "icon": Images.product,
      "addIcon": Images.addRoundGreen,
    },
    // {
    //   "title": "create Subscription",
    //   "icon": Images.subscription,
    //   "addIcon": Images.addRoundYellow,
    // },
    // {
    //   "title": "create QR Code",
    //   "icon": Images.qrCode,
    //   "addIcon": Images.addRoundBlack,
    // },
  ];
  // List<TransactionSourceData> transactionData = [];

  //PaymentScreen
  List<Map<dynamic, dynamic>> paymentTransactionAmountList = [
    {
      "title": "Transactions Count",
      "icon": Images.successfulTransaction,
      "amount": 175918.88,
      "Color": ColorsUtils.green
    },
    {
      "title": "Successful Transactions",
      "icon": Images.successfulTransaction,
      "amount": 175918.88,
      "Color": ColorsUtils.green
    },
    {
      // "title": "Payout Received",
      "title": "Refunds Accepted",
      // "icon": Images.payoutReceived,
      "icon": Images.refundBack,
      "amount": 175918.88,
      "Color": ColorsUtils.reds
    },
    {
      "title": "Invoice Amount",
      "icon": Images.invoice,
      "amount": 175918.88,
      "Color": ColorsUtils.primary
    },
    {
      "title": "Payout Received",
      // "title": "Refunds Accepted",
      "icon": Images.payoutReceived,
      // "icon": Images.refundBack,
      "amount": 175918.88,
      "Color": ColorsUtils.reds
    },
    {
      "title": "Subscriptions Amount",
      "icon": Images.subscriptionMenu,
      "amount": 175918.88,
      "Color": ColorsUtils.chartYellow
    },
    {
      "title": "Product Sold Amount",
      "icon": Images.productsMenu,
      "amount": 175918.88,
      "Color": ColorsUtils.green
    },
  ];

  List<Map<dynamic, dynamic>> paymentServiceList = [
    {
      "name": "Invoices",
      "count": 234,
      "icon": Images.invoice,
      "color": Color(0xff8E1B3E),
      "notificationCount": 0
    },
    {
      "name": "Products",
      "count": 30,
      "icon": Images.productsMenu,
      "color": Color(0xff3B9E4F),
      "notificationCount": 0
    },
    {
      "name": "Store",
      "count": 12,
      "icon": Images.storesMenu,
      "color": Color(0xff50BBEF),
      "notificationCount": 0
    },
    // {
    //   "name": "Subscriptions",
    //   "count": 0,
    //   "icon": Images.subscriptionMenu,
    //   "color": Color(0xffE8B110),
    //   "notificationCount": 0
    // },
    {
      "name": "Transactions",
      "count": 5000,
      "icon": Images.transactionMenu,
      "color": Color(0xff56C596),
      "notificationCount": 0
    },
    {
      "name": "Orders",
      "count": 1200,
      "icon": Images.orders,
      "color": Color(0xff9D4FA0),
      "notificationCount": 12
    },
    {
      "name": "Reports",
      "count": 1200,
      "icon": Images.report,
      "color": Color(0xff011F45),
      "notificationCount": 12
    },
  ];
  //Invoices List
  List<String> invoiceType = ['Rejected', 'Paid', 'Draft', 'Unpaid'];

  //invoice search list
  List<String> invoiceSearchFilter = [
    'Transaction Id',
    'Invoice Number',
    'Customer Name',
    'Customer Email Id',
    'Customer Mobile Number',
  ];
  List<String> withdrawalSearchFilter = ['Withdrawal Id', 'Withdrawal Amount'];

  //Order Search List
  List<String> orderSearchFilter = [
    'Order Number',
    'Transaction Id',
    'Product Name',
    'Buyer Name',
  ];

  //pos Screen

  List<Map<dynamic, dynamic>> posTransactionAmountList = [
    {
      "title": "Successful Transactions",
      "icon": Images.successfulTransaction,
      "amount": 175918.88,
      "Color": ColorsUtils.green
    },
    {
      "title": "Total Transactions",
      "icon": Images.successfulTransaction,
      "amount": 10,
      "Color": ColorsUtils.green
    },
    {
      "title": "Active Terminals",
      "icon": Images.pos,
      "amount": 10.88,
      "Color": ColorsUtils.green
    },
    {
      "title": "Inactive Terminals",
      "icon": Images.pos,
      "amount": 10.88,
      "Color": ColorsUtils.accent
    },
  ];
  List<Map<dynamic, dynamic>> posServiceList = [
    {
      "name": "Terminals",
      "count": 12,
      "icon": Images.pos,
      "color": ColorsUtils.yellow,
      "notificationCount": 0
    },
    {
      "name": "Batch Summary",
      "count": 0,
      "icon": Images.batchSumamry,
      "color": ColorsUtils.reds,
      "notificationCount": 0
    },
    // {
    //   "name": "Devices",
    //   "count": 15,
    //   "icon": Images.calculator,
    //   "color": ColorsUtils.reds,
    //   "notificationCount": 0
    // },
    {
      "name": "Transactions",
      "count": 20,
      "icon": Images.trans,
      "color": ColorsUtils.green,
      "notificationCount": 0
    },
    {
      "name": "Reports",
      "count": 30,
      "icon": Images.doc,
      "color": ColorsUtils.black,
      "notificationCount": 0
    },
  ];
  //terminal filter
  List<String> terminalTransactionStatus = [
    'Active',
    'InActive',
  ];
  List<String> terminalDeviceStatus = [
    'Online',
    'Offline',
  ];
  List<String> terminalDeviceType = [
    'WPOS-3',
    'WPOS-QT',
  ];
  List<String> terminalTransactionModes = [
    'Credit card',
    'Debit card',
  ];
  List<Map<String, dynamic>> terminalPaymentMethod = [
    {
      'title': 'Visa',
      'image': Images.visaCard,
    },
    {
      'title': 'Mastercard',
      'image': Images.masterCard,
    },
    {
      'title': 'AMEX',
      'image': Images.amex,
    },
    {
      'title': 'JCB',
      'image': Images.jcb,
    },
    {
      'title': 'UPI',
      'image': Images.upi,
    },
  ];

  //device status
  List<String> deviceStatus = [
    'Active',
    'InActive',
  ];
  List<String> deviceType = [
    'Wpos-QT',
    'Wpos-3',
  ];
  //posTransactionFilterscreen
  List<String> posTransaction = [
    'Unpaid',
    'Paid',
  ];

  //posPaymentFilterScreen
  List<String> posTransactionStatus = [
    // 'InProgress',
    'Success',
    'Failed',
    // 'On-Hold'
  ];
  List<Map<String, dynamic>> posTransactionPaymentMethod = [
    {
      'title': 'Visa',
      'image': Images.visaCard,
    },
    {
      'title': 'Mastercard',
      'image': Images.masterCard,
    },
    {
      'title': 'AMEX',
      'image': Images.amex,
    },
    {
      'title': 'JCB',
      'image': Images.jcb,
    },
    {
      'title': 'NAPS',
      'image': Images.napsImage,
    },
    {
      'title': 'UPI',
      'image': Images.upi,
    },
    {
      'title': 'TOKEN',
      'image': Images.mobilePay,
    },
  ];

  Map<String, dynamic> cardImage = {
    'VISA': Images.visaCard,
    'MASTERCARD': Images.masterCard,
    'MOBILE PAY': Images.mobilePay,
    'AMEX': Images.amex,
    'JCB': Images.jcb,
    'NAPS': Images.napsImage,
    'UPI': Images.upi,
    'AMERICAN EXPRESS': Images.amex,
    'ELO': Images.upi,
    'DINERS': Images.upi,
    'DISCOVER': Images.upi,
    'MAESTRO': Images.amex,
    'CHINA UNION PAY': Images.upi,
    'GOOGLE PAY': Images.googlePay,
    'APPLE PAY': Images.applePay,
    'SADAD PAY': Images.sadadWalletPay,
  };
  List<String> posTransactionMode = [
    'Credit card',
    'Debit card',
  ];
  List<String> posTransactionType = [
    'Purchase',
    'Preauth Complete',
    'Preauth',
    'Reversal',
    'ManualEntry Purchase',
    'Card Verification'
  ];
  List<String> posCardEntryType = [
    'Chip',
    'Magstripe',
    'Contactless',
    'Fallback',
    'Manual Entry',
  ];
  List<String> posTrnxReportType = [
    'Transaction ID',
    'RRN',
    // 'Terminal Location',
  ];
  List<String> paymentTrnxReportType = [
    'Transaction ID',
    'RRN',
    'Auth Number',
    // 'Terminal Location',
  ];

  List<String> TrnxPaymentSearchType = [
    'Transaction ID',
    'Auth Number',
    'Transaction Amount',
    'Customer Name',
    'Customer Email ID',
    'Customer Mobile no',
    'RRN'
  ];
  List<String> TrnxRefundSearchType = [
    'Refund ID',
    'Refund Amount',
    'Transaction ID'
  ];
  List<String> TrnxDisputeSearchType = ['Dispute ID', 'Transaction ID'];
  //posRefundFilter Screen
  List<String> posRefundStatus = [
    'Refunded',
    'Rejected',
  ];

  //posDisputesFilter Screen
  List<String> posDisputesStatus = [
    'Open',
    'Under Review',
    'Close',
  ];
  List<String> posDisputesType = [
    'ChargeBack',
    'Fraud',
  ];

  //posReportTransactionStatus
  List<String> posReportTransactionStatus = [
    // 'InProgress',
    'Success',
    'Failed',
    // 'On-Hold'
  ];
  List<String> posReportDisputeStatus = ['Open', 'Under Review', 'Close'];
  List<String> posReportRefundStatus = ['Refunded', 'Requested', 'Rejected'];
  List<String> posReportDeviceType = [
    'Wpos-QT',
    'Wpos-3',
  ];
  List<String> posReportDeviceStatus = [
    'Active',
    'Inactive',
  ];
  //store List Screen
  List<Map<String, dynamic>> storeCountList = [
    {
      'title': 'Store Product',
      'subTitle': 'Products',
      'color': ColorsUtils.accent,
      'value': '4'
    },
    {
      'title': 'Store Orders',
      'subTitle': 'Orders',
      'color': ColorsUtils.yellow,
      'value': '34'
    },
    {
      'title': 'Store Orders Amount',
      'subTitle': '',
      'color': ColorsUtils.green,
      'value': ''
    }
  ];

  //set password screen
  List<Map<String, dynamic>> passwordRequirement = [
    {'select': false, 'title': 'At least 8 characters'.tr},
    {
      'select': false,
      'title': 'A mixture of both uppercase and lowercase letter.'.tr
    },
    {'select': false, 'title': 'A mixture of letters and numbers.'.tr},
    {
      'select': false,
      'title': 'Inclusion of at least one spacial character. e.g.!@#?]'.tr
    },
  ];

  //settlement Screen
  List<String> withStatusFilter = [
    'Accepted',
    'Requested',
    'Rejected',
    'On Hold',
    'Cancelled'
  ];
  List<String> payOutStatusFilter = [
    'Processed',
    'Rejected',
  ];
  List<String> withTypeFilter = [
    'Manual',
    'Daily',
    'Monthly',
    'Weekly',
  ];

  //activity filter transaction
  List<String> activityTransaction = [
    'Invoice',
    'Subscription',
    'Add fund',
    'Settlement Withdrawal',
    'Wallet Transfer',
    'QR Transfer',
    'Store link',
    'PG API',
    'Mawaid',
    'Merchant Rewards',
    'SADAD Paid Services',
    'POS Transaction',
    'POS Rental',
  ];
  List<String> activityPaymentType = [
    'Payment In',
    'Payment out',
  ];

  ///activity for report

  List<String> activityTransactionType = [
    'Purchase',
    'Refund',
    'Dispute',
  ];

  List<String> activityTransactionSources = [
    'PG API',
    'Mawaid',
    'Invoice',
    'Wallet Transfer',
    'Subscription',
    'Store Link',
    'All',
  ];

  List<String> activityTransactionStatus = [
    'InProgress',
    'Failed',
    'Success',
    'On Hold',
  ];

  //transactionPaymentMethod also use here

  List<String> activityTransactionMode = [
    'Credit card',
    'Debit card',
    'Wallet'
  ];

  List<String> activityIntegrationType = [
    'Website',
    'Mobile',
  ];

  //activity filter transfer
  List<String> activityTransferType = [
    'Send',
    'Receive',
  ];
}
