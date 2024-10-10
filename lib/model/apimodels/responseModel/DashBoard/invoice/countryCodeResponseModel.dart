class CountryCodeResponseModel {
  var countryIsoCode;
  var status;
  var countryname;
  var countrycode;
  var codelength;
  bool? statusFullMerchant;
  bool? statusSubscriber;
  var countryIsoCodeFull;
  var id;
  var regionid;

  CountryCodeResponseModel(
      {this.countryIsoCode,
      this.status,
      this.countryname,
      this.countrycode,
      this.codelength,
      this.statusFullMerchant,
      this.statusSubscriber,
      this.countryIsoCodeFull,
      this.id,
      this.regionid});

  CountryCodeResponseModel.fromJson(Map<String, dynamic> json) {
    countryIsoCode = json['countryIsoCode'];
    status = json['status'];
    countryname = json['countryname'];
    countrycode = json['countrycode'];
    codelength = json['codelength'];
    statusFullMerchant = json['status_full_merchant'];
    statusSubscriber = json['status_subscriber'];
    countryIsoCodeFull = json['countryIsoCodeFull'];
    id = json['id'];
    regionid = json['regionid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countryIsoCode'] = this.countryIsoCode;
    data['status'] = this.status;
    data['countryname'] = this.countryname;
    data['countrycode'] = this.countrycode;
    data['codelength'] = this.codelength;
    data['status_full_merchant'] = this.statusFullMerchant;
    data['status_subscriber'] = this.statusSubscriber;
    data['countryIsoCodeFull'] = this.countryIsoCodeFull;
    data['id'] = this.id;
    data['regionid'] = this.regionid;
    return data;
  }
}
