class Utility {
  static List<Map<String, dynamic>> selectedProductData = [];
  static String countryCode = 'QA';
  static String baseUrl = 'http://176.58.99.102:3001/api-v1/'; //Dev
  //static String baseUrl = 'https://api.sadadqatar.com/api-v5/';//Live
  // static String baseUrl =
  //     'https://aks-api.sadadqatar.com/api-v5/'; //PreProduction

  static String countryCodeNumber = '+974';
  static String mobNo = '';
  static String userPhone = '';
  static String userId = '';
  static String sadadIdMore = '';
  static String deviceId = '';
  static String profilePic = '';
  static int androidVersion = 0;

  static String name = '';
  static String custNo = '';
  static String description = '';
  static String invoiceStatusId = '';
  static bool isDescription = false;
  static bool isNotify = false;
  static bool isFastInvoice = false;
  static double startRange = 0;
  static double endRange = 0;
  static String filterSorted = '&filter[order]=created DESC';
  static String orderDeliverStatus = '';
  static int holdFilterSorted = 4;
  static double holdStartRange = 0;
  static String password = '';

  static double holdEndRange = 20000;
  static String transactionFilterSorted = 'created DESC';
  static String transactionFilterStatus = '';
  static String transactionFilterIntegrationType = '';
  static String transactionFilterPaymentMethod = '';
  static String transactionFilterTransactionModes = '';
  static String transactionFilterTransactionType = '';
  static String transactionFilterTransactionSources = '';
  static String refundedFilterStatus = '';
  static String refundedFilterPaymentMethod = '';
  static String refundedFilterTransactionModes = '';
  static String disputeStatusFilter = '';
  static String disputeTypeFilter = '';
  static bool isCreateImageUploadEmpty = true;
  static bool isDisputeDetailTransaction = false;
  static bool isNotificationResEmpty = false;

  //terminal screen pos
  static String terminalFilterTransStatus = '';
  static String terminalFilterStartActivationDate = '';
  static String terminalFilterEndActivationDate = '';
  static String terminalFilterDeviceStatus = '';
  static String terminalFilterPaymentMethod = '';
  static String terminalFilterTransModes = '';
  static String terminalCountFilterTransStatus = '';
  static String terminalCountFilterPaymentMethod = '';
  static String terminalCountFilterTransModes = '';
  static String terminalCountFilterDeviceStatus = '';
  static String terminalCountFilterStartActivationDate = '';
  static String terminalCountFilterEndActivationDate = '';

  //invoice filter

  static String onlineInvoiceFilterStatus = '';
  static String holdOnlineInvoiceFilterStatus = '';

  //device screen pos
  static String deviceFilterDeviceStatus = '';
  static String deviceFilterDeviceType = '';
  static String deviceFilterCountDeviceStatus = '';
  static String deviceFilterCountDeviceType = '';
  //pos transaction filter
  static String posPaymentTransactionStatusFilter = '';
  static String posPaymentPaymentMethodFilter = '';
  static String posPaymentTransactionModesFilter = '';
  static String posPaymentTransactionTypeFilter = '';
  static List posPaymentTransactionTypeTerminalFilter = [];
  static List holdPosPaymentTransactionTypeTerminalFilter = [];
  static String posPaymentCardEntryTypeFilter = '';
  static List<dynamic> posPaymentTerminalSelectionFilter = [];
  static List<dynamic> posRentalPaymentTerminalSelectionFilter = [];
  static String holdPosPaymentTransactionStatusFilter = '';
  static String holdPosPaymentPaymentMethodFilter = '';
  static String holdPosPaymentTransactionModesFilter = '';
  static List holdPosPaymentTransactionTypeFilter = [];
  static String holdPosPaymentCardEntryTypeFilter = '';
  static List<dynamic> holdPosPaymentTerminalSelectionFilter = [];
  static List<dynamic> holdPosRentalPaymentTerminalSelectionFilter = [];

