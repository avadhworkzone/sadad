import 'dart:math';

import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlemetPayoutListResponseModel.dart';

class SubMerchantModel {
  String? profilepic;
  String? sadadId;
  String? name;
  int? parentmerchantId;
  int? linkmerchantverificationstatusId;
  bool? submerchantDefault;
  String? cellnumber;
  String? linkedAt;
  String? email;
  int? id;
  int? roleId;
  List<Userbusinesses>? userbusinesses;
  Usermetapreference? usermetapreference;
  Usermetapersonals? usermetapersonals;
  List<Userbanks>? userbanks;


  SubMerchantModel(
      {this.sadadId,
        this.profilepic,
        this.name,
        this.parentmerchantId,
        this.linkmerchantverificationstatusId,
        this.submerchantDefault,
        this.cellnumber,
        this.linkedAt,
        this.email,
        this.id,
        this.roleId,
        this.userbusinesses,
        this.usermetapersonals,
        this.usermetapreference,
      this.userbanks});


  SubMerchantModel.fromJson(Map<String, dynamic> json) {
    sadadId = json['SadadId'];
    profilepic = json['profilepic'];
    name = json['name'];
    parentmerchantId = json['parentmerchantId'];
    linkmerchantverificationstatusId = json['linkmerchantverificationstatusId'];
    submerchantDefault = json['submerchantDefault'];
    cellnumber = json['cellnumber'];
    linkedAt = json['linkedAt'];
    email = json['email'];
    id = json['id'];
    roleId = json['roleId'];
    if (json['userbusinesses'] != null) {
      userbusinesses = <Userbusinesses>[];
      json['userbusinesses'].forEach((v) {
        userbusinesses!.add(new Userbusinesses.fromJson(v));
      });
    }
    if (json['userbanks'] != null) {
      userbanks = <Userbanks>[];
      json['userbanks'].forEach((v) {
        userbanks!.add(new Userbanks.fromJson(v));
      });
    }
    usermetapreference = json['usermetapreference'] != null
        ? new Usermetapreference.fromJson(json['usermetapreference'])
        : null;
    usermetapersonals = json['usermetapersonals'] != null
        ? new Usermetapersonals.fromJson(json['usermetapersonals'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SadadId'] = this.sadadId;
    data['profilepic'] = this.profilepic;
    data['name'] = this.name;
    data['parentmerchantId'] = this.parentmerchantId;
    data[''] = this.linkmerchantverificationstatusId;
    data['submerchantDefault'] = this.submerchantDefault;
    data['cellnumber'] = this.cellnumber;
    data['linkedAt'] = this.linkedAt;
    data['email'] = this.email;
    data['id'] = this.id;
    data['roleId'] = this.roleId;
    if (this.userbusinesses != null) {
      data['userbusinesses'] =
          this.userbusinesses!.map((v) => v.toJson()).toList();
    }
    if (this.usermetapreference != null) {
      data['usermetapreference'] = this.usermetapreference!.toJson();
    }
    if (this.usermetapersonals != null) {
      data['usermetapersonals'] = this.usermetapersonals!.toJson();
    }
    return data;
  }
}
class Userbusinesses {
  int? id;
  int? userId;
  int? userbusinessstatusId;
  String? merchantregisterationnumber;
  Userbusinessstatus? userbusinessstatus;

  Userbusinesses(
      {this.id,
        this.userId,
        this.userbusinessstatusId,this.merchantregisterationnumber,
        this.userbusinessstatus});

  Userbusinesses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userbusinessstatusId = json['userbusinessstatusId'];
    merchantregisterationnumber = json['merchantregisterationnumber'] ?? "NA";
    userbusinessstatus = json['userbusinessstatus'] != null
        ? new Userbusinessstatus.fromJson(json['userbusinessstatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['userbusinessstatusId'] = this.userbusinessstatusId;
    data['merchantregisterationnumber'] = this.merchantregisterationnumber;
    if (this.userbusinessstatus != null) {
      data['userbusinessstatus'] = this.userbusinessstatus!.toJson();
    }
    return data;
  }
}


class Userbanks {
  String? ibannumber;
  String? authorizationdetails;
  bool? primary;
  int? userId;
  String? created;
  String? modified;
  int? userbankstatusId;
  int? bankId;
  Userbusinessstatus? userbankstatus;

  Userbanks(
      {this.ibannumber,
        this.authorizationdetails,
        this.primary,
        this.userId,this.created,this.modified,this.userbankstatusId,this.bankId,this.userbankstatus});

  Userbanks.fromJson(Map<String, dynamic> json) {
    ibannumber = json['ibannumber'];
    authorizationdetails = json['authorizationdetails'];
    primary = json['primary'];
    userId = json['userId'];
    created = json['created'];
    modified = json['modified'];
    userbankstatusId = json['userbankstatusId'];
    bankId = json['bankId'];
    userbankstatus = json['userbankstatus'] != null
        ? new Userbusinessstatus.fromJson(json['userbankstatus'])
        : null;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ibannumber'] = this.ibannumber;
    data['authorizationdetails'] = this.authorizationdetails;
    data['primary'] = this.primary;
    data['userId'] = this.userId;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['userbankstatusId'] = this.userbankstatusId;
    data['bankId'] = this.bankId;
    if (this.userbankstatus != null) {
      data['userbankstatus'] = this.userbankstatus!.toJson();
    }
    return data;
  }
}


class Userbusinessstatus {
  String? name;
  int? id;

  Userbusinessstatus({this.name, this.id});

  Userbusinessstatus.fromJson(Map<String, dynamic> json) {
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

class Usermetapreference {
  String? lastlogindatetime;
  int? userId;

  Usermetapreference({this.lastlogindatetime, this.userId});

  Usermetapreference.fromJson(Map<String, dynamic> json) {
    lastlogindatetime = json['lastlogindatetime'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastlogindatetime'] = this.lastlogindatetime;
    data['userId'] = this.userId;
    return data;
  }
}
class Usermetapersonals {
  num? totalavailablefunds;
  int? userId;

  Usermetapersonals({this.totalavailablefunds, this.userId});

  Usermetapersonals.fromJson(Map<String, dynamic> json) {
    totalavailablefunds = json['totalavailablefunds'] ?? 0.0;
    totalavailablefunds = decimalPlaces(totalavailablefunds!,2);
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalavailablefunds'] = this.totalavailablefunds;
    data['userId'] = this.userId;
    return data;
  }
}
num decimalPlaces(num val, int places){
  num mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}
