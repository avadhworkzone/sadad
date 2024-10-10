class LiveTerminalMapResponseModel {
  var terminalId;
  var name;
  var latitude;
  var longitude;
  var deviceSerialNo;
  var zone;
  var isOnline;

  LiveTerminalMapResponseModel(
      {this.terminalId,
      this.name,
      this.latitude,
      this.longitude,
      this.deviceSerialNo,
      this.zone,
      this.isOnline});

  LiveTerminalMapResponseModel.fromJson(Map<String, dynamic> json) {
    terminalId = json['terminalId'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    deviceSerialNo = json['deviceSerialNo'];
    zone = json['zone'];
    isOnline = json['is_online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['terminalId'] = this.terminalId;
    data['name'] = this.name;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['deviceSerialNo'] = this.deviceSerialNo;
    data['zone'] = this.zone;
    data['is_online'] = this.isOnline;
    return data;
  }
}
