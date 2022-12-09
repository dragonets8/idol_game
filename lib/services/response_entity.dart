import 'entity_factory.dart';

class ResponseEntity<T> {
  T body;
  ResponseHeaders header;

  ResponseEntity({this.body, this.header});

  factory ResponseEntity.fromJson(json) {
    return ResponseEntity(
        body: EntityFactory.generateOBJ<T>(json["body"]),
        header: EntityFactory.generateAppHeaders(json["header"]));
  }
}

class ResponseHeaders {
  String tranStatus;
  String errorCode;
  String errorMessage;
  String sign;

  ResponseHeaders(
      {this.tranStatus, this.errorCode, this.errorMessage, this.sign});

  ResponseHeaders.fromJson(Map<String, dynamic> json) {
    tranStatus = json['tranStatus'];
    errorCode = json['errorCode'];
    errorMessage = json['errorMessage'];
    sign = json['sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tranStatus'] = this.tranStatus;
    data['errorCode'] = this.errorCode;
    data['errorMessage'] = this.errorMessage;
    data['sign'] = this.sign;
    return data;
  }
}
