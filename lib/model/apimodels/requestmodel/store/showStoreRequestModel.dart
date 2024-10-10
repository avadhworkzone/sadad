class ShowStoreRequestModel {
  bool? showproduct;

  ShowStoreRequestModel({this.showproduct});

  ShowStoreRequestModel.fromJson(Map<String, dynamic> json) {
    showproduct = json['showproduct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['showproduct'] = this.showproduct;
    return data;
  }
}

class DisplayPanelProductRequestModel {
  var isdisplayinpanel;

  DisplayPanelProductRequestModel({this.isdisplayinpanel});

  DisplayPanelProductRequestModel.fromJson(Map<String, dynamic> json) {
    isdisplayinpanel = json['isdisplayinpanel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isdisplayinpanel'] = this.isdisplayinpanel;
    return data;
  }
}
