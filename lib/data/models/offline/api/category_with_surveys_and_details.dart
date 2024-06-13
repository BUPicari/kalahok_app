class CategoryWithSurveysAndDetails {
  int id;
  String name;
  String image;
  List<SurveysInCategoryWithSurveysAndDetails> surveys;

  CategoryWithSurveysAndDetails({
    required this.id,
    required this.name,
    required this.image,
    required this.surveys,
  });

  factory CategoryWithSurveysAndDetails.fromJson(Map<String, dynamic> json) {
    var surveysJson = json['survey'] as List;
    List<SurveysInCategoryWithSurveysAndDetails> tempSurveys =
      surveysJson.map((e) => SurveysInCategoryWithSurveysAndDetails.fromJson(e)).toList();

    return CategoryWithSurveysAndDetails(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      surveys: tempSurveys,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> tempSurveys = surveys.map((e) => e.toJson()).toList();

    return {
      'id': id,
      'name': name,
      'image': image,
      'surveys': tempSurveys,
    };
  }
}

class SurveysInCategoryWithSurveysAndDetails {
  int id;
  String title;
  String description;
  String passcode;
  String startDate;
  String endDate;
  List<DetailsInCategoryWithSurveysAndDetails> details;

  SurveysInCategoryWithSurveysAndDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.passcode,
    required this.startDate,
    required this.endDate,
    required this.details,
  });

  factory SurveysInCategoryWithSurveysAndDetails.fromJson(Map<String, dynamic> json) {
    var detailsJson = json['details'] as List;
    List<DetailsInCategoryWithSurveysAndDetails> tempDetails =
      detailsJson.map((e) => DetailsInCategoryWithSurveysAndDetails.fromJson(e)).toList();

    return SurveysInCategoryWithSurveysAndDetails(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      passcode: json['passcode'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      details: tempDetails,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> tempDetails = details.map((e) => e.toJson()).toList();

    return {
      'id': id,
      'title': title,
      'description': description,
      'passcode': passcode,
      'start_date': startDate,
      'end_date': endDate,
      'details': tempDetails,
    };
  }
}

class DetailsInCategoryWithSurveysAndDetails {
  int id;
  LanguageInCategoryWithSurveysAndDetails language;

  DetailsInCategoryWithSurveysAndDetails({
    required this.id,
    required this.language,
  });

  factory DetailsInCategoryWithSurveysAndDetails.fromJson(Map<String, dynamic> json) {
    var languageJson = json['language'];
    LanguageInCategoryWithSurveysAndDetails tempLanguage =
      LanguageInCategoryWithSurveysAndDetails.fromJson(languageJson);

    return DetailsInCategoryWithSurveysAndDetails(
      id: json['id'],
      language: tempLanguage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'language': language.toJson(),
    };
  }
}

class LanguageInCategoryWithSurveysAndDetails {
  int id;
  String name;

  LanguageInCategoryWithSurveysAndDetails({
    required this.id,
    required this.name,
  });

  factory LanguageInCategoryWithSurveysAndDetails.fromJson(Map<String, dynamic> json) {
    return LanguageInCategoryWithSurveysAndDetails(
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
