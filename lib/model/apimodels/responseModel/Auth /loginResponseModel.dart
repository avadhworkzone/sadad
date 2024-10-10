class LoginResponseModel {
  var id;
  var ttl;
  var created;
  var userId;
  var receiveotpvia;

  LoginResponseModel(
      {this.id, this.ttl, this.created, this.userId, this.receiveotpvia});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ttl = json['ttl'];
    created = json['created'];
    userId = json['userId'];
    receiveotpvia = json['receiveotpvia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ttl'] = this.ttl;
    data['created'] = this.created;
    data['userId'] = this.userId;
    data['receiveotpvia'] = this.receiveotpvia;
    return data;
  }
}
