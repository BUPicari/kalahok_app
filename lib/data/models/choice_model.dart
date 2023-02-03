class Choice {
  String name;

  Choice({
    required this.name,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      name: json['name'],
    );
  }
}
