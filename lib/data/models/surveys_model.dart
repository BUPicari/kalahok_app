import 'questions_model.dart';

class Surveys { /// todo: Make this Survey only
  int id;
  int? categoryId;
  String title;
  String description;
  String waiver;
  String completionEstimatedTime;
  int status;
  int multipleSubmission;
  String startDate;
  String endDate;
  String addedAt;
  String updatedAt;
  List<Questions>? questionnaires;
  // AddedBy addedBy;

  Surveys({
    required this.id,
    this.categoryId,
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
    this.questionnaires,
    // required this.addedBy,
  });

  factory Surveys.fromJson(Map<String, dynamic> json) {
    // var addedBy = AddedBy.fromJson(json['addedBy']);
    if (json.containsKey('questionnaires')) {
      var questionnairesJson = json['questionnaires'] as List;
      List<Questions> questions = questionnairesJson.map((e) => Questions.fromJson(e)).toList();

      return Surveys(
        id: json['id'],
        categoryId: json['categoryId'],
        title: json['title'],
        description: json['description'],
        waiver: json['waiver'],
        completionEstimatedTime: json['completion_estimated_time'],
        status: json['status'] == true ? 1 : 0,
        multipleSubmission: json['multipleSubmission'] == true ? 1 : 0,
        startDate: json['start_date'],
        endDate: json['end_date'],
        addedAt: json['added_at'],
        updatedAt: json['updated_at'],
        questionnaires: questions,
        // addedBy: addedBy,
      );
    }

    return Surveys( /// todo: make this reusable that can add a key/value pair
      id: json['id'],
      categoryId: json['categoryId'],
      title: json['title'],
      description: json['description'],
      waiver: json['waiver'],
      completionEstimatedTime: json['completion_estimated_time'],
      status: json['status'] == true ? 1 : 0,
      multipleSubmission: json['multipleSubmission'] == true ? 1 : 0,
      startDate: json['start_date'],
      endDate: json['end_date'],
      addedAt: json['added_at'],
      updatedAt: json['updated_at'],
      // addedBy: addedBy,
    );
  }

  Map<String, dynamic> toJson() {
    if (questionnaires != null) {
      List<Map<String, dynamic>>? questions = questionnaires?.map((e) => e.toJson()).toList();

      return {
        'id': id,
        'category_id': categoryId,
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
        'questionnaires': questions,
        // 'added_by': addedBy,
      };
    }

    return { /// todo: make this reusable that can add a key/value pair
      'id': id,
      'category_id': categoryId,
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
      // 'added_by': addedBy,
    };
  }
}
