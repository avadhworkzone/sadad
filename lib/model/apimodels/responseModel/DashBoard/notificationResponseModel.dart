class NotificationListResponseModel {
  bool? isread;
  bool? ishide;
  bool? isToastnotification;
  var createdby;
  var modifiedby;
  var id;
  var notificationId;
  var notificationreceiverId;
  var deletedAt;
  var created;
  Notification? notification;

  NotificationListResponseModel(
      {this.isread,
      this.ishide,
      this.isToastnotification,
      this.createdby,
      this.modifiedby,
      this.id,
      this.notificationId,
      this.notificationreceiverId,
      this.deletedAt,
      this.created,
      this.notification});

  NotificationListResponseModel.fromJson(Map<String, dynamic> json) {
    isread = json['isread'];
    ishide = json['ishide'];
    isToastnotification = json['is_toastnotification'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    id = json['id'];
    notificationId = json['notificationId'];
    notificationreceiverId = json['notificationreceiverId'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    notification = json['notification'] != null
        ? new Notification.fromJson(json['notification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isread'] = this.isread;
    data['ishide'] = this.ishide;
    data['is_toastnotification'] = this.isToastnotification;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['id'] = this.id;
    data['notificationId'] = this.notificationId;
    data['notificationreceiverId'] = this.notificationreceiverId;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    if (this.notification != null) {
      data['notification'] = this.notification!.toJson();
    }
    return data;
  }
}

class Notification {
  var entityId;
  var textmessage;
  var textmessageHtml;
  var createdby;
  var modifiedby;
  var id;
  var deletedAt;
  var created;
  var notificationtypesId;
  var notificationentityId;

  Notification(
      {this.entityId,
      this.textmessage,
      this.textmessageHtml,
      this.createdby,
      this.modifiedby,
      this.id,
      this.deletedAt,
      this.created,
      this.notificationtypesId,
      this.notificationentityId});

  Notification.fromJson(Map<String, dynamic> json) {
    entityId = json['entity_id'];
    textmessage = json['textmessage'];
    textmessageHtml = json['textmessage_html'];
    createdby = json['createdby'];
    modifiedby = json['modifiedby'];
    id = json['id'];
    deletedAt = json['deletedAt'];
    created = json['created'];
    notificationtypesId = json['notificationtypesId'];
    notificationentityId = json['notificationentityId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entity_id'] = this.entityId;
    data['textmessage'] = this.textmessage;
    data['textmessage_html'] = this.textmessageHtml;
    data['createdby'] = this.createdby;
    data['modifiedby'] = this.modifiedby;
    data['id'] = this.id;
    data['deletedAt'] = this.deletedAt;
    data['created'] = this.created;
    data['notificationtypesId'] = this.notificationtypesId;
    data['notificationentityId'] = this.notificationentityId;
    return data;
  }
}
