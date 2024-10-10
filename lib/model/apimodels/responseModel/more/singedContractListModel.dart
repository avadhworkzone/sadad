class SignedContractListModel {
  var type;
  var description;
  var is_default;
  var file_name;
  var createdby;
  var modifiedby;
  var id;
  var userId;
  var deletedAt;

  SignedContractListModel(
      {this.type,
        this.description,
        this.is_default,
        this.file_name,
        this.createdby,
        this.modifiedby,
        this.id,
        this.userId,
        this.deletedAt});

  SignedContractListModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    description = json['description'];
    is_default = json['is_default'];
    file_name = json['file_name'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    id = json['id'];
    userId = json['userId'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['description'] = this.description;
    data['is_default'] = this.is_default;
    data['file_name'] = this.file_name;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}