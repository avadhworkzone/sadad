// class TerminalDetailResponseModel {
//   var terminalId;
//   var name;
//   var buildingNumber;
//   var streetNumber;
//   var city;
//   var zoneNumber;
//   var zone;
//   var postalCode;
//   var latitude;
//   var longitude;
//   var status;
//   var terminalStatus;
//   var lastUpdateBy;
//   var deviceSerialNo;
//   var deviceId;
//   var rentalPlanId;
//   var rentalStartDate;
//   var simNumber;
//   var installFee;
//   var activated;
//   var deactivated;
//   var objectId;
//   var syncedAt;
//   var sadadID;
//   var previousDeviceSerialNo;
//   var previousDeviceId;
//   bool? isActive;
//   var isOnline;
//   var locationAPICalledAt;
//   var terminaltype;
//   var location;
//   var loginId;
//   var id;
//   var created;
//   var devicetypeId;
//   var lastTransactionDate;
//   var cardType;
//   var cardEntryType;
//   var totalSuccessTransactionCount;
//   var totalSuccessTransactionAmount;
//   var currency;
//   var terminalType;
//   var paymentMethod;
//   Posdevice? posdevice;
//
//   TerminalDetailResponseModel(
//       {this.terminalId,
//       this.name,
//       this.buildingNumber,
//       this.streetNumber,
//       this.city,
//       this.zoneNumber,
//       this.zone,
//       this.postalCode,
//       this.latitude,
//       this.longitude,
//       this.status,
//       this.terminalStatus,
//       this.lastUpdateBy,
//       this.deviceSerialNo,
//       this.deviceId,
//       this.rentalPlanId,
//       this.rentalStartDate,
//       this.simNumber,
//       this.installFee,
//       this.activated,
//       this.deactivated,
//       this.objectId,
//       this.syncedAt,
//       this.sadadID,
//       this.previousDeviceSerialNo,
//       this.previousDeviceId,
//       this.isActive,
//       this.isOnline,
//       this.locationAPICalledAt,
//       this.terminaltype,
//       this.location,
//       this.loginId,
//       this.id,
//       this.created,
//       this.devicetypeId,
//       this.lastTransactionDate,
//       this.cardType,
//       this.cardEntryType,
//       this.totalSuccessTransactionCount,
//       this.totalSuccessTransactionAmount,
//       this.currency,
//       this.terminalType,
//       this.paymentMethod,
//       this.posdevice});
//
//   TerminalDetailResponseModel.fromJson(Map<String, dynamic> json) {
//     terminalId = json['terminalId'];
//     name = json['name'];
//     buildingNumber = json['buildingNumber'];
//     streetNumber = json['streetNumber'];
//     city = json['city'];
//     zoneNumber = json['zoneNumber'];
//     zone = json['zone'];
//     postalCode = json['postalCode'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     status = json['status'];
//     terminalStatus = json['terminalStatus'];
//     lastUpdateBy = json['lastUpdateBy'];
//     deviceSerialNo = json['deviceSerialNo'];
//     deviceId = json['deviceId'];
//     rentalPlanId = json['rentalPlanId'];
//     rentalStartDate = json['rentalStartDate'];
//     simNumber = json['simNumber'];
//     installFee = json['installFee'];
//     activated = json['activated'];
//     deactivated = json['deactivated'];
//     objectId = json['objectId'];
//     syncedAt = json['syncedAt'];
//     sadadID = json['SadadID'];
//     previousDeviceSerialNo = json['previousDeviceSerialNo'];
//     previousDeviceId = json['previousDeviceId'];
//     isActive = json['is_active'];
//     isOnline = json['is_online'];
//     locationAPICalledAt = json['locationAPICalledAt'];
//     location = json['location'];
//     loginId = json['loginId'];
//     terminaltype = json['terminaltype'];
//     id = json['id'];
//     created = json['created'];
//     devicetypeId = json['devicetypeId'];
//     lastTransactionDate = json['lastTransactionDate'];
//     cardType = json['card_type'];
//     cardEntryType = json['card_entry_type'];
//     totalSuccessTransactionCount = json['totalSuccessTransactionCount'];
//     totalSuccessTransactionAmount = json['totalSuccessTransactionAmount'];
//     currency = json['currency'];
//     terminalType = json['terminalType'];
//     paymentMethod = json['payment_method'];
//     posdevice = json['posdevice'] != null
//         ? new Posdevice.fromJson(json['posdevice'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['terminalId'] = this.terminalId;
//     data['name'] = this.name;
//     data['buildingNumber'] = this.buildingNumber;
//     data['streetNumber'] = this.streetNumber;
//     data['city'] = this.city;
//     data['zoneNumber'] = this.zoneNumber;
//     data['zone'] = this.zone;
//     data['postalCode'] = this.postalCode;
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     data['status'] = this.status;
//     data['terminalStatus'] = this.terminalStatus;
//     data['lastUpdateBy'] = this.lastUpdateBy;
//     data['deviceSerialNo'] = this.deviceSerialNo;
//     data['deviceId'] = this.deviceId;
//     data['rentalPlanId'] = this.rentalPlanId;
//     data['rentalStartDate'] = this.rentalStartDate;
//     data['simNumber'] = this.simNumber;
//     data['installFee'] = this.installFee;
//     data['activated'] = this.activated;
//     data['deactivated'] = this.deactivated;
//     data['objectId'] = this.objectId;
//     data['syncedAt'] = this.syncedAt;
//     data['SadadID'] = this.sadadID;
//     data['previousDeviceSerialNo'] = this.previousDeviceSerialNo;
//     data['previousDeviceId'] = this.previousDeviceId;
//     data['is_active'] = this.isActive;
//     data['is_online'] = this.isOnline;
//     data['locationAPICalledAt'] = this.locationAPICalledAt;
//     data['location'] = this.location;
//     data['loginId'] = this.loginId;
//     data['terminaltype'] = this.terminaltype;
//     data['id'] = this.id;
//     data['created'] = this.created;
//     data['devicetypeId'] = this.devicetypeId;
//     data['lastTransactionDate'] = this.lastTransactionDate;
//     data['card_type'] = this.cardType;
//     data['card_entry_type'] = this.cardEntryType;
//     data['totalSuccessTransactionCount'] = this.totalSuccessTransactionCount;
//     data['totalSuccessTransactionAmount'] = this.totalSuccessTransactionAmount;
//     data['currency'] = this.currency;
//     data['terminalType'] = this.terminalType;
//     data['payment_method'] = this.paymentMethod;
//     if (this.posdevice != null) {
//       data['posdevice'] = this.posdevice!.toJson();
//     }
//     return data;
//   }
// }
//
// class Posdevice {
//   var serial;
//   var deviceId;
//   var devicetype;
//   var imei;
//   var lastlocation;
//   var lastactivetime;
//   var id;
//   var deletedAt;
//   var created;
//   var modified;
//   var mainmerchantId;
//
//   Posdevice(
//       {this.serial,
//       this.deviceId,
//       this.devicetype,
//       this.imei,
//       this.lastlocation,
//       this.lastactivetime,
//       this.id,
//       this.deletedAt,
//       this.created,
//       this.modified,
//       this.mainmerchantId});
//
//   Posdevice.fromJson(Map<String, dynamic> json) {
//     serial = json['serial'];
//     deviceId = json['deviceId'];
//     devicetype = json['devicetype'];
//     imei = json['imei'];
//     lastlocation = json['lastlocation'];
//     lastactivetime = json['lastactivetime'];
//     id = json['id'];
//     deletedAt = json['deletedAt'];
//     created = json['created'];
//     modified = json['modified'];
//     mainmerchantId = json['mainmerchantId'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['serial'] = this.serial;
//     data['deviceId'] = this.deviceId;
//     data['devicetype'] = this.devicetype;
//     data['imei'] = this.imei;
//     data['lastlocation'] = this.lastlocation;
//     data['lastactivetime'] = this.lastactivetime;
//     data['id'] = this.id;
//     data['deletedAt'] = this.deletedAt;
//     data['created'] = this.created;
//     data['modified'] = this.modified;
//     data['mainmerchantId'] = this.mainmerchantId;
//     return data;
//   }
// }

