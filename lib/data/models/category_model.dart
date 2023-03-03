import 'surveys_model.dart';

class Category {
  int id;
  String name;
  String image;
  List<Surveys>? surveys;

  Category({
    required this.id,
    required this.name,
    required this.image,
    this.surveys,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('survey')) {
      var surveysJson = json['survey'] as List;
      List<Surveys> surveyList = surveysJson.map((e) => Surveys.fromJson(e)).toList();

      return Category(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        surveys: surveyList,
      );
    }

    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    if (surveys != null) {
      List<Map<String, dynamic>>? surveyList = surveys?.map((e) => e.toJson()).toList();

      return {
        'id': id,
        'name': name,
        'image': image,
        'surveys': surveyList,
      };
    }

    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
