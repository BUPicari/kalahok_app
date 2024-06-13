import 'category.dart';

class Survey {
  int id;
  Category category;
  String title;
  String description;
  String startDate;
  String endDate;
  String passcode;
  String waiver;
  int status;
  int? numOfRequired;

  Survey({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.passcode,
    required this.waiver,
    required this.status,
    this.numOfRequired,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    var categoryJson = json['category'];
    Category category = Category.fromJson(categoryJson);

    return Survey(
      id: json['id'],
      category: category,
      title: json['title'],
      description: json['description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      passcode: json['passcode'],
      waiver: json['waiver'],
      status: json['status'] == true ? 1 : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.toJson(),
      'title': title,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'passcode': passcode,
      'waiver': waiver,
      'status': status,
    };
  }
}