class TerminalDetailResponseModel {
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
  var rentalThreshold;
  var simNumber;
  var installFee;
  var activated;
  var deactivated;
  var objectId;
  var syncedAt;
  var sadadID;
  var previousDeviceSerialNo;
  var previousDeviceId;
  var isActive;
  var isOnline;
  var locationAPICalledAt;
  var terminaltype;
  var location;
  var loginId;
  var id;
  var created;
  var devicetypeId;
  var lastTransactionDate;
  var cardType;
  var cardEntryType;
  var totalSuccessTransactionCount;
  var totalSuccessTransactionAmount;
  var currency;
  var terminalType;
  var paymentMethod;
  Posdevice? posdevice;
  RentalPlan? rentalPlan;
  RentalDetail? rentalDetail;
  List<Terminaldevicehistory>? terminaldevicehistory;
  TerminalDetailResponseModel(
      {this.terminalId,
      this.name,
      this.buildingNumber,
      this.streetNumber,
      this.city,
      this.zoneNumber,
      this.zone,
      this.terminaldevicehistory,
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
      this.rentalThreshold,
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
      this.location,
      this.loginId,
      this.id,
      this.created,
      this.devicetypeId,
      this.lastTransactionDate,
      this.cardType,
      this.cardEntryType,
      this.totalSuccessTransactionCount,
      this.totalSuccessTransactionAmount,
      this.currency,
      this.terminalType,
      this.paymentMethod,
      this.posdevice,
      this.rentalPlan,
      this.rentalDetail});

