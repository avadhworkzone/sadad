class AdsListResponseModel {
  var filename;
  var description;
  var createdby;
  bool? isPublished;
  var publishedDate;
  var userType;
  var id;
  var created;
  var modified;

  AdsListResponseModel(
      {this.filename,
      this.description,
      this.createdby,
      this.isPublished,
      this.publishedDate,
      this.userType,
      this.id,
      this.created,
      this.modified});

  AdsListResponseModel.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    description = json['description'];
    createdby = json['createdby'];
    isPublished = json['isPublished'];
    publishedDate = json['publishedDate'];
    userType = json['userType'];
    id = json['id'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filename'] = this.filename;
    data['description'] = this.description;
    data['createdby'] = this.createdby;
    data['isPublished'] = this.isPublished;
    data['publishedDate'] = this.publishedDate;
    data['userType'] = this.userType;
    data['id'] = this.id;
    data['created'] = this.created;
    data['modified'] = this.modified;
    return data;
  }
}
