class Label {
  String name;
  String endpoint;

  Label({
    required this.name,
    required this.endpoint,
  });

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      name: json['name'],
      endpoint: json['endpoint'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'endpoint': endpoint,
    };
  }
}