  TerminalDetailResponseModel.fromJson(Map<String, dynamic> json) {
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
    rentalThreshold = json['rentalThreshold'];
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
    location = json['location'];
    loginId = json['loginId'];
    id = json['id'];
    created = json['created'];
    devicetypeId = json['devicetypeId'];
    lastTransactionDate = json['lastTransactionDate'];
    cardType = json['card_type'];
    cardEntryType = json['card_entry_type'];
    totalSuccessTransactionCount = json['totalSuccessTransactionCount'];
    totalSuccessTransactionAmount = json['totalSuccessTransactionAmount'];
    currency = json['currency'];
    terminalType = json['terminalType'];
    paymentMethod = json['payment_method'];
    posdevice = json['posdevice'] != null
        ? new Posdevice.fromJson(json['posdevice'])
        : null;
    rentalPlan = json['rentalPlan'] != null
        ? new RentalPlan.fromJson(json['rentalPlan'])
        : null;
    rentalDetail = json['rentalDetail'] != null
        ? new RentalDetail.fromJson(json['rentalDetail'])
        : null;
    if (json['terminaldevicehistory'] != null) {
      terminaldevicehistory = <Terminaldevicehistory>[];
      json['terminaldevicehistory'].forEach((v) {
        terminaldevicehistory!.add(new Terminaldevicehistory.fromJson(v));
      });
    }
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
    data['rentalThreshold'] = this.rentalThreshold;
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
    data['location'] = this.location;
    data['loginId'] = this.loginId;
    data['id'] = this.id;
    data['created'] = this.created;
    data['devicetypeId'] = this.devicetypeId;
    data['lastTransactionDate'] = this.lastTransactionDate;
    data['card_type'] = this.cardType;
    data['card_entry_type'] = this.cardEntryType;
    data['totalSuccessTransactionCount'] = this.totalSuccessTransactionCount;
    data['totalSuccessTransactionAmount'] = this.totalSuccessTransactionAmount;
    data['currency'] = this.currency;
    data['terminalType'] = this.terminalType;
    data['payment_method'] = this.paymentMethod;
    if (this.posdevice != null) {
      data['posdevice'] = this.posdevice!.toJson();
    }
    if (this.rentalPlan != null) {
      data['rentalPlan'] = this.rentalPlan!.toJson();
    }
    if (this.rentalDetail != null) {
      data['rentalDetail'] = this.rentalDetail!.toJson();
    }
    if (this.terminaldevicehistory != null) {
      data['terminaldevicehistory'] =
          this.terminaldevicehistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Posdevice {
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
  var mainmerchantId;

  Posdevice(
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
      this.mainmerchantId});

  Posdevice.fromJson(Map<String, dynamic> json) {
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
    mainmerchantId = json['mainmerchantId'];
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
    data['mainmerchantId'] = this.mainmerchantId;
    return data;
  }
}

class RentalPlan {
  var planId;
  var planName;
  var amount;
  var frequency;
  var additionalCharges;
  var chargeReason;
  bool? status;
  var syncedAt;
  var objectId;
  var id;
  var deletedAt;
  var created;
  var modified;

  RentalPlan(
      {this.planId,
      this.planName,
      this.amount,
      this.frequency,
      this.additionalCharges,
      this.chargeReason,
      this.status,
      this.syncedAt,
      this.objectId,
      this.id,
      this.deletedAt,
      this.created,
      this.modified});

  RentalPlan.fromJson(Map<String, dynamic> json) {
    planId = json['planId'];
    planName = json['planName'];
    amount = json['amount'];
    frequency = json['frequency'];
    additionalCharges = json['additionalCharges'];
    chargeReason = json['chargeReason'];
    status = json['status'];
    syncedAt = json['syncedAt'];
    objectId = json['objectId'];
    id = json['id'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['planId'] = this.planId;
    data['planName'] = this.planName;
    data['amount'] = this.amount;
    data['frequency'] = this.frequency;
    data['additionalCharges'] = this.additionalCharges;
    data['chargeReason'] = this.chargeReason;
    data['status'] = this.status;
    data['syncedAt'] = this.syncedAt;
    data['objectId'] = this.objectId;
    data['id'] = this.id;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    data['modified'] = this.modified;
    return data;
  }
}

class RentalDetail {
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

  RentalDetail(
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
      this.modified});

  RentalDetail.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class Terminaldevicehistory {
  var terminalId;
  var deviceSerialNo;
  var deviceActivationDate;
  var deviceDeactivationDate;
  var simNumber;
  var imeiNumber;
  var rentalStartDate;
  var deviceRentalAmount;
  var deviceTypeId;
  var setupFees;
  var createdby;
  var modifiedby;
  var id;
  var deletedAt;

  Terminaldevicehistory(
      {this.terminalId,
      this.deviceSerialNo,
      this.deviceActivationDate,
      this.deviceDeactivationDate,
      this.simNumber,
      this.imeiNumber,
      this.deviceTypeId,
      this.rentalStartDate,
      this.deviceRentalAmount,
      this.setupFees,
      this.createdby,
      this.modifiedby,
      this.id,
      this.deletedAt});

  Terminaldevicehistory.fromJson(Map<String, dynamic> json) {
    terminalId = json['terminalId'];
    deviceSerialNo = json['deviceSerialNo'];
    deviceActivationDate = json['deviceActivationDate'];
    deviceDeactivationDate = json['deviceDeactivationDate'];
    simNumber = json['simNumber'];
    imeiNumber = json['imeiNumber'];
    deviceTypeId = json['deviceTypeId'];
    rentalStartDate = json['rentalStartDate'];
    deviceRentalAmount = json['deviceRentalAmount'];
    setupFees = json['setupFees'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    id = json['id'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['terminalId'] = this.terminalId;
    data['deviceSerialNo'] = this.deviceSerialNo;
    data['deviceActivationDate'] = this.deviceActivationDate;
    data['deviceDeactivationDate'] = this.deviceDeactivationDate;
    data['simNumber'] = this.simNumber;
    data['imeiNumber'] = this.imeiNumber;
    data['deviceTypeId'] = this.deviceTypeId;
    data['rentalStartDate'] = this.rentalStartDate;
    data['deviceRentalAmount'] = this.deviceRentalAmount;
    data['setupFees'] = this.setupFees;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['id'] = this.id;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}
