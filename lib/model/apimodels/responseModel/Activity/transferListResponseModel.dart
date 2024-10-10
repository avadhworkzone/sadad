class ActivityTransferListResponse {
  var receiverId;
  var name;
  var profilepic;
  var cellnumber;
  var roleId;

  ActivityTransferListResponse(
      {this.receiverId,
      this.name,
      this.profilepic,
      this.cellnumber,
      this.roleId});

  ActivityTransferListResponse.fromJson(Map<String, dynamic> json) {
    receiverId = json['receiverId'];
    name = json['name'];
    profilepic = json['profilepic'];
    cellnumber = json['cellnumber'];
    roleId = json['roleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receiverId'] = this.receiverId;
    data['name'] = this.name;
    data['profilepic'] = this.profilepic;
    data['cellnumber'] = this.cellnumber;
    data['roleId'] = this.roleId;
    return data;
  }
}
