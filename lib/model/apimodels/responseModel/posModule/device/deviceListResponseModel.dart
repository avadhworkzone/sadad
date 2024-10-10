class DeviceListResponseModel {
  var serial;
  var deviceId;
  var devicetype;
  var imei;
  var lastlocation;
  var lastactivetime;
  var id;
  var deletedAt;
  var created;
  var modified;
  var deviceActivationDate;
  var deviceSubscriptionCreatedAt;
  var rentalStartDate;
  var totalPaidInstallments;
  bool? isRecurringRentalDeductionEnabled;
  var deviceRentalAmount;
  var deviceAdditionalCharges;
  var deviceAdditionalChargesReason;
  var lastTransactionDate;
  var totalSuccessTransactionCount;
  var totalSuccessTransactionAmount;
  var currency;
  var mainmerchantId;
  Terminal? terminal;

  DeviceListResponseModel(
      {this.serial,
      this.deviceId,
      this.devicetype,
      this.imei,
      this.lastlocation,
      this.lastactivetime,
      this.id,
      this.deletedAt,
      this.created,
      this.modified,
      this.deviceActivationDate,
      this.deviceSubscriptionCreatedAt,
      this.rentalStartDate,
      this.totalPaidInstallments,
      this.isRecurringRentalDeductionEnabled,
      this.deviceRentalAmount,
      this.deviceAdditionalCharges,
      this.deviceAdditionalChargesReason,
      this.lastTransactionDate,
      this.totalSuccessTransactionCount,
      this.totalSuccessTransactionAmount,
      this.currency,
      this.mainmerchantId,
      this.terminal});

  DeviceListResponseModel.fromJson(Map<String, dynamic> json) {
    serial = json['serial'];
    deviceId = json['deviceId'];
    devicetype = json['devicetype'];
    imei = json['imei'];
    lastlocation = json['lastlocation'];
    lastactivetime = json['lastactivetime'];
    id = json['id'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    modified = json['modified'];
    deviceActivationDate = json['deviceActivationDate'];
    deviceSubscriptionCreatedAt = json['deviceSubscriptionCreatedAt'];
    rentalStartDate = json['rental_start_date'];
    totalPaidInstallments = json['total_paid_installments'];
    isRecurringRentalDeductionEnabled =
        json['isRecurringRentalDeductionEnabled'];
    deviceRentalAmount = json['deviceRentalAmount'];
    deviceAdditionalCharges = json['deviceAdditionalCharges'];
    deviceAdditionalChargesReason = json['deviceAdditionalChargesReason'];
    lastTransactionDate = json['lastTransactionDate'];
    totalSuccessTransactionCount = json['totalSuccessTransactionCount'];
    totalSuccessTransactionAmount = json['totalSuccessTransactionAmount'];
    currency = json['currency'];
    mainmerchantId = json['mainmerchantId'];
    terminal = json['terminal'] != null
        ? new Terminal.fromJson(json['terminal'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serial'] = this.serial;
    data['deviceId'] = this.deviceId;
    data['devicetype'] = this.devicetype;
    data['imei'] = this.imei;
    data['lastlocation'] = this.lastlocation;
    data['lastactivetime'] = this.lastactivetime;
    data['id'] = this.id;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['deviceActivationDate'] = this.deviceActivationDate;
    data['deviceSubscriptionCreatedAt'] = this.deviceSubscriptionCreatedAt;
    data['rental_start_date'] = this.rentalStartDate;
    data['total_paid_installments'] = this.totalPaidInstallments;
    data['isRecurringRentalDeductionEnabled'] =
        this.isRecurringRentalDeductionEnabled;
    data['deviceRentalAmount'] = this.deviceRentalAmount;
    data['deviceAdditionalCharges'] = this.deviceAdditionalCharges;
    data['deviceAdditionalChargesReason'] = this.deviceAdditionalChargesReason;
    data['lastTransactionDate'] = this.lastTransactionDate;
    data['totalSuccessTransactionCount'] = this.totalSuccessTransactionCount;
    data['totalSuccessTransactionAmount'] = this.totalSuccessTransactionAmount;
    data['currency'] = this.currency;
    data['mainmerchantId'] = this.mainmerchantId;
    if (this.terminal != null) {
      data['terminal'] = this.terminal!.toJson();
    }
    return data;
  }
}

class Terminal {
  var terminalId;
  var name;
  var buildingNumber;
  var streetNumber;
  var city;
  var zoneNumber;
  var zone;
  var postalCode;
  var latitude;
  var longitude;
  var status;
  var terminalStatus;
  var lastUpdateBy;
  var deviceSerialNo;
  var deviceId;
  var rentalPlanId;
  var rentalStartDate;
  var simNumber;
  var installFee;
  var activated;
  var deactivated;
  var objectId;
  var syncedAt;
  var sadadID;
  var previousDeviceSerialNo;
  var previousDeviceId;
  bool? isActive;
  var isOnline;
  var locationAPICalledAt;
  var terminaltype;
  var id;
  var created;
  var devicetypeId;

  Terminal(
      {this.terminalId,
      this.name,
      this.buildingNumber,
      this.streetNumber,
      this.city,
      this.zoneNumber,
      this.zone,
      this.postalCode,
      this.latitude,
      this.longitude,
      this.status,
      this.terminalStatus,
      this.lastUpdateBy,
      this.deviceSerialNo,
      this.deviceId,
      this.rentalPlanId,
      this.rentalStartDate,
      this.simNumber,
      this.installFee,
      this.activated,
      this.deactivated,
      this.objectId,
      this.syncedAt,
      this.sadadID,
      this.previousDeviceSerialNo,
      this.previousDeviceId,
      this.isActive,
      this.isOnline,
      this.locationAPICalledAt,
      this.terminaltype,
      this.id,
      this.created,
      this.devicetypeId});

  Terminal.fromJson(Map<String, dynamic> json) {
    terminalId = json['terminalId'];
    name = json['name'];
    buildingNumber = json['buildingNumber'];
    streetNumber = json['streetNumber'];
    city = json['city'];
    zoneNumber = json['zoneNumber'];
    zone = json['zone'];
    postalCode = json['postalCode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    terminalStatus = json['terminalStatus'];
    lastUpdateBy = json['lastUpdateBy'];
    deviceSerialNo = json['deviceSerialNo'];
    deviceId = json['deviceId'];
    rentalPlanId = json['rentalPlanId'];
    rentalStartDate = json['rentalStartDate'];
    simNumber = json['simNumber'];
    installFee = json['installFee'];
    activated = json['activated'];
    deactivated = json['deactivated'];
    objectId = json['objectId'];
    syncedAt = json['syncedAt'];
    sadadID = json['SadadID'];
    previousDeviceSerialNo = json['previousDeviceSerialNo'];
    previousDeviceId = json['previousDeviceId'];
    isActive = json['is_active'];
    isOnline = json['is_online'];
    locationAPICalledAt = json['locationAPICalledAt'];
    terminaltype = json['terminaltype'];
    id = json['id'];
    created = json['created'];
    devicetypeId = json['devicetypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['terminalId'] = this.terminalId;
    data['name'] = this.name;
    data['buildingNumber'] = this.buildingNumber;
    data['streetNumber'] = this.streetNumber;
    data['city'] = this.city;
    data['zoneNumber'] = this.zoneNumber;
    data['zone'] = this.zone;
    data['postalCode'] = this.postalCode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['terminalStatus'] = this.terminalStatus;
    data['lastUpdateBy'] = this.lastUpdateBy;
    data['deviceSerialNo'] = this.deviceSerialNo;
    data['deviceId'] = this.deviceId;
    data['rentalPlanId'] = this.rentalPlanId;
    data['rentalStartDate'] = this.rentalStartDate;
    data['simNumber'] = this.simNumber;
    data['installFee'] = this.installFee;
    data['activated'] = this.activated;
    data['deactivated'] = this.deactivated;
    data['objectId'] = this.objectId;
    data['syncedAt'] = this.syncedAt;
    data['SadadID'] = this.sadadID;
    data['previousDeviceSerialNo'] = this.previousDeviceSerialNo;
    data['previousDeviceId'] = this.previousDeviceId;
    data['is_active'] = this.isActive;
    data['is_online'] = this.isOnline;
    data['locationAPICalledAt'] = this.locationAPICalledAt;
    data['terminaltype'] = this.terminaltype;
    data['id'] = this.id;
    data['created'] = this.created;
    data['devicetypeId'] = this.devicetypeId;
    return data;
  }
}
