import 'dart:convert';

class ServerUrl {
  String message;
  List<Payload> payloads;

  ServerUrl({
    required this.message,
    required this.payloads,
  });

  factory ServerUrl.fromJson(Map<String, dynamic> data) {
    var payloadJson = data['payload'].runtimeType == String ?
    json.decode(data['payload']) as List : data['payload'] as List;
    List<Payload> payloads = payloadJson.isNotEmpty ?
    payloadJson.map((e) => Payload.fromJson(e)).toList() : [];

    return ServerUrl(
      message: data['message'],
      payloads: payloads,
    );
  }
}

class Payload {
  String id;
  String name;
  String value;

  Payload({
    required this.id,
    required this.name,
    required this.value,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      id: json['id'],
      name: json['name'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
    };
  }
}
