class Dropdown {
  String name;
  int id;

  Dropdown({
    required this.name,
    required this.id,
  });

  factory Dropdown.fromJson(Map<String, dynamic> json) {
    return Dropdown(
      name: json['name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }
}
