class AddedBy {
  String id;
  String username;
  String email;
  int status;
  String addedAt;
  String updatedAt;

  AddedBy({
    required this.id,
    required this.username,
    required this.email,
    required this.status,
    required this.addedAt,
    required this.updatedAt,
  });

  factory AddedBy.fromJson(Map<String, dynamic> json) {
    return AddedBy(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      status: json['status'],
      addedAt: json['added_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': username,
      'description': email,
      'status': status,
      'added_at': addedAt,
      'updated_at': updatedAt,
    };
  }
}
