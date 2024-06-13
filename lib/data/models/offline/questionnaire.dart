import 'dart:convert';

import 'survey.dart';
import 'survey_detail.dart';
import 'response.dart';

class Questionnaire {
  int id;
  Survey survey;
  SurveyDetail surveyDetail;
  String question;
  String type;
  List<Choice> choices;
  Config configs;
  List<Label> labels;
  List<Rate> rates;
  Response? response;
  bool? hasRecording = false;
  bool? hasInput = false;

  Questionnaire({
    required this.id,
    required this.survey,
    required this.surveyDetail,
    required this.question,
    required this.type,
    required this.choices,
    required this.configs,
    required this.labels,
    required this.rates,
    this.response,
    this.hasRecording,
    this.hasInput,
  });

  factory Questionnaire.fromJson(Map<String, dynamic> data) {
    var surveyJson = data['survey'];
    Survey tempSurvey = Survey.fromJson(surveyJson);

    var surveyDetailJson = data['survey_detail'];
    SurveyDetail tempSurveyDetail = SurveyDetail.fromJson(surveyDetailJson);

    var choicesJson = data['choices'].runtimeType == String ?
      json.decode(data['choices']) as List : data['choices'] as List;
    List<Choice> tempChoices = choicesJson.isNotEmpty ?
      choicesJson.map((e) => Choice.fromJson(e)).toList() : [];

    var labelsJson = data['labels'].runtimeType == String ?
      json.decode(data['labels']) as List : data['labels'] as List;
    List<Label> tempLabels = labelsJson.isNotEmpty ?
      labelsJson.map((e) => Label.fromJson(e)).toList() : [];

    var ratesJson = data['rates'].runtimeType == String ?
      json.decode(data['rates']) as List : data['rates'] as List;
    List<Rate> tempRates = ratesJson.isNotEmpty ?
      ratesJson.map((e) => Rate.fromJson(e)).toList() : [];

    Config tempConfigs = data['configs'].runtimeType == String ?
      Config.fromJson(json.decode(data['configs'])) :
      Config.fromJson(data['configs']);

    if (tempRates.isEmpty && data['type'] == "rating") {
      tempRates.add(Rate(min: "1", max: "10"));
    }

    return Questionnaire(
      id: data['id'],
      survey: tempSurvey,
      surveyDetail: tempSurveyDetail,
      question: data['question'],
      type: data['type'],
      choices: tempChoices,
      configs: tempConfigs,
      labels: tempLabels,
      rates: tempRates,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> tempChoices = choices.map((e) => e.toJson()).toList();
    List<Map<String, dynamic>> tempRates = rates.map((e) => e.toJson()).toList();
    List<Map<String, dynamic>> tempLabels = labels.map((e) => e.toJson()).toList();
    Map<String, dynamic> tempConfigs = configs.toJson();

    return {
      'id': id,
      'survey': survey.toJson(),
      'survey_detail': surveyDetail.toJson(),
      'question': question,
      'type': type,
      'choices': json.encode(tempChoices),
      'configs': json.encode(tempConfigs),
      'labels': json.encode(tempLabels),
      'rates': json.encode(tempRates),
    };
  }
}

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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class Config {
  bool isRequired = false;
  bool multipleAnswer = false;
  bool canAddOthers = false;
  bool useYesOrNo = false;
  bool? uploadAttachments = false;
  bool? enableAudioRecording = false;
  bool? useStaticDropdown = false;

  Config({
    required this.isRequired,
    required this.multipleAnswer,
    required this.canAddOthers,
    required this.useYesOrNo,
    this.uploadAttachments,
    this.enableAudioRecording,
    this.useStaticDropdown,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      isRequired: json['isRequired'],
      multipleAnswer: json['multipleAnswer'],
      canAddOthers: json['canAddOthers'],
      useYesOrNo: json['useYesOrNo'],
      uploadAttachments: json['uploadAttachments'],
      enableAudioRecording: json['enableAudioRecording'],
      useStaticDropdown: json['useStaticDropdown'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isRequired': isRequired,
      'multipleAnswer': multipleAnswer,
      'canAddOthers': canAddOthers,
      'useYesOrNo': useYesOrNo,
      'uploadAttachments': uploadAttachments,
      'enableAudioRecording': enableAudioRecording,
      'useStaticDropdown': useStaticDropdown,
    };
  }
}

class Label {
  String name;
  String endpoint;

  Label({
    required this.name,
    required this.endpoint,
  });

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      name: json['name'],
      endpoint: json['endpoint'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'endpoint': endpoint,
    };
  }
}

class Rate {
  String min;
  String max;

  Rate({
    required this.min,
    required this.max,
  });

  factory Rate.fromJson(Map<String, dynamic> json) {
    return Rate(
      min: json['min'],
      max: json['max'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }
}