  //pos refund filter
  static String posRefundTransactionStatusFilter = '';
  static String posRefundPaymentMethodFilter = '';
  static String posRefundTransactionModesFilter = '';
  static String posRefundCardEntryTypeFilter = '';
  static String holdPosRefundTransactionStatusFilter = '';
  static String holdPosRefundPaymentMethodFilter = '';
  static String holdPosRefundTransactionModesFilter = '';
  static String holdPosRefundCardEntryTypeFilter = '';
  //pos rental filter
  static String posDisputeTransactionStatusFilter = '';
  static String posDisputeTransactionTypeFilter = '';
  static String holdPosDisputeTransactionStatusFilter = '';
  static String holdPosDisputeTransactionTypeFilter = '';
  //pos payment status filter
  static String posRentalPaymentStatusFilter = '';
  static String holdPosRentalPaymentStatusFilter = '';
  //pos report filter
  static String posReportPaymentMethodFilter = '';
  static String posReportTransactionStatusFilter = '';
  static String posReportDisputesStatusFilter = '';
  static String posReportRefundStatusFilter = '';
  static String posReportDeviceTypeFilter = '';
  static String posReportDeviceStatusFilter = '';
  static String posReportTransactionModesFilter = '';
  static String posReportTransactionTypeFilter = '';
  static String posReportCardEntryTypeFilter = '';
  //payment product
  static String viewBy = '';
  static int productViewBy = 0;
  static String sortBy = '';
  static int holdViewBy = 4;
  static int holdSortBy = 6;
  static String productPrice = '';
  static String countViewBy = '';
  static String countSortBy = '';
  static String countProductPrice = '';
  //settlement screen
  static String settlementWithdrawPeriod = '';
  static bool settlementWithdrawPeriodAlready = false;
  static String settlementWithdrawFilterStatus = '';
  static String settlementWithdrawFilterType = '';
  static String settlementPayoutFilterStatus = '';
  static String settlementPayoutFilterBank = '';
  static String holdSettlementWithdrawFilterStatus = '';
  static String holdSettlementWithdrawFilterType = '';
  static String holdSettlementPayoutFilterStatus = '';
  static String holdSettlementPayoutFilterBank = '';
  //Activity report settlement screen
  static String activityReportSettlementWithdrawPeriod = '';
  static bool activityReportSettlementWithdrawPeriodAlready = false;
  static String activityReportSettlementWithdrawFilterStatus = '';
  static String activityReportSettlementWithdrawFilterType = '';
  static String activityReportSettlementPayoutFilterStatus = '';
  static String activityReportSettlementPayoutFilterBank = '';
  static String activityReportGetSubUSer = '';
  static String activityReportHoldGetSubUSer = '';
  static String activityReportHoldGetSubUSerId = '';
  static String activityReportHoldSettlementWithdrawFilterStatus = '';
  static String activityReportHoldSettlementWithdrawFilterType = '';
  static String activityReportHoldSettlementPayoutFilterStatus = '';
  static String activityReportHoldSettlementPayoutFilterBank = '';

  //transaction hold

  static String holdRefundedFilterStatus = '';
  static String holdTransactionFilterStatus = '';
  static String holdTransactionFilterIntegrationType = '';
  static String holdDeviceFilterStatus = '';
  static String holdTransactionFilterPaymentMethod = '';
  static String holdTransactionFilterTransactionModes = '';
  static String holdTransactionFilterTransactionSources = '';
  static String holdTransactionFilterTransactionType = '';
  static String holdRefundedFilterPaymentMethod = '';
  static String holdRefundedFilterTransactionModes = '';
  static String holdDisputeStatusFilter = '';
  static String holdDisputeTypeFilter = '';

  //terminal hold
  static String holdTerminalActivationStartDate = '';
  static String holdTerminalActivationEndDate = '';
  //pos device hold
  static String holdDeviceFilterDeviceStatus = '';
  static String holdDeviceFilterDeviceType = '';

  //filter transaction screen
  static String holdActivityTransactionSources = '';
  static String holdActivityPaymentType = '';
  static String activityTransactionSources = '';
  static String activityPaymentType = '';

  /// More Screen
  static int userbusinessstatus = 0;

  //activity transaction filter report
  static String activityTransactionReportTransactionTypeFilter = '';
  static String activityTransactionReportTransactionSourceFilter = '';
  static String activityTransactionReportTransactionStatusFilter = '';
  static String activityTransactionReportPaymentMethodFilter = '';
  static String activityTransactionReportTransactionModeFilter = '';
  static String activityTransactionReportIntegrationTypeFilter = '';
  static String holdActivityTransactionReportTransactionTypeFilter = '';
  static String holdActivityTransactionReportTransactionSourceFilter = '';
  static String holdActivityTransactionReportTransactionStatusFilter = '';
  static String holdActivityTransactionReportPaymentMethodFilter = '';
  static String holdActivityTransactionReportTransactionModeFilter = '';
  static String holdActivityTransactionReportIntegrationTypeFilter = '';

  //activity transfer filter report
  static String holdActivityTransferReportTransferTypeFilter = '';
  static String activityTransferReportTransferTypeFilter = '';
}
