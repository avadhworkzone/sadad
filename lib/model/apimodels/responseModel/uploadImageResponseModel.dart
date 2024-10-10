// To parse this JSON data, do
//
//     final uploadImageResponseModel = uploadImageResponseModelFromJson(jsonString);

import 'dart:convert';

UploadImageResponseModel uploadImageResponseModelFromJson(String str) =>
    UploadImageResponseModel.fromJson(json.decode(str));

String uploadImageResponseModelToJson(UploadImageResponseModel data) =>
    json.encode(data.toJson());

class UploadImageResponseModel {
  UploadImageResponseModel({
    this.result,
  });

  Result? result;

  factory UploadImageResponseModel.fromJson(Map<String, dynamic> json) =>
      UploadImageResponseModel(
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result!.toJson(),
      };
}

class Result {
  Result({
    this.files,
    this.fields,
  });

  Files? files;
  Fields? fields;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        files: Files.fromJson(json["files"]),
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "files": files!.toJson(),
        "fields": fields!.toJson(),
      };
}

class Fields {
  Fields();

  factory Fields.fromJson(Map<String, dynamic> json) => Fields();

  Map<String, dynamic> toJson() => {};
}

class Files {
  Files({
    this.file,
  });

  List<FileElement>? file;

  factory Files.fromJson(Map<String, dynamic> json) => Files(
        file: List<FileElement>.from(
            json["file"].map((x) => FileElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "file": List<dynamic>.from(file!.map((x) => x.toJson())),
      };
}

class FileElement {
  FileElement({
    this.container,
    this.name,
    this.type,
    this.field,
    this.originalFilename,
    this.size,
    this.providerResponse,
  });

  String? container;
  String? name;
  String? type;
  String? field;
  String? originalFilename;
  int? size;
  ProviderResponse? providerResponse;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        container: json["container"],
        name: json["name"],
        type: json["type"],
        field: json["field"],
        originalFilename: json["originalFilename"],
        size: json["size"],
        providerResponse: ProviderResponse.fromJson(json["providerResponse"]),
      );

  Map<String, dynamic> toJson() => {
        "container": container,
        "name": name,
        "type": type,
        "field": field,
        "originalFilename": originalFilename,
        "size": size,
        "providerResponse": providerResponse!.toJson(),
      };
}

class ProviderResponse {
  ProviderResponse({
    this.name,
    this.etag,
    this.lastModified,
    this.size,
    this.container,
    this.location,
  });

  String? name;
  String? etag;
  dynamic lastModified;
  int? size;
  String? container;
  String? location;

  factory ProviderResponse.fromJson(Map<String, dynamic> json) =>
      ProviderResponse(
        name: json["name"],
        etag: json["etag"],
        lastModified: json["lastModified"],
        size: json["size"],
        container: json["container"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "etag": etag,
        "lastModified": lastModified,
        "size": size,
        "container": container,
        "location": location,
      };
}
