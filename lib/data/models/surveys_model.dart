import 'added_by_model.dart';

class Surveys {
  int id;
  String title;
  String description;
  String waiver;
  String completionEstimatedTime;
  bool status;
  bool multipleSubmission;
  String startDate;
  String endDate;
  String addedAt;
  String updatedAt;
  AddedBy addedBy;

  Surveys({
    required this.id,
    required this.title,
    required this.description,
    required this.waiver,
    required this.completionEstimatedTime,
    required this.status,
    required this.multipleSubmission,
    required this.startDate,
    required this.endDate,
    required this.addedAt,
    required this.updatedAt,
    required this.addedBy,
  });

  factory Surveys.fromJson(Map<String, dynamic> json) {
    var addedBy = AddedBy.fromJson(json['addedBy']);

    return Surveys(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      waiver: json['waiver'],
      completionEstimatedTime: json['completion_estimated_time'],
      status: json['status'],
      multipleSubmission: json['multipleSubmission'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      addedAt: json['added_at'],
      updatedAt: json['updated_at'],
      addedBy: addedBy,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'waiver': waiver,
      'completion_estimated_time': completionEstimatedTime,
      'status': status,
      'multiple_submission': multipleSubmission,
      'start_date': startDate,
      'end_date': endDate,
      'added_at': addedAt,
      'updated_at': updatedAt,
      'added_by': addedBy,
    };
  }
}
