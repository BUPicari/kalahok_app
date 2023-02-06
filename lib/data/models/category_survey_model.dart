import 'surveys_model.dart';

class CategorySurvey {
  int id;
  String name;
  String image;
  List<Surveys> survey;

  CategorySurvey({
    required this.id,
    required this.name,
    required this.image,
    required this.survey,
  });

  factory CategorySurvey.fromJson(Map<String, dynamic> json) {
    var surveysJson = json['survey'] as List;
    List<Surveys> surveyList =
        surveysJson.map((e) => Surveys.fromJson(e)).toList();

    return CategorySurvey(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      survey: surveyList,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> surveyList =
        survey.map((e) => e.toJson()).toList();

    return {
      'id': id,
      'name': name,
      'image': image,
      'survey': surveyList,
    };
  }
}
