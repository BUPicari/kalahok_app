class Dropdown {
  int? id;
  String label;
  String value;
  String? filter;

  Dropdown({
    this.id,
    required this.label,
    required this.value,
    this.filter,
  });

  factory Dropdown.fromJson(Map<String, dynamic> json) {
    return Dropdown(
      id: json['id'],
      label: json['label'],
      value: json['value'],
      filter: json['filter'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'value': value,
      'filter': filter,
    };
  }
}
