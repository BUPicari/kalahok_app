import 'questions_model.dart';

class Surveys {
  int id;
  int? categoryId;
  int? detailsId;
  String? passcode;
  String title;
  String description;
  String? waiver;
  int? status;
  String startDate;
  String endDate;
  String? addedAt;
  String? updatedAt;
  List<Questions>? questionnaires;
  List<SurveyDetails>? details;
  int? numOfRequired;
  int? languageId;
  String? languageName;

  Surveys({
    required this.id,
    this.categoryId,
    this.detailsId,
    this.passcode,
    required this.title,
    required this.description,
    this.waiver,
    this.status,
    required this.startDate,
    required this.endDate,
    this.addedAt,
    this.updatedAt,
    this.questionnaires,
    this.details,
    this.numOfRequired,
    this.languageId,
    this.languageName,
  });

  factory Surveys.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('questionnaires')) {
      var questionnairesJson = json['questionnaires'] as List;
      List<Questions> questions = questionnairesJson.map((e) => Questions.fromJson(e)).toList();

      return Surveys(
        id: json['id'],
        categoryId: json['category_id'],
        detailsId: json['detailsId'],
        title: json['title'],
        description: json['description'],
        waiver: json['waiver'],
        status: json['status'] == true ? 1 : 0,
        startDate: json['start_date'],
        endDate: json['end_date'],
        addedAt: json['added_at'],
        updatedAt: json['updated_at'],
        questionnaires: questions,
      );
    }

    if (json.containsKey('details')) {
      var detailsJson = json['details'] as List;
      List<SurveyDetails> details = detailsJson.map((e) => SurveyDetails.fromJson(e)).toList();

      return Surveys(
        id: json['id'],
        categoryId: json['category_id'],
        passcode: json['passcode'],
        title: json['title'],
        description: json['description'],
        startDate: json['start_date'],
        endDate: json['end_date'],
        details: details,
      );
    }

    return Surveys(
      id: json['id'],
      categoryId: json['category_id'],
      detailsId: json['detailsId'],
      passcode: json['passcode'],
      title: json['title'],
      description: json['description'],
      waiver: json['waiver'],
      status: json['status'] == true ? 1 : 0,
      startDate: json['start_date'],
      endDate: json['end_date'],
      addedAt: json['added_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    if (questionnaires != null) {
      List<Map<String, dynamic>>? questions = questionnaires?.map((e) => e.toJson()).toList();

      return {
        'id': id,
        'category_id': categoryId,
        'details_id': detailsId,
        'title': title,
        'description': description,
        'waiver': waiver,
        'status': status,
        'start_date': startDate,
        'end_date': endDate,
        'added_at': addedAt,
        'updated_at': updatedAt,
        'questionnaires': questions,
      };
    }

    if (details != null) {
      List<Map<String, dynamic>>? theDetails = details?.map((e) => e.toJson()).toList();

      return {
        'id': id,
        'category_id': categoryId,
        'passcode': passcode,
        'title': title,
        'description': description,
        'start_date': startDate,
        'end_date': endDate,
        'details': theDetails,
      };
    }

    return {
      'id': id,
      'category_id': categoryId,
      'details_id': detailsId,
      'passcode': passcode,
      'title': title,
      'description': description,
      'waiver': waiver,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'added_at': addedAt,
      'updated_at': updatedAt,
    };
  }
}

class SurveyDetails {
  int id;
  SurveyLanguage language;

  SurveyDetails({
    required this.id,
    required this.language,
  });

  factory SurveyDetails.fromJson(Map<String, dynamic> json) {
    SurveyLanguage language = SurveyLanguage.fromJson(json['language']);

    return SurveyDetails(
      id: json['id'],
      language: language,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'language': language.toJson(),
    };
  }
}

class SurveyLanguage {
  int id;
  String name;

  SurveyLanguage({
    required this.id,
    required this.name,
  });

  factory SurveyLanguage.fromJson(Map<String, dynamic> json) {
    return SurveyLanguage(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
