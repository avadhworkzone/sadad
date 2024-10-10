abstract class BaseService<T> {
  final String baseURL = 'http://176.58.99.102:3001/api-v1/'; //Dev
  //final String baseURL = 'https://api.sadadqatar.com/api-v5/';//Live
  // final String baseURL =
  //     'https://aks-api.sadadqatar.com/api-v5/'; //PreProduction

  final String baseURLOCR = 'http://176.58.99.102:3000/api/'; //Dev
  //final String baseURLOCR = 'https://gapi.sadadqatar.com/api/';//Live
  // final String baseURLOCR =
  //     'https://aks-gapi.sadadqatar.com/api/'; //PreProduction

  final String availableBalance = 'usermetapersonals';
  final String splineChart = 'transactions/fetchTxnByCountByAmount';
  final String transactionChart = 'transactions/fetchTypeWiseAmount';
  final String paymentMethod = 'transactions/paymentMethodChart';
  final String createInvoice = 'invoices';
  final String createProducts = 'products';
  final String addProducts = 'products';
  final String getInvoice = 'invoices';
  final String invoiceReportOnline = 'reporthistories/invoiceReports';
  final String checkInternational = 'usermetapreferences';
  final String login = 'users/login';
  final String sendOtp = 'userbusinesses/sendotp';
  final String verifyOtp = 'usermetaauths/verify';
  final String invoiceCount = 'invoices/counts';
  final String resendOtp = 'usermetaauths/resendotp?type=login';
  final String productList = 'products';
  final String order = 'orders';
  final String orderReport = 'reporthistories/orderReports';
  final String uploadImageUrl = 'containers/api-product/upload';
  final String onlineTransaction = 'transactions/allTxnCounters/';
  final String transactionList = 'transactions';
  final String transactionOnlineReportList =
      'reporthistories/transactionDetailsReport';
  final String disputes = 'disputes';
  final String transactionCount = 'transactions/count';
  final String reports = 'reporthistories/';
  final String posTerminal = 'terminals';
  final String posDevices = 'posdevices';
  final String posTransaction = 'transactions';
  final String posRental = 'invoices/getPOSRentalInvoice';
  final String posPaymentCount = 'transactions/count';
  final String posDisputeCount = 'disputes/count';
  final String posReport = 'reporthistories/';
  final String posTransactionCount = 'transactions/allTxnCounters/';
  final String userMetaProfile = 'usermetapersonals';
  final String doRefundTransaction = 'transactions/sadadRefund';
  final String ecommerceCounter = 'transactions/appEcommerceCounters';
  final String posCounter = 'transactions/appPOSCounters';
  final String countryCode = 'countries?filter[where][countrycode]=';
  final String settlementWithdrawalList = 'withdrawalrequests';
  final String settlementPayoutList = 'payouts';
  final String userBankList = 'userbanks';
  final String changePassword = 'users/change-password';
  final String getBankDetail = 'userbanks?filter[where]';
  final String getBusinessInfo = 'userbusinesses?filter[where]';
  final String changeName = 'userbusinesses/';
  final String notificationInfo =
      '&filter[fields][0]=id&filter[fields][2]=receivedpaymentpush&filter[fields][3]=receivedpaymentsms&filter[fields][4]=receivedpaymentemail&filter[fields][5]=transferpush&filter[fields][6]=transfersms&filter[fields][7]=transferemail&filter[fields][8]=receivedorderspush&filter[fields][9]=receivedordersms&filter[fields][10]=receivedorderemail&filter[fields][11]=isplayasound&filter[fields][13]=isArabic&filter[fields][15]=userId';
  final String deleteAccount = 'userbanks/';
  final String addBankAccountDetail = 'userbanks';
  final String storeUserBusinessDetail = 'userbusinesses';
  final String uploadBankDocument = 'containers/api-banks/upload';
  final String uploadBusinessDocument = 'containers/api-business/upload';
  final String updateBusinessInfo = 'userbusinesses/';
  final String myAccountCounters = 'users/myAccountCounters';
  final String getBanks = 'banks';
  final String notification = 'notificationreceivers';
  final String liveTerminalMapUrl = 'terminals/mapLocation';
  final String balanceList = 'statements/balanceStatement';
  final String activityTransactionList = 'transactions';
  final String ads =
      'advertisements?filter[where][userType][inq][0]=1&filter[where][userType][inq][1]=3&filter[where][isPublished]=true';
  final String marchantAgreements = 'merchant_agreements';
  final String getSubUser = 'users/getsubuserNames';
  final String batchSummery = 'terminals/terminalBatchSummary';
  final String transactionDetailsReport =
      'reporthistories/transactionDetailsReport';
  final String posTerminalReport = 'reporthistories/posTerminalSummaryReport';
  final String posTransactionReport =
      'reporthistories/posTransactionDetailReport';
}
