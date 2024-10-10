// To parse this JSON data, do
//
//     final identityDocumentProofing = identityDocumentProofingFromJson(jsonString);

import 'dart:convert';

List<IdentityDocumentProofing> identityDocumentProofingFromJson(String str) => List<IdentityDocumentProofing>.from(json.decode(str).map((x) => IdentityDocumentProofing.fromJson(x)));

String identityDocumentProofingToJson(List<IdentityDocumentProofing> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IdentityDocumentProofing {
  IdentityDocumentProofing({
    this.type,
    this.mentionText,
    this.confidence,
    this.id,
  });

  String? type;
  String? mentionText;
  int? confidence;
  String? id;

  factory IdentityDocumentProofing.fromJson(Map<String, dynamic> json) => IdentityDocumentProofing(
    type: json["type"] == null ? null : json["type"],
    mentionText: json["mentionText"] == null ? null : json["mentionText"],
    confidence: json["confidence"] == null ? null : json["confidence"],
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "type": type == null ? null : type,
    "mentionText": mentionText == null ? null : mentionText,
    "confidence": confidence == null ? null : confidence,
    "id": id == null ? null : id,
  };
}
